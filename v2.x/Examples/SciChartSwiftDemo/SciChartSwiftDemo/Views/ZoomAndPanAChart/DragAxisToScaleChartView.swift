//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DragAxisToScaleChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class DragAxisToScaleChartView: SingleChartLayout {

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(3), max: SCIGeneric(6))
        
        let rightYAxis = SCINumericAxis()
        rightYAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        rightYAxis.axisId = "RightAxisId"
        rightYAxis.axisAlignment = .right
        rightYAxis.style.labelStyle.colorCode = 0xFF279B27
        
        let leftYAxis = SCINumericAxis()
        leftYAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        leftYAxis.axisId = "LeftAxisId"
        leftYAxis.axisAlignment = .left
        leftYAxis.style.labelStyle.colorCode = 0xFF4083B7
        
        let fourierSeries = DataManager.getFourierSeries(withAmplitude: 1.0, phaseShift: 0.1, count: 5000)
        let dampedSinewave = DataManager.getDampedSinewave(withPad: 1500, amplitude: 3.0, phase: 0.0, dampingFactor: 0.005, pointCount: 5000, freq: 10)
        
        let mountainDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        
        mountainDataSeries.appendRangeX(fourierSeries!.xValues, y: fourierSeries!.yValues, count: fourierSeries!.size)
        lineDataSeries.appendRangeX(dampedSinewave!.xValues, y: dampedSinewave!.yValues, count: dampedSinewave!.size)
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = mountainDataSeries
        mountainSeries.areaStyle = SCISolidBrushStyle(colorCode: 0x771964FF)
        mountainSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF0944CF, withThickness: 2.0)
        mountainSeries.yAxisId = "LeftAxisId"
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = lineDataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 2.0)
        lineSeries.yAxisId = "RightAxisId"
        
        let leftYAxisDM = SCIYAxisDragModifier()
        leftYAxisDM.axisId = "LeftAxisId"
        
        let rightYAxisDM = SCIYAxisDragModifier()
        rightYAxisDM.axisId = "RightAxisId"
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(leftYAxis)
            self.surface.yAxes.add(rightYAxis)
            self.surface.renderableSeries.add(mountainSeries)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIXAxisDragModifier(), leftYAxisDM, rightYAxisDM, SCIZoomExtentsModifier()])
            
            mountainSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeInOut))
            lineSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeInOut))
        }
    }
}
