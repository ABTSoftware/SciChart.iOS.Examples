//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// HitTestAPIChart.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class HitTestAPIChart: SingleChartLayout {
    
    private let Count = 10
    private var _touchPoint: CGPoint!
    private var _hitTestInfo: SCIHitTestInfo!
    private var _alertPopup: UIAlertController!
  
    override func commonInit() {
        surface.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSingleTap)))
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        yAxis.axisAlignment = .left
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
       
        let xData: [Double] = [0, 1,   2,   3,   4,   5,    6,   7,    8,   9]
        let yData: [Double] = [0, 0.1, 0.3, 0.5, 0.4, 0.35, 0.3, 0.25, 0.2, 0.1]

        let dataSeries0 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries0.seriesName = "Line Series"
        dataSeries0.appendRangeX(xData , y: yData)
        
        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries1.seriesName = "Mountain Series"
        dataSeries1.appendRangeX(xData, y: yData.map { (arg) -> Double in return arg * 0.7 })
        
        let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries2.seriesName = "Column Series"
        dataSeries2.appendRangeX(xData, y: yData.map { (arg) -> Double in return arg * 0.5 })

        let dataSeries3 = SCIOhlcDataSeries(xType: .double, yType: .double)
        dataSeries3.seriesName = "Candlestick Series"
        dataSeries3.appendRangeX(xData,
                                 open: yData.map { (arg) -> Double in return arg + 0.5 },
                                 high: yData.map { (arg) -> Double in return arg + 1 },
                                 low: yData.map { (arg) -> Double in return arg + 0.3 },
                                 close: yData.map { (arg) -> Double in return arg + 0.7 })

        let pointMarker = SCIEllipsePointMarker()
        pointMarker.width = 30
        pointMarker.height = 30
        pointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFF4682B4)
        pointMarker.strokeStyle = SCISolidPenStyle(colorCode: 0xFFE6E6FA, withThickness: 2)

        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = dataSeries0
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, withThickness: 2)
        lineSeries.pointMarker = pointMarker
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = dataSeries1
        mountainSeries.areaStyle = SCISolidBrushStyle(colorCode: 0xFFB0C4DE)
        mountainSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, withThickness: 2)

        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = dataSeries2

        let candlestickSeries = SCIFastCandlestickRenderableSeries()
        candlestickSeries.dataSeries = dataSeries3;
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.renderableSeries.add(mountainSeries)
            self.surface.renderableSeries.add(columnSeries)
            self.surface.renderableSeries.add(candlestickSeries)
            
            lineSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            mountainSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            columnSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            candlestickSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
        }
        
    }
    
    @objc fileprivate func handleSingleTap(_ recognizer:UITapGestureRecognizer) {
        let location = recognizer.location(in: recognizer.view!.superview)
        
        _touchPoint = surface.renderSurface?.point(inChartFrame: location)
        var resultString = String(format: "Touch at: (%.0f, %.0f)", _touchPoint.x, _touchPoint.y)
        
        for i in 0..<surface.renderableSeries.count() {
            let renderSeries = surface.renderableSeries.item(at: UInt32(i)) as! SCIRenderableSeriesBase
            _hitTestInfo = renderSeries.hitTestProvider().hitTestAt(x: Double(_touchPoint.x), y: Double(_touchPoint.y), radius: 30, onData: renderSeries.currentRenderPassData)
            
            resultString.append(NSString.init(format: "\n%@ - %@", renderSeries.dataSeries.seriesName!, _hitTestInfo.match.boolValue ? "YES" : "NO") as String)
        }
        
        _alertPopup = UIAlertController(title: "HitTestInfo", message: resultString, preferredStyle: .alert)
        window?.rootViewController?.present(_alertPopup, animated: true, completion: nil)
        
        perform(#selector(HitTestAPIChart.dismissAlert), with: _alertPopup, afterDelay: 1)
    }

    @objc fileprivate func dismissAlert() {
        _alertPopup.dismiss(animated: true, completion: nil)
    }
}
