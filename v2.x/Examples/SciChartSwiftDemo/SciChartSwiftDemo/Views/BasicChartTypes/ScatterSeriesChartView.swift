//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class ScatterSeriesChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let rSeries1 = getScatterRenderableSeriesWith(detalization: 3, colorCode: 0xFFffeb01, negative: false)
        let rSeries2 = getScatterRenderableSeriesWith(detalization: 6, colorCode: 0xFFffa300, negative: false)
        let rSeries3 = getScatterRenderableSeriesWith(detalization: 3, colorCode: 0xFFff6501, negative: true)
        let rSeries4 = getScatterRenderableSeriesWith(detalization: 6, colorCode: 0xFFffa300, negative: true)
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
     
        let cursorModifier = SCICursorModifier()
        cursorModifier.style.hitTestMode = .point
        cursorModifier.style.colorMode = SCITooltipColorMode.seriesColorToDataView;
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries1)
            self.surface.renderableSeries.add(rSeries2)
            self.surface.renderableSeries.add(rSeries3)
            self.surface.renderableSeries.add(rSeries4)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, SCIPinchZoomModifier(), SCIZoomExtentsModifier(), cursorModifier])
        }
    }
    
    fileprivate func getScatterRenderableSeriesWith(detalization: Int32, colorCode: UInt32, negative: Bool) -> SCIXyScatterRenderableSeries {
        let dataSeries = SCIXyDataSeries(xType: .int32, yType: .double)
        dataSeries.seriesName = detalization == 6
            ? negative ? "Negative Hex" : "Positive Hex"
            : negative ? "Negative" : "Positive"
        
        for i: UInt32 in 0..<200 {
            let time = Int32(i < 100 ? arc4random_uniform(i + 10) : arc4random_uniform(200 - i + 10))
            let y = negative ? -time * time * time : time * time * time
            
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(y))
        }
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: colorCode)
        ellipsePointMarker.strokeStyle = SCISolidPenStyle(colorCode: 0xffffffff, withThickness: 0.1)
        ellipsePointMarker.detalization = detalization
        ellipsePointMarker.height = 6
        ellipsePointMarker.width = 6
    
        let rSeries = SCIXyScatterRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = ellipsePointMarker
        
        let animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        rSeries.addAnimation(animation)
        
        return rSeries
    }
}
