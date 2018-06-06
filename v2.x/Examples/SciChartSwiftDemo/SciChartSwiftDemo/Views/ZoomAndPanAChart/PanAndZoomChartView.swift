//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PanAndZoomChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class PanAndZoomChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(3), max: SCIGeneric(6))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        
        let data1 = DataManager.getDampedSinewave(withPad: 300, amplitude: 1.0, phase: 0.0, dampingFactor: 0.01, pointCount: 1000, freq: 10)
        let data2 = DataManager.getDampedSinewave(withPad: 300, amplitude: 1.0, phase: 0.0, dampingFactor: 0.024, pointCount: 1000, freq: 10)
        let data3 = DataManager.getDampedSinewave(withPad: 300, amplitude: 1.0, phase: 0.0, dampingFactor: 0.049, pointCount: 1000, freq: 10)
        
        ds1.appendRangeX(data1!.xValues, y: data1!.yValues, count: data1!.size)
        ds2.appendRangeX(data2!.xValues, y: data2!.yValues, count: data2!.size)
        ds3.appendRangeX(data3!.xValues, y: data3!.yValues, count: data3!.size)
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds1, brushColor: 0x77279B27, strokeColor: 0xFF177B17))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds2, brushColor: 0x77FF1919, strokeColor: 0xFFDD0909))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds3, brushColor: 0x771964FF, strokeColor: 0xFF0944CF))
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomPanModifier(), SCIZoomExtentsModifier()])
        }
    }

    fileprivate func getRenderableSeriesWith(_ dataSeries: SCIXyDataSeries, brushColor: UInt32, strokeColor: UInt32) -> SCIFastMountainRenderableSeries {
        let rSeries = SCIFastMountainRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: strokeColor, withThickness: 1)
        rSeries.areaStyle = SCISolidBrushStyle(colorCode: brushColor)
        rSeries.dataSeries = dataSeries
        rSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        
        return rSeries
    }
}
