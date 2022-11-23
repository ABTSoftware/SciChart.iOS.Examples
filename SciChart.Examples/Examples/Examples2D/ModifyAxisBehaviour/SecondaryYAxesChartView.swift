//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SecondaryYAxesChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SecondaryYAxesChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.axisTitle = "Bottom Axis"
        
        let rightYAxis = SCINumericAxis()
        rightYAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        rightYAxis.axisId = "rightAxisId"
        rightYAxis.axisTitle = "Right Axis"
        rightYAxis.axisAlignment = .right
        rightYAxis.titleStyle = SCIFontStyle(fontSize: 18, andTextColorCode: 0xFF68bcae)
        rightYAxis.tickLabelStyle = SCIFontStyle(fontSize: 12, andTextColorCode: 0xFF68bcae)
        
        let leftYAxis = SCINumericAxis()
        leftYAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        leftYAxis.axisId = "leftAxisId"
        leftYAxis.axisTitle = "Left Axis"
        leftYAxis.axisAlignment = .left
        leftYAxis.titleStyle = SCIFontStyle(fontSize: 18, andTextColorCode: 0xFF47bde6)
        leftYAxis.tickLabelStyle = SCIFontStyle(fontSize: 12, andTextColorCode: 0xFF47bde6)
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        
        let ds1Points = SCDDataManager.getFourierSeries(withAmplitude: 1.0, phaseShift: 0.1, count: 5000)
        let ds2Points = SCDDataManager.getDampedSinewave(withAmplitude: 3.0, dampingFactor: 0.005, pointCount: 5000, freq: 10)
        
        ds1.append(x: ds1Points.xValues, y: ds1Points.yValues)
        ds2.append(x: ds2Points.xValues, y: ds2Points.yValues)
        
        let rSeries1 = SCIFastLineRenderableSeries()
        rSeries1.dataSeries = ds1
        rSeries1.strokeStyle = SCISolidPenStyle(color: 0xFF47bde6, thickness: 2.0)
        rSeries1.yAxisId = "leftAxisId"
        
        let rSeries2 = SCIFastLineRenderableSeries()
        rSeries2.dataSeries = ds2
        rSeries2.strokeStyle = SCISolidPenStyle(color: 0xFF47bde6, thickness: 2.0)
        rSeries2.yAxisId = "rightAxisId"
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(leftYAxis)
            self.surface.yAxes.add(rightYAxis)
            self.surface.renderableSeries.add(rSeries1)
            self.surface.renderableSeries.add(rSeries2)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            
            SCIAnimations.sweep(rSeries1, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(rSeries2, duration: 3.0, easingFunction: SCICubicEase())
        }
    }
}
