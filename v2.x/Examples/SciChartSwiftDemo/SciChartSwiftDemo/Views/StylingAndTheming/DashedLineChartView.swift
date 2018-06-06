//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DashedLineChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class DashedLineChartView: SingleChartLayout {

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        var dataCount = 20
        let priceDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        for i in 0..<dataCount {
            let time = 10 * Double(i) / Double(dataCount)
            let y = arc4random_uniform(20)
            
            priceDataSeries.appendX(SCIGeneric(time), y: SCIGeneric(y))
        }
        
        dataCount = 1000
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        for i in 0..<dataCount {
            let time = 10 * Double(i) / Double(dataCount)
            let y = 2 * sin(time) + 10
            
            fourierDataSeries.appendX(SCIGeneric(time), y: SCIGeneric(y))
        }
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFFd6ffd7)
        ellipsePointMarker.height = 5
        ellipsePointMarker.width = 5
        
        let priceSeries = SCIFastLineRenderableSeries()
        priceSeries.pointMarker = ellipsePointMarker
        priceSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 1.0, andStrokeDash: [10.0, 3.0, 10.0, 3.0])
        priceSeries.dataSeries = priceDataSeries
        
        let fourierSeries = SCIFastLineRenderableSeries()
        fourierSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4c8aff, withThickness: 1.0, andStrokeDash: [50.0, 14.0, 50.0, 14.0, 50.0, 14.0, 50.0, 14.0])
        fourierSeries.dataSeries = fourierDataSeries
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(priceSeries)
            self.surface.renderableSeries.add(fourierSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomPanModifier(), SCIZoomExtentsModifier()])
            
            priceSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            fourierSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
