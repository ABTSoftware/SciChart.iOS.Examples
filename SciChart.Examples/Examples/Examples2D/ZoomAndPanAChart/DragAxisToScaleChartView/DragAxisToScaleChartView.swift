//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

class DragAxisToScaleChartView: SCDDragAxisToScaleChartViewControllerBase {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.visibleRange = SCIDoubleRange(min: 3, max: 6)
        
        let rightYAxis = SCINumericAxis()
        rightYAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        rightYAxis.axisId = "RightAxisId"
        rightYAxis.axisAlignment = .right
        rightYAxis.titleStyle = SCIFontStyle(fontSize: 18, andTextColorCode: 0xFF68bcae)
        rightYAxis.tickLabelStyle = SCIFontStyle(fontSize: 12, andTextColorCode: 0xFF68bcae)
        
        let leftYAxis = SCINumericAxis()
        leftYAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        leftYAxis.axisId = "LeftAxisId"
        leftYAxis.axisAlignment = .left
        leftYAxis.titleStyle =  SCIFontStyle(fontSize: 18,  andTextColorCode: 0xFF68bcae)
        leftYAxis.tickLabelStyle = SCIFontStyle(fontSize: 12, andTextColorCode: 0xFF68bcae)
        
        let fourierSeries = SCDDataManager.getFourierSeries(withAmplitude: 1.0, phaseShift: 0.1, count: 5000)
        let dampedSinewave = SCDDataManager.getDampedSinewave(withPad: 1500, amplitude: 3.0, phase: 0.0, dampingFactor: 0.005, pointCount: 5000, freq: 10)
        
        let mountainDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        
        mountainDataSeries.append(x: fourierSeries.xValues, y: fourierSeries.yValues)
        lineDataSeries.append(x: dampedSinewave.xValues, y: dampedSinewave.yValues)
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = mountainDataSeries
        mountainSeries.areaStyle = SCISolidBrushStyle(color: 0x7747bde6)
        mountainSeries.strokeStyle = SCISolidPenStyle(color: 0xFF47bde6, thickness: 2.0)
        mountainSeries.yAxisId = "LeftAxisId"
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = lineDataSeries
        lineSeries.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 2.0)
        lineSeries.yAxisId = "RightAxisId"
        
        xAxisDragModifier = SCIXAxisDragModifier()
        xAxisDragModifier.dragMode = selectedDragMode;
        xAxisDragModifier.isEnabled = selectedDirection == .xDirection || selectedDirection == .xyDirection;

        yAxisDragModifier = SCIYAxisDragModifier()
        yAxisDragModifier.dragMode = selectedDragMode;
        yAxisDragModifier.isEnabled = selectedDirection == .yDirection || selectedDirection == .xyDirection;
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(items: leftYAxis, rightYAxis)
            self.surface.renderableSeries.add(items: mountainSeries, lineSeries)
            self.surface.chartModifiers.add(items: self.xAxisDragModifier, self.yAxisDragModifier, SCIZoomExtentsModifier())
            
            SCIAnimations.sweep(lineSeries, duration: 3.0, easingFunction: SCICubicEase())
            SCIAnimations.scale(mountainSeries, duration: 3.0, andEasingFunction: SCICubicEase())
        }
    }
}
