//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// VerticalChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class VerticalChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.axisAlignment = .left
        xAxis.axisTitle = "X-Axis"
        
        let yAxis = SCINumericAxis()
        yAxis.axisAlignment = .top
        yAxis.axisTitle = "Y-Axis"
        
        let dataSeries0 = SCIXyDataSeries(xType: .double, yType: .double)
        let dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
        
        let doubleSeries = SCDDoubleSeries(capacity: 20)
        SCDDataManager.setRandomDoubleSeries(doubleSeries, count: 20)
        dataSeries0.append(x: doubleSeries.xValues, y: doubleSeries.yValues)
        
        doubleSeries.xValues.clear()
        doubleSeries.yValues.clear()
        
        SCDDataManager.setRandomDoubleSeries(doubleSeries, count: 20)
        dataSeries1.append(x: doubleSeries.xValues, y: doubleSeries.yValues)
        
        let lineSeries0 = SCIFastLineRenderableSeries()
        lineSeries0.dataSeries = dataSeries0
        lineSeries0.strokeStyle = SCISolidPenStyle(color: 0xFF47bde6, thickness: 1.0)
        
        let lineSeries1 = SCIFastLineRenderableSeries()
        lineSeries1.dataSeries = dataSeries1
        lineSeries1.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 1.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(lineSeries0)
            self.surface.renderableSeries.add(lineSeries1)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            
            SCIAnimations.sweep(lineSeries0, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(lineSeries1, duration: 3.0, easingFunction: SCICubicEase())
        }
    }
}
