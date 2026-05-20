//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2026. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CompositeAnnotationView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class CompositeAnnotationView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        
        let SCDPriceSeries = SCDDataManager.getPriceDataIndu()
        let size = Double(SCDPriceSeries.count)
        
        let xAxis = SCICategoryDateAxis()
        xAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        xAxis.visibleRange = SCIDoubleRange(min: size - 70, max: size)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        
        let dataSeries = SCIOhlcDataSeries(xType: .date, yType: .double)
        dataSeries.append(x: SCDPriceSeries.dateData, open: SCDPriceSeries.openData, high: SCDPriceSeries.highData, low: SCDPriceSeries.lowData, close: SCDPriceSeries.closeData)
        
        let rSeries = SCIFastCandlestickRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.strokeUpStyle = SCISolidPenStyle(color: 0xFF67BDAF, thickness: 1.0)
        rSeries.fillUpBrushStyle = SCISolidBrushStyle(color: 0x7767BDAF)
        rSeries.strokeDownStyle = SCISolidPenStyle(color: 0xFFDC7969, thickness: 1.0)
        rSeries.fillDownBrushStyle = SCISolidBrushStyle(color: 0x77DC7969)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            
            // Composite annotation defines a parent bounding box
            // All child annotations use relative coordinates (0..1)
            let compositeAnnotation = SCICompositeAnnotation()
            compositeAnnotation.set(x1: 185.0)
            compositeAnnotation.set(y1: 12300.0)
            compositeAnnotation.set(x2: 210.0)
            compositeAnnotation.set(y2: 11100.0)
            compositeAnnotation.isEditable = true
            compositeAnnotation.fillBrush =
            SCISolidBrushStyle(color: 0x33FF69BD)
            
            // Text Annotation 1
            let textAnnotation1 = SCITextAnnotation()
            textAnnotation1.coordinateMode = .relative
            textAnnotation1.set(x1: 0.25)
            textAnnotation1.set(y1: 0.75)
            textAnnotation1.text = "Text 1\n(0.25, 0.75)"
            textAnnotation1.fontStyle =
            SCIFontStyle(fontSize: 14, andTextColor: SCIColor.white)
            
            // Text Annotation 2
            let textAnnotation2 = SCITextAnnotation()
            textAnnotation2.coordinateMode = .relative
            textAnnotation2.set(x1: 0.75)
            textAnnotation2.set(y1: 0.25)
            textAnnotation2.text = "Text 2\n(0.75, 0.25)"
            textAnnotation2.fontStyle =
            SCIFontStyle(fontSize: 14, andTextColor: SCIColor.white)
            
            // Center Text Annotation
            let textAnnotationCenter = SCITextAnnotation()
            textAnnotationCenter.coordinateMode = .relative
            textAnnotationCenter.set(x1: 0.5)
            textAnnotationCenter.set(y1: 0.5)
            textAnnotationCenter.text = "Center\n(0.5, 0.5)"
            textAnnotationCenter.fontStyle =
            SCIFontStyle(fontSize: 14, andTextColor: SCIColor.white)
            
            // Line Annotation
            let lineAnnotation = SCILineAnnotation()
            lineAnnotation.coordinateMode = .relative
            lineAnnotation.set(x1: 0.2)
            lineAnnotation.set(y1: 0.2)
            lineAnnotation.set(x2: 0.8)
            lineAnnotation.set(y2: 0.8)
            lineAnnotation.stroke =
            SCISolidPenStyle(color: SCIColor.white, thickness: 2)
            
            // Add child annotations to composite
            compositeAnnotation.annotations = SCIAnnotationCollection(collection: [textAnnotation1, textAnnotation2, textAnnotationCenter, lineAnnotation])
            
            let measure = MeasureXAnnotation()
            
            measure.set(x1: 220.0)
            measure.set(y1: 11600.0)
            measure.set(x2: 250.0)
            measure.set(y2: 11300.0)
            
            // Attach Drag Listener
            let dragListener = MeasureDragListener(measure: measure, xAxis: xAxis)
            measure.annotationDragListener = dragListener
            
            // Initial update
            let calc = xAxis.currentCoordinateCalculator
            measure.updateMeasure(xAxis: calc)
            
            
            // Optional: update on selection change (closure supported here)
            measure.annotationSelectionChangedListener = { annotation, isSelected in
                let calc = xAxis.currentCoordinateCalculator
                measure.updateMeasure(xAxis: calc)
                
            }
            
            let trade = TradeSetupAnnotation(
                entry: 11500.0,
                stopLoss: 10600.0,
                takeProfit: 12200.0,
                xIndex: 215.0,
                isBuy: true
            )
            
            self.surface.annotations.add(items: compositeAnnotation, measure, trade)
            self.surface.chartModifiers.add(items: SCDExampleBaseViewController.createDefaultModifiers())
        }
        
    }
    
}

class MeasureXAnnotation: SCICompositeAnnotation {

    private let line = SCILineAnnotation()
    private let leftMarker = SCILineAnnotation()
    private let rightMarker = SCILineAnnotation()
    private let label = SCITextAnnotation()

    override init() {
        super.init()
        setup()
    }

    private func setup() {
        isEditable = true
        fillBrush = SCISolidBrushStyle(color: SCIColor.red.withAlphaComponent(0.2))

        // Parent bounds will be set externally

        // Main horizontal line
        line.stroke = SCISolidPenStyle(color: .yellow, thickness: 2)
        line.coordinateMode = .relative
        line.set(x1: 0.0)
        line.set(y1: 0.5)
        line.set(x2: 1.0)
        line.set(y2: 0.5)

        // Left vertical marker
        leftMarker.stroke = SCISolidPenStyle(color: .yellow, thickness: 2)
        leftMarker.coordinateMode = .relative
        leftMarker.set(x1: 0.0)
        leftMarker.set(y1: 0.3)
        leftMarker.set(x2: 0.0)
        leftMarker.set(y2: 0.7)

        // Right vertical marker
        rightMarker.stroke = SCISolidPenStyle(color: .yellow, thickness: 2)
        rightMarker.coordinateMode = .relative
        rightMarker.set(x1: 1.0)
        rightMarker.set(y1: 0.3)
        rightMarker.set(x2: 1.0)
        rightMarker.set(y2: 0.7)

        // Label
        label.set(x1: 0.5)
        label.set(y1: 0.6)
        label.fontStyle = SCIFontStyle(fontSize: 14, andTextColor: .white)
        label.coordinateMode = .relative

        annotations = SCIAnnotationCollection(collection: [
            line, leftMarker, rightMarker, label
        ])
    }

    /// Call this whenever annotation position changes
    func updateMeasure(xAxis: ISCICoordinateCalculator) {
        
        
         let x1: Double = self.getX1()
              let x2: Double = self.getX2()
              let y1: Double = self.getY1()
              let y2: Double = self.getY2()

        // --- Smart vertical positioning (WPF equivalent logic) ---
        if y1 > y2 {
            label.verticalAnchorPoint = .top
            label.set(y1: 0.55) // slightly above line
        } else {
            label.verticalAnchorPoint = .bottom
            label.set(y1: 0.45) // slightly below line
        }

        // --- Range calculation ---
        let minX = min(x1, x2)
        let maxX = max(x1, x2)
        let diff = maxX - minX

        // --- Label update ---
        if xAxis.isCategoryAxisCalculator {
            label.text = String(format: "%.0f days", diff)
        } else {
            label.text = String(format: "ΔX = %.2f", diff)
        }
    }
}

class MeasureDragListener: NSObject, ISCIAnnotationDragListener {
    
    weak var measure: MeasureXAnnotation?
    weak var xAxis: SCIAxisBase<ISCIComparable>?

    init(measure: MeasureXAnnotation, xAxis: SCIAxisBase<ISCIComparable>) {
        self.measure = measure
        self.xAxis = xAxis
    }

    func onDragStarted(_ annotation: ISCIAnnotation) {
        update()
    }

    func onDrag(_ annotation: any ISCIAnnotation, byXDelta xDelta: CGFloat, yDelta: CGFloat) {
        update()
    }
    
    func onDragEnded(_ annotation: ISCIAnnotation) {
        update()
    }

    private func update() {
        guard let measure = measure,
              let calc = xAxis?.currentCoordinateCalculator else { return }

        measure.updateMeasure(xAxis: calc)
    }
    
}

class TradeSetupAnnotation: SCICompositeAnnotation {

    private let entryIcon = SCIImageAnnotation()
    private let infoView = SCICustomAnnotation()
    private let slLine = SCILineAnnotation()
    private let tpLine = SCILineAnnotation()

    init(entry: Double,
         stopLoss: Double,
         takeProfit: Double,
         xIndex: Double,
         isBuy: Bool) {

        super.init()

        // ---------------------------
        // IMPORTANT: give real size
        // ---------------------------
        set(x1: xIndex - 1)
        set(x2: xIndex + 1)
        set(y1: min(stopLoss, takeProfit, entry) - 10)
        set(y2: max(stopLoss, takeProfit, entry) + 10)

        isEditable = true
        fillBrush = SCISolidBrushStyle(color: SCIColor.gray.withAlphaComponent(0.4))
        
        let y1Point: Double = getY1()
        let y2Point: Double = getY2()

        // =========================
        // ENTRY ICON (ImageAnnotation)
        // =========================
        entryIcon.set(x1: 0.5)
        entryIcon.coordinateMode = .relative
        entryIcon.set(y1: (entry - y1Point) / (y2Point - y1Point)) // normalized position
        entryIcon.image = SCIImage(named: isBuy ? "image.arrow.green" : "image.arrow.red")
        entryIcon.desiredSize = CGSize(width: 26, height: 26)

        // =========================
        // STOP LOSS LINE
        // =========================
        slLine.coordinateMode = .relative
        slLine.set(x1: 0.0)
        slLine.set(x2: 1.0)
        slLine.set(y1: (stopLoss - y1Point) / (y2Point - y1Point))
        slLine.set(y2: (stopLoss - y1Point) / (y2Point - y1Point))
        slLine.stroke = SCISolidPenStyle(color: .red, thickness: 2)

        // =========================
        // TAKE PROFIT LINE
        // =========================
        tpLine.coordinateMode = .relative
        tpLine.set(x1: 0.0)
        tpLine.set(x2: 1.0)
        tpLine.set(y1: (takeProfit - y1Point) / (y2Point - y1Point))
        tpLine.set(y2: (takeProfit - y1Point) / (y2Point - y1Point))
        tpLine.stroke = SCISolidPenStyle(color: .green, thickness: 2)

        // =========================
        // CUSTOM TOOLTIP (SCICustomAnnotation)
        // =========================
        let pnl = abs(takeProfit - entry)
        let risk = abs(entry - stopLoss)
        let rr = risk == 0 ? 0 : pnl / risk

        let view = TradeInfoView(
            text: isBuy
            ? "LONG\nR:R \(String(format: "%.2f", rr))"
            : "SHORT\nR:R \(String(format: "%.2f", rr))"
        )

        infoView.coordinateMode = .relative
        infoView.customView = view
        infoView.set(x1: 0.5)
        infoView.set(y1: 1.0)

        // =========================
        // ADD CHILDREN
        // =========================
        annotations = SCIAnnotationCollection(collection: [
            slLine,
            tpLine,
            entryIcon,
            infoView
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) not implemented")
    }
}

class TradeInfoView: SCIView {
    
    init(text: String) {
        super.init(frame: CGRect(x: 0, y: 0, width: 140, height: 50))
#if os(OSX)
        wantsLayer = true
        layer?.backgroundColor = SCIColor.black.withAlphaComponent(0.85).cgColor;
        layer?.cornerRadius = 8
#else
        
        backgroundColor = SCIColor.black.withAlphaComponent(0.85)
        layer.cornerRadius = 8
#endif
        
        let label = SCILabel(frame: bounds.insetBy(dx: 8, dy: 6))
        label.text = text
        label.textColor = .white
        label.numberOfLines = 2
        label.font = SCIFont.systemFont(ofSize: 11, weight: .medium)
        
        addSubview(label)
    }
    
    required init?(coder: NSCoder) { fatalError() }
}
