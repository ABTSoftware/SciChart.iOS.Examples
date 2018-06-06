//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MultipleAxesChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class MultipleAxesChartView: SingleChartLayout {
    
    let TopAxisId = "xTop"
    let BottomAxisId = "xBottom"
    let LeftAxisId = "yLeft"
    let RightAxisId = "yRight"
    
    override func initExample() {
        let xTopAxis = SCINumericAxis()
        xTopAxis.axisId = TopAxisId
        xTopAxis.axisAlignment = .top
        xTopAxis.style.labelStyle.colorCode = 0xFF279B27
        
        let xBottomAxis = SCINumericAxis()
        xBottomAxis.axisId = BottomAxisId
        xBottomAxis.axisAlignment = .bottom
        xBottomAxis.style.labelStyle.colorCode = 0xFFFF1919

        let yLeftAxis = SCINumericAxis()
        yLeftAxis.axisId = LeftAxisId
        yLeftAxis.growBy = SCIDoubleRange.init(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yLeftAxis.axisAlignment = .left
        yLeftAxis.style.labelStyle.colorCode = 0xFFFC9C29
        
        let yRightAxis = SCINumericAxis()
        yRightAxis.axisId = RightAxisId
        yRightAxis.growBy = SCIDoubleRange.init(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yRightAxis.axisAlignment = .right
        yRightAxis.style.labelStyle.colorCode = 0xFF4083B7
        
        let topAxisDrag = SCIXAxisDragModifier()
        topAxisDrag.axisId = TopAxisId
        let bottomAxisDrag = SCIXAxisDragModifier()
        bottomAxisDrag.axisId = BottomAxisId
        
        let leftAxisDrag = SCIYAxisDragModifier()
        leftAxisDrag.axisId = LeftAxisId
        let rightAxisDrag = SCIYAxisDragModifier()
        rightAxisDrag.axisId = RightAxisId
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xTopAxis)
            self.surface.xAxes.add(xBottomAxis)
            self.surface.yAxes.add(yLeftAxis)
            self.surface.yAxes.add(yRightAxis)
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(xAxisId: self.BottomAxisId, yAxisId: self.LeftAxisId, seriesName: "Red Line", colorCode: 0xFFFF1919))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(xAxisId: self.BottomAxisId, yAxisId: self.LeftAxisId, seriesName: "Green Line", colorCode: 0xFF279B27))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(xAxisId: self.TopAxisId, yAxisId: self.RightAxisId, seriesName: "Orange Line", colorCode: 0xFFFC9C29))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(xAxisId: self.TopAxisId, yAxisId: self.RightAxisId, seriesName: "Blue Line", colorCode: 0xFF4083B7))

            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomPanModifier(), SCIZoomExtentsModifier(), topAxisDrag, bottomAxisDrag, leftAxisDrag, rightAxisDrag, SCILegendModifier()])
        }
    }
    
    fileprivate func getRenderableSeriesWith(xAxisId: String, yAxisId: String, seriesName: String, colorCode: UInt32) -> SCIFastLineRenderableSeries {
        let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)
        dataSeries.seriesName = seriesName
        
        var randomWalk = 10.0
        for i in 0..<150 {
            randomWalk += RandomUtil.nextDouble() - 0.498;
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(randomWalk));
        }
        
        let rSeries = SCIFastLineRenderableSeries();
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: colorCode, withThickness: 1.0)
        rSeries.xAxisId = xAxisId
        rSeries.yAxisId = yAxisId
        rSeries.dataSeries = dataSeries
        
        rSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        
        return rSeries
    }
}
