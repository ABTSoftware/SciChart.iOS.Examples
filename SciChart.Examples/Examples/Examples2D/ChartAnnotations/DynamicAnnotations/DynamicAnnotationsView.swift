//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DynamicAnnotations.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

/*
 NOTE:
 -----
 This example demonstrates how different gestures (tap, long-press, pan, etc.)
 can be mapped to different functionalities such as:

    • Adding markers using tap
    • Drawing lines/boxes using drag
    • Removing markers using long-press → delete mode (iOS)
    • Removing markers using right-click (macOS)

These are *only sample implementations*.
You can implement delete, edit, or annotation manipulation in many other ways.
Feel free to customize the gestures to fit your app.
*/


class DynamicAnnotationsView: SCDDynamicAnnotationsViewController {
    
    // MARK: - Properties
    override var associatedType: AnyClass { SCIChartSurface.self }
    
    private let instructionAnnotation = SCITextAnnotation()
    var drawingModifier: DrawingModifier!
    
    override func initExample() {
        
        let priceSeries = SCDDataManager.getPriceDataIndu()
        let size = Double(priceSeries.count)
        
        let priceData = SCDDataManager.getPriceDataIndu()
        
        let xAxis = SCICategoryDateAxis()
        let yAxis = SCINumericAxis()
        
        xAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        xAxis.visibleRange = SCIDoubleRange(min: size - 30, max: size)
        
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        
        let dataSeries = SCIOhlcDataSeries(xType: .date, yType: .double)
        dataSeries.append(
            x: priceData.dateData,
            open: priceData.openData,
            high: priceData.highData,
            low: priceData.lowData,
            close: priceData.closeData
        )
        
        let candlesticks = SCIFastCandlestickRenderableSeries()
        candlesticks.dataSeries = dataSeries
        candlesticks.strokeUpStyle = SCISolidPenStyle(color: 0xFF67BDAF, thickness: 1)
        candlesticks.fillUpBrushStyle = SCISolidBrushStyle(color: 0x7767BDAF)
        candlesticks.strokeDownStyle = SCISolidPenStyle(color: 0xFFDC7969, thickness: 1)
        candlesticks.fillDownBrushStyle = SCISolidBrushStyle(color: 0x77DC7969)
        
        // Create the drawing modifier which handles all gestures
        drawingModifier = DrawingModifier(surface: surface, drawMode: drawMode, ohlcDataSeries: dataSeries)
        
        let axisModifier = SCIXAxisDragModifier()
        axisModifier.receiveHandledEvents = true
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(candlesticks)
            self.surface.chartModifiers.add(items: self.drawingModifier, axisModifier)
            
            SCIAnimations.wave(candlesticks, duration: 1.0, andEasingFunction: SCICubicEase())
        }
        
        addInstructionForMarkers()
    }
    
#if os(OSX)
    override func viewWillDisappear() {
        super.viewWillDisappear()
        /// Clearing gestures
        view.gestureRecognizers.forEach { view.removeGestureRecognizer($0) }
    }
#endif
    
    // MARK: - Setup
    private func addInstructionForMarkers() {
        instructionAnnotation.set(x1: 224.0)
        instructionAnnotation.set(y1: 12200.0)
        instructionAnnotation.verticalAnchorPoint = .center
#if os(OSX)
        instructionAnnotation.text =
        """
        Right click to remove a marker.
        """
#else
        instructionAnnotation.text =
        """
        Press and hold to activate delete mode, 
        then tap the × to remove a marker.
        """
#endif
        instructionAnnotation.fontStyle = SCIFontStyle(fontSize: 16, andTextColorCode: 0xFFFFFFFF)
        
        surface.annotations.add(instructionAnnotation)
    }
    
    /// When switching draw mode, clear selections & rebuild gestures
    override func didDragModeChange(_ drawMode: DrawMode) {
        self.drawMode = drawMode
        
        /// Deselect any annotation currently selected
        for annotation in surface.annotations.toArray() {
            annotation.isSelected = false
        }
        drawingModifier.drawMode = self.drawMode
#if os(iOS)
        drawingModifier.exitDeleteMode()
#else
        drawingModifier.isEditMode = false
#endif
        /// Rebuild gesture recognizers for new draw mode
        drawingModifier.reCreateGestureRecognizer()
        
    }
}

//MARK: -
class DrawingModifier: SCIGestureModifierBase {
    
    var drawMode: DrawMode?
    private weak var surface: SCIChartSurface?
    
    private var line: SCILineAnnotation?
    private var box: SCIBoxAnnotation?
    
    private var startX: Double = 0
    private var startY: Double = 0
    
    var deleteTap: SCITapGestureRecognizer?
    var ohlcDataSeries: SCIOhlcDataSeries?
    
    private var isDeleteMode = false
    private var deleteButtons: [SCIAnnotationBase: SCIImageAnnotation] = [:] // marker → delete button
    
#if os(OSX)
    /// Prevent drawing while editing annotations
    var isEditMode: Bool = false
#endif
    
    init(surface: SCIChartSurface, drawMode: DrawMode, ohlcDataSeries: SCIOhlcDataSeries?) {
        
        self.surface = surface
        self.drawMode = drawMode
        self.ohlcDataSeries = ohlcDataSeries
        super.init()
        
#if os(iOS)
        // Long press → enter delete mode
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        self.surface?.addGestureRecognizer(longPress)
        
#endif
        // Tap → delete annotation
        deleteTap = SCITapGestureRecognizer(target: self, action: #selector(handleDeleteTap(_:)))
        self.surface?.addGestureRecognizer(deleteTap ?? SCITapGestureRecognizer())
        
#if os(iOS)
        deleteTap?.isEnabled = false // enabled only in delete mode
#else
        deleteTap?.isEnabled = true
        deleteTap?.buttonMask = 2 // right-click on macOS
#endif
    }
    
    override func createGestureRecognizer() -> SCIGestureRecognizer {
        /// MARKER mode uses tap gestures
        if drawMode == .markers {
            let recognizer = SCITapGestureRecognizer()
            
#if os(iOS)
            /// iOS: require single-tap to wait for delete tap
            if let deleteTap = deleteTap {
                recognizer.require(toFail: deleteTap)
            }
#endif
            return recognizer
        }
        else {
            /// LINE/BOX MODE uses pan gesture
            let recognizer = SCIPanGestureRecognizer()
            return recognizer
        }
    }
    
    // MARK: Gesture methods
    override func onGestureBegan(with args: SCIGestureModifierEventArgs) {
        print("onGestureBegan")
        guard let surface = surface, let gesture = args.gestureRecognizer else { return }
        
        let point = gesture.location(in: surface)
        let (dataX, dataY) = convertToDataCoordinates(CGPoint(x: point.x, y: point.y))
        startX = dataX
        startY = dataY
        
        /// Create annotation when drawing begins
        switch drawMode {
        case .line:
            let annotation = self.createLineAnnotation(at: startX, y: startY)
            surface.annotations.add(annotation)
            line = annotation
        case .box:
            let annotation = self.createBoxAnnotation(at: startX, y: startY)
            surface.annotations.add(annotation)
            box = annotation
        case .markers:
            break
        case .none:
            break
        @unknown default:
            fatalError("Unexpected DrawMode value")
        }
    }
    
    override func onGestureChanged(with args: SCIGestureModifierEventArgs) {
        print("onGestureChanged")
        guard let surface = surface, let gesture = args.gestureRecognizer else { return }
        
        let point = gesture.location(in: surface)
        let (dataX, dataY) = convertToDataCoordinates(CGPoint(x: point.x, y: point.y))
        
        switch drawMode {
        case .line:
            line?.set(x2: dataX)
            line?.set(y2: dataY)
        case .box:
            box?.set(x2: dataX)
            box?.set(y2: dataY)
        case .markers:
            break
        case .none:
            break
        @unknown default:
            fatalError("Unexpected DrawMode value")
        }
    }
    
    override func onGestureEnded(with args: SCIGestureModifierEventArgs) {
        guard let gesture = args.gestureRecognizer else { return }
        print("onGestureEnded")
        switch drawMode {
        case .line:
            line?.isEditable = true
            line = nil
        case .box:
            box?.isEditable = true
            box = nil
        case .markers:
            // A tap places a marker
            guard let tapGesture = gesture as? SCITapGestureRecognizer else {break}
            handleTap(tapGesture)
            break
        case .none:
            break
        @unknown default:
            fatalError("Unexpected DrawMode value")
        }
    }
    
    // MARK: - Gesture Handlers
    /// Add Buy Marker on tap
    @objc private func handleTap(_ gesture: SCITapGestureRecognizer) {
        print("handleTap")
        guard drawMode == .markers && !isDeleteMode else { return }
        
        let point = gesture.location(in: surface)
        createTradeMarker(point)
    }
    
#if os(iOS)
    /// Enter into delete mode (iOS only)
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        print("handleLongPress")
        guard gesture.state == .began else { return }
        
        enterDeleteMode()
    }
#endif
    
    @objc private func handleDeleteTap(_ gesture: SCITapGestureRecognizer) {
        print("Delete tap")
        let point = gesture.location(in: surface)
        
#if os(OSX)
        /// macOS: right click removes marker directly
        let _ = deleteMarker(point)
        return
#else
        /// If delete mode ON
        if isDeleteMode {
            
            /// Tap on a delete button
            for (marker, deleteButton) in deleteButtons {
                if deleteButton.isHit(at: point) {
                    surface?.annotations.remove(marker)
                    surface?.annotations.remove(deleteButton)
                    deleteButtons.removeValue(forKey: marker)
                    surface?.invalidateElement()
                    
                    // If all markers are gone, exit delete mode
                    if deleteButtons.isEmpty { exitDeleteMode() }
                    return
                }
            }
            
            /// Tap anywhere else → exit delete mode
            exitDeleteMode()
            return
        }
#endif
    }
    
    
    // MARK: - Functions
    private func createTradeMarker(_ touchPoint: CGPoint) {
        guard let ohlc = ohlcDataSeries else { return }
        
        let xCoord = Double(touchPoint.x)
        let yCoord = Double(touchPoint.y)
        
        let (xVal, yVal) = convertToDataCoordinates(CGPoint(x: xCoord, y: yCoord))
        let clamped = max(0, min(Int(xVal), ohlc.count - 1))
        
        /// Determine buy/sell arrow position based on candle geometry
        let high = ohlc.highValues.getDoubleValue(at: clamped)
        let low  = ohlc.lowValues.getDoubleValue(at: clamped)
        
        // Candle midpoint
        let midY = (high + low) / 2.0
        
        // Upper tap = SELL (arrow down) ; lower tap = BUY (arrow up)
        let isUpperTap = yVal > midY
        let finalY = isUpperTap ? high : low
        let isBuy = !isUpperTap
        
        addArrowAnnotation(
            CGPoint(x: Double(clamped), y: finalY),
            isBuy: isBuy
        )
    }
    
    
    private func addArrowAnnotation(_ point: CGPoint, isBuy: Bool) {
        let arrowAnnotation = SCIImageAnnotation()
        arrowAnnotation.set(x1: Double(point.x))
        arrowAnnotation.set(y1: Double(point.y))
        arrowAnnotation.desiredSize = CGSize(width: 15, height: 15)
        arrowAnnotation.image = SCIImage(named: isBuy ? "image.arrow.green" : "image.arrow.red")
        arrowAnnotation.isEditable = false
        arrowAnnotation.annotationPosition = [.center, isBuy ? .top : .bottom]
        surface?.annotations.add(arrowAnnotation)
        surface?.invalidateElement()
    }
    
#if os(iOS)
    /// Show delete buttons on all markers
    private func enterDeleteMode() {
        deleteTap?.isEnabled = true
        isDeleteMode = true
        deleteButtons.removeAll()
        
        guard let annotations = surface?.annotations else { return }
        for annotation in annotations.toArray() {
            guard !(annotation is SCITextAnnotation) else { continue }
            
            let deleteIcon = SCIImageAnnotation()
            deleteIcon.desiredSize = CGSize(width: 15, height: 15)
            deleteIcon.image = SCIImage(named: "image.delete")
            deleteIcon.contentMode = .aspectFit
            deleteIcon.isEditable = false
            deleteIcon.annotationPosition = .bottom
            
            // Position delete button near marker
            let x1: Double = annotation.getX1()
            let y1: Double = annotation.getY1()
            deleteIcon.set(x1: x1)
            deleteIcon.set(y1: y1)
            
            surface?.annotations.add(deleteIcon)
            annotation.isEditable = false
            deleteButtons[annotation as! SCIAnnotationBase] = deleteIcon
        }
        surface?.invalidateElement()
    }
    
    /// Disable delete mode & restore interactivity
    func exitDeleteMode() {
        deleteTap?.isEnabled = false
        isDeleteMode = false
        
        for (_, btn) in deleteButtons {
            surface?.annotations.remove(btn)
        }
        
        deleteButtons.removeAll()
        surface?.annotations.toArray().forEach {
            if !($0 is SCITextAnnotation) {
                $0.isEditable = true
            }
        }
        surface?.invalidateElement()
    }
    
    
#endif
    private func deleteMarker(_ point: CGPoint) -> Bool {
        // Delete marker if tapping on one
        guard let annotations = surface?.annotations else { return false }
        for annotation in annotations.toArray() {
            if annotation.isHit(at: point) {
                surface?.annotations.remove(annotation)
                surface?.invalidateElement()
                return true
            }
        }
        return false
    }
    
    // MARK: - Helpers
    private func convertToDataCoordinates(_ point: CGPoint) -> (Double, Double) {
        if let x = xAxis?.currentCoordinateCalculator.getDataValue(Float(point.x)),
           let y = yAxis?.currentCoordinateCalculator.getDataValue(Float(point.y)) {
            return (x, y)
        }
        return(0,0)
    }
    
    private func createLineAnnotation(at x: Double, y: Double) -> SCILineAnnotation {
        let annotation = SCILineAnnotation()
        annotation.stroke = SCISolidPenStyle(color: 0xFFF7F736, thickness: 2)
        annotation.isEditable = true
        annotation.set(x1: x)
        annotation.set(y1: y)
        annotation.set(x2: x)
        annotation.set(y2: y)
#if os(OSX)
        annotation.annotationSelectionChangedListener = { annotation, isSelected in
            if isSelected {
                self.isEditMode = true
            }
            else {
                self.isEditMode = false
            }
        }
#endif
        return annotation
    }
    
    private func createBoxAnnotation(at x: Double, y: Double) -> SCIBoxAnnotation {
        let annotation = SCIBoxAnnotation()
        annotation.fillBrush = SCISolidBrushStyle(color: 0x88F7F736)
        annotation.isEditable = true
        annotation.set(x1: x)
        annotation.set(y1: y)
        annotation.set(x2: x)
        annotation.set(y2: y)
#if os(OSX)
        annotation.annotationSelectionChangedListener = { annotation, isSelected in
            if isSelected {
                self.isEditMode = true
            }
            else {
                self.isEditMode = false
            }
        }
#endif
        return annotation
    }
    
#if os(OSX)
    /// Prevent gestures from interfering with annotation drag handles
    override func gestureRecognizer(_ gestureRecognizer: NSGestureRecognizer,
                                    shouldAttemptToRecognizeWith event: NSEvent) -> Bool {
        
        if isEditMode {
            return false
        }
        return true
    }
#endif
}
