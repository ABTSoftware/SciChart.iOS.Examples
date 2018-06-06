//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class SecondaryYAxesChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.axisTitle = "Bottom Axis"
        
        let rightYAxis = SCINumericAxis()
        rightYAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        rightYAxis.axisId = "rightAxisId"
        rightYAxis.axisTitle = "Right Axis"
        rightYAxis.axisAlignment = .right
        rightYAxis.style.labelStyle.colorCode = 0xFF279B27
        
        let leftYAxis = SCINumericAxis()
        leftYAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        leftYAxis.axisId = "leftAxisId"
        leftYAxis.axisTitle = "Left Axis"
        leftYAxis.axisAlignment = .left
        leftYAxis.style.labelStyle.colorCode = 0xFF4083B7
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        
        let ds1Points = DataManager.getFourierSeries(withAmplitude: 1.0, phaseShift: 0.1, count: 5000)
        let ds2Points = DataManager.getDampedSinewave(withAmplitude: 3.0, dampingFactor: 0.005, pointCount: 5000, freq: 10)
        
        ds1.appendRangeX(ds1Points!.xValues, y: ds1Points!.yValues, count: ds1Points!.size)
        ds2.appendRangeX(ds2Points!.xValues, y: ds2Points!.yValues, count: ds2Points!.size)
        
        let rs1 = SCIFastLineRenderableSeries()
        rs1.dataSeries = ds1
        rs1.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4083B7, withThickness: 2.0)
        rs1.yAxisId = "leftAxisId"
        
        let rs2 = SCIFastLineRenderableSeries()
        rs2.dataSeries = ds2
        rs2.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 2.0)
        rs2.yAxisId = "rightAxisId"
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(leftYAxis)
            self.surface.yAxes.add(rightYAxis)
            self.surface.renderableSeries.add(rs1)
            self.surface.renderableSeries.add(rs2)
            
            rs1.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            rs2.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
