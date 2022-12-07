//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ScatterSeriesChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class ScatterSeriesChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let rSeries1 = getScatterRenderableSeriesWith(pointMarker: SCITrianglePointMarker(), colorCode: 0x77e97064, negative: false)
        let rSeries2 = getScatterRenderableSeriesWith(pointMarker: SCIEllipsePointMarker(), colorCode: 0x77e8c667, negative: false)
        let rSeries3 = getScatterRenderableSeriesWith(pointMarker: SCITrianglePointMarker(), colorCode: 0x77e97064, negative: true)
        let rSeries4 = getScatterRenderableSeriesWith(pointMarker: SCIEllipsePointMarker(), colorCode: 0x77e8c667, negative: true)

        let yAxisDragModifier = SCIYAxisDragModifier()
        yAxisDragModifier.dragMode = .pan
        let cursorModifier = SCICursorModifier()
        cursorModifier.receiveHandledEvents = true
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries1)
            self.surface.renderableSeries.add(rSeries2)
            self.surface.renderableSeries.add(rSeries3)
            self.surface.renderableSeries.add(rSeries4)
            self.surface.chartModifiers.add(items: SCIZoomExtentsModifier(), SCIPinchZoomModifier(), cursorModifier, SCIXAxisDragModifier(), yAxisDragModifier)
        }
    }
    
    fileprivate func getScatterRenderableSeriesWith(pointMarker: ISCIPointMarker, colorCode: UInt32, negative: Bool) -> SCIXyScatterRenderableSeries {
        let dataSeries = SCIXyDataSeries(xType: .int, yType: .double)
        dataSeries.seriesName = pointMarker is SCIEllipsePointMarker
            ? negative ? "Negative Ellipse" : "Positive Ellipse"
            : negative ? "Negative" : "Positive"
        
        for i in 0 ..< 200 {
            let time = i < 100 ? randf(0, Double(i + 10)) / 100 : randf(0, Double(200 - i + 10)) / 100
            let y = negative ? -time * time * time : time * time * time
            
            dataSeries.append(x: i, y: y)
        }
        
        pointMarker.fillStyle = SCISolidBrushStyle(color: colorCode)
        pointMarker.strokeStyle = SCISolidPenStyle(color: 0xfffffff, thickness: 0.1)
        pointMarker.size = CGSize(width: 9, height: 9)
    
        let rSeries = SCIXyScatterRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = pointMarker
        
        SCIAnimations.wave(rSeries, duration: 2.0, delay: 0.1, andEasingFunction: SCICubicEase())
        
        return rSeries
    }
}
