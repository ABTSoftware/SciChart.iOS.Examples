//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

class HitTestAPIChart: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    let _hitTestInfo = SCIHitTestInfo()
//    var _alertPopup: UIAlertController!
  
    override func commonInit() {
//        surface.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSingleTap)))
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        yAxis.axisAlignment = .left
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
       
        let xData: [Double] = [0, 1,   2,   3,   4,   5,    6,   7,    8,   9]
        let yData: [Double] = [0, 0.1, 0.3, 0.5, 0.4, 0.35, 0.3, 0.25, 0.2, 0.1]
        let xValues = SCIDoubleValues()
        let yValues = SCIDoubleValues()
        for i in 0 ..< xData.count {
            xValues.add(xData[i])
            yValues.add(yData[i])
        }
        
        let dataSeries0 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries0.seriesName = "Line Series"
        dataSeries0.append(x: xValues, y: yValues)
        
        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries1.seriesName = "Mountain Series"
        dataSeries1.append(x: xValues, y: SCDDataManager .scale(yValues, scale: 0.7))
        
        let dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries2.seriesName = "Column Series"
        dataSeries2.append(x: xValues, y: SCDDataManager .scale(yValues, scale: 0.5))

        let dataSeries3 = SCIOhlcDataSeries(xType: .double, yType: .double)
        dataSeries3.seriesName = "Candlestick Series"
        dataSeries3.append(x: xValues, open: SCDDataManager.offset(yValues, offset: 0.5), high: SCDDataManager.offset(yValues, offset: 1), low: SCDDataManager.offset(yValues, offset: 0.3), close: SCDDataManager.offset(yValues, offset: 0.7))

        let pointMarker = SCIEllipsePointMarker()
        pointMarker.size = CGSize(width: 30, height: 30)
        pointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFF4682B4)
        pointMarker.strokeStyle = SCISolidPenStyle(colorCode: 0xFFE6E6FA, thickness: 2)

        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = dataSeries0
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, thickness: 2)
        lineSeries.pointMarker = pointMarker
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = dataSeries1
        mountainSeries.areaStyle = SCISolidBrushStyle(colorCode: 0xFFB0C4DE)
        mountainSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, thickness: 2)

        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = dataSeries2

        let candlestickSeries = SCIFastCandlestickRenderableSeries()
        candlestickSeries.dataSeries = dataSeries3;
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(items: lineSeries, mountainSeries, columnSeries, candlestickSeries)
            
            SCIAnimations.scale(lineSeries, duration: 1.5, andEasingFunction: SCICubicEase())
            SCIAnimations.scale(mountainSeries, duration: 1.5, andEasingFunction: SCICubicEase())
            SCIAnimations.scale(columnSeries, duration: 1.5, andEasingFunction: SCICubicEase())
            SCIAnimations.scale(candlestickSeries, duration: 1.5, andEasingFunction: SCICubicEase())
        }
    }
    
//    @objc fileprivate func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
//        let location = recognizer.location(in: recognizer.view!.superview)
//        let hitTestPoint = surface.translate(location, hitTestable: surface.renderableSeriesArea)
//
//        var resultString = String(format: "Touch at: (%.0f, %.0f)", hitTestPoint.x, hitTestPoint.y)
//        let seriesCollection = surface.renderableSeries
//        for i in 0 ..< seriesCollection.count {
//            let rSeries = seriesCollection[i]
//            rSeries.hitTest(_hitTestInfo, at: hitTestPoint)
//
//            resultString.append("\n\(rSeries.dataSeries!.seriesName!) - \(_hitTestInfo.isHit ? "true" : "false")")
//        }
//
//        _alertPopup = UIAlertController(title: "HitTestInfo", message: resultString, preferredStyle: .alert)
//        window?.rootViewController?.presentedViewController?.present(_alertPopup, animated: true, completion: nil)
//
//        perform(#selector(HitTestAPIChart.dismissAlert), with: _alertPopup, afterDelay: 1)
//    }
//
//    @objc fileprivate func dismissAlert() {
//        _alertPopup.dismiss(animated: true, completion: nil)
//    }
}
