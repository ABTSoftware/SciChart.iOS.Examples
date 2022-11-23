//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

class MultipleAxesChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    let TopAxisId = "xTop"
    let BottomAxisId = "xBottom"
    let LeftAxisId = "yLeft"
    let RightAxisId = "yRight"
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }

    override func initExample() {
        let xTopAxis = SCINumericAxis()
        xTopAxis.axisId = TopAxisId
        xTopAxis.axisAlignment = .top
        xTopAxis.tickLabelStyle = SCIFontStyle(fontSize: 12, andTextColorCode: 0xFF68bcae)
        xTopAxis.titleStyle = SCIFontStyle(fontSize: 18, andTextColorCode: 0xFF68bcae)
        
        let xBottomAxis = SCINumericAxis()
        xBottomAxis.axisId = BottomAxisId
        xBottomAxis.axisAlignment = .bottom
        xBottomAxis.tickLabelStyle = SCIFontStyle(fontSize: 12, andTextColorCode: 0xFFae418d)
        xBottomAxis.titleStyle = SCIFontStyle(fontSize: 18, andTextColorCode: 0xFFae418d)

        let yLeftAxis = SCINumericAxis()
        yLeftAxis.axisId = LeftAxisId
        yLeftAxis.growBy = SCIDoubleRange.init(min: 0.1, max: 0.1)
        yLeftAxis.axisAlignment = .left
        yLeftAxis.tickLabelStyle = SCIFontStyle(fontSize: 12, andTextColorCode: 0xFFe97064)
        yLeftAxis.titleStyle = SCIFontStyle(fontSize: 18, andTextColorCode: 0xFFe97064)
        
        let yRightAxis = SCINumericAxis()
        yRightAxis.axisId = RightAxisId
        yRightAxis.growBy = SCIDoubleRange.init(min: 0.1, max: 0.1)
        yRightAxis.axisAlignment = .right
        yRightAxis.tickLabelStyle = SCIFontStyle(fontSize: 12, andTextColorCode: 0xFF47bde6)
        yRightAxis.titleStyle = SCIFontStyle(fontSize: 18, andTextColorCode: 0xFF47bde6)

        let modifierGroup = SCDExampleBaseViewController.createDefaultModifiers()
        modifierGroup.childModifiers.add(items: SCILegendModifier(), SCIXAxisDragModifier(), SCIYAxisDragModifier())
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xTopAxis)
            self.surface.xAxes.add(xBottomAxis)
            self.surface.yAxes.add(yLeftAxis)
            self.surface.yAxes.add(yRightAxis)
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(xAxisId: self.BottomAxisId, yAxisId: self.LeftAxisId, seriesName: "Red Line", colorCode: 0xFFae418d))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(xAxisId: self.BottomAxisId, yAxisId: self.LeftAxisId, seriesName: "Green Line", colorCode: 0xFF68bcae))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(xAxisId: self.TopAxisId, yAxisId: self.RightAxisId, seriesName: "Orange Line", colorCode: 0xFFe97064))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(xAxisId: self.TopAxisId, yAxisId: self.RightAxisId, seriesName: "Blue Line", colorCode: 0xFF47bde6))

            self.surface.chartModifiers.add(modifierGroup)
        }
    }
    
    fileprivate func getRenderableSeriesWith(xAxisId: String, yAxisId: String, seriesName: String, colorCode: UInt32) -> SCIFastLineRenderableSeries {
        let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)
        dataSeries.seriesName = seriesName
        
        var randomWalk = 10.0
        for i in 0 ..< 150 {
            randomWalk += SCDRandomUtil.nextDouble() - 0.498;
            dataSeries.append(x: i, y: randomWalk);
        }
        
        let rSeries = SCIFastLineRenderableSeries();
        rSeries.strokeStyle = SCISolidPenStyle(color: colorCode, thickness: 1.0)
        rSeries.xAxisId = xAxisId
        rSeries.yAxisId = yAxisId
        rSeries.dataSeries = dataSeries
        
        SCIAnimations.sweep(rSeries, duration: 3.0, easingFunction: SCICubicEase())
        
        return rSeries
    }
}
