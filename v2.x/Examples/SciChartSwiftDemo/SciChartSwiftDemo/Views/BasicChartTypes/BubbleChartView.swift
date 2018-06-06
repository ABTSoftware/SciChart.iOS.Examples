//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BubbleChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class BubbleChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCIDateTimeAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
        
        let dataSeries = SCIXyzDataSeries(xType: .dateTime, yType: .double, zType: .double)
        let tradeTicks = DataManager.getTradeTicks()
    
        for i in 0..<tradeTicks!.count {
            let tradeData = tradeTicks![i] as! TradeData
            dataSeries.appendX(SCIGeneric(tradeData.tradeDate), y: SCIGeneric(tradeData.tradePrice), z: SCIGeneric(tradeData.tradeSize))
        }
        
        let rSeries = SCIBubbleRenderableSeries();
        rSeries.bubbleBrushStyle = SCISolidBrushStyle(colorCode: 0x50CCCCCC)
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFCCCCCC, withThickness: 1.0)
        rSeries.style.detalization = 44
        rSeries.zScaleFactor = 1.0
        rSeries.autoZRange = false
        rSeries.dataSeries = dataSeries
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = dataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xffff3333, withThickness: 2.0)
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCITooltipModifier()])
            
            rSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            lineSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
        }
    }
}
