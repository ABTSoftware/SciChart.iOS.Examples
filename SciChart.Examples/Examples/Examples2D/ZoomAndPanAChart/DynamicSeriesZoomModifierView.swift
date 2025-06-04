//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2021. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DynamicSeriesZoomModifierView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

// Data Sample Rate (sec) - 20 Hz
private let TimeInterval = 0.05

class DynamicSeriesZoomModifierView: SCDSingleChartViewController<SCIChartSurface> {
    
    private var _timer: Timer?
    private var _ds1: SCIXyDataSeries!
    private var _ds2: SCIXyDataSeries!
    private var _ds3: SCIXyDataSeries!
    
    private var _t = 0.0
    private var isStop: Bool = false
    
    
    let xAxis = SCINumericAxis()
    let yAxis = SCINumericAxis()
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        
        xAxis.autoRange = .always
        xAxis.axisTitle = "Time (Seconds)"
        xAxis.textFormatting = "0.0"
        
        yAxis.autoRange = .always
        yAxis.axisTitle = "Amplitude (Volts)"
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.textFormatting = "0.00"
        yAxis.cursorTextFormatting = "0.00"
        
        _ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds1.seriesName = "Orange Series"
        _ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds2.seriesName = "Blue Series"
        _ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds3.seriesName = "Green Series"
        
        let rSeries1 = SCIFastLineRenderableSeries()
        rSeries1.dataSeries = _ds1
        rSeries1.strokeStyle = SCISolidPenStyle(color: 0xFFe97064, thickness: 2)
        
        let rSeries2 = SCIFastLineRenderableSeries()
        rSeries2.dataSeries = _ds2
        rSeries2.strokeStyle = SCISolidPenStyle(color: 0xFF47bde6, thickness: 2)
        
        let rSeries3 = SCIFastLineRenderableSeries()
        rSeries3.dataSeries = _ds3
        rSeries3.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 2)
        
        let legendModifier = SCILegendModifier()
        legendModifier.margins = SCIEdgeInsets(top: 60, left: 10, bottom: 16, right: 16)
        
        let zoomPanModifier = SCIZoomPanModifier()
        zoomPanModifier.direction = .xDirection
        zoomPanModifier.panZoomDelegate = self
        
        let zoomPinchModifier = SCIPinchZoomModifier()
        zoomPinchModifier.pinchZoomDelegate = self
        
        let zoomExtentsModifier = SCIZoomExtentsModifier()
        zoomExtentsModifier.zoomExtentsDelegate = self
        
        // To hide value modifier when zooming
        let factory = SCIDefaultSeriesValueMarkerFactory { series -> Bool in
            guard series is SCIFastLineRenderableSeries else { return true }
            return self.surface.zoomState == .atExtents
        }
       let seriesValueModifier = SCISeriesValueModifier(markerFactory: factory)
        
        let annotation = SCITextAnnotation()
        annotation.text = "Pinch to Zoom In/Out.\nPan horizontally to adjust the x-axis range.\nDouble tap to Zoom Extents."
        annotation.fontStyle = SCIFontStyle(fontSize: 14, andTextColor: .white)
        annotation.set(x1: 0.4)
        annotation.set(y1: 0)
        annotation.coordinateMode = .relative
        annotation.verticalAnchorPoint = .top
        annotation.horizontalAnchorPoint = .center
       
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(self.xAxis)
            self.surface.yAxes.add(self.yAxis)
            self.surface.renderableSeries.add(rSeries1)
            self.surface.renderableSeries.add(rSeries2)
            self.surface.renderableSeries.add(rSeries3)
            self.surface.annotations.add(annotation)
            self.surface.chartModifiers.add(items: seriesValueModifier, zoomPanModifier, zoomPinchModifier, zoomExtentsModifier, legendModifier)
        }
        
        _timer = Timer.scheduledTimer(timeInterval: TimeInterval, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
#if os(OSX)
        if let _timer = _timer {
            RunLoop.main.add(_timer, forMode: .common)
        }
#endif
    }
    
    @objc func updateData(_ timer: Timer) {
            
            let y1: Double = 3.0 * sin(((2 * .pi) * 1.4) * _t * 0.02)
            let y2: Double = 2.0 * cos(((2 * .pi) * 0.8) * _t * 0.02)
            let y3: Double = 1.0 * sin(((2 * .pi) * 2.2) * _t * 0.02)
            
            _ds1.append(x: _t, y: y1)
            _ds2.append(x: _t, y: y2)
            _ds3.append(x: _t, y: y3)
            
            _t += TimeInterval;
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _timer?.invalidate()
        _timer = nil
    }
}

//MARK: - Delegate methos for Gestures
extension DynamicSeriesZoomModifierView:SCIPinchZoomModifierDelegate {
    func onPinchZoomGestureBegan(with args: SCIGestureModifierEventArgs) {
        print("onPinchZoomGestureBegan")
        
        /// Stop automatically changing the X and Y ranges as soon as the user starts pinching the chart.
        yAxis.autoRange = .never
        xAxis.autoRange = .never
    }
}

extension DynamicSeriesZoomModifierView:SCIZoomPanModifierDelegate {
    func onZoomPanGestureBegan(with args: SCIGestureModifierEventArgs) {
        print("onZoomPanGestureBegan")
        
        /// Stop automatically changing the X and Y ranges as soon as the user starts panning the chart.
        xAxis.autoRange = .never
        yAxis.autoRange = .never
    }
}

extension DynamicSeriesZoomModifierView:SCIZoomExtentsModifierDelegate {
    func performZoomExtentsCompleted() {
        print("performZoomExtentsCompleted")
        
        /// Start automatically changing the X and Y ranges as soon as the user reset the chart.
        xAxis.autoRange = .always
        yAxis.autoRange = .always
    }
}
