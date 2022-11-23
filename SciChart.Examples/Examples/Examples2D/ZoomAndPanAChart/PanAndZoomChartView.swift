//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

class PanAndZoomChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.visibleRange = SCIDoubleRange(min: 3, max: 6)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        
        let data1 = SCDDataManager.getDampedSinewave(withPad: 300, amplitude: 1.0, phase: 0.0, dampingFactor: 0.01, pointCount: 1000, freq: 10)
        let data2 = SCDDataManager.getDampedSinewave(withPad: 300, amplitude: 1.0, phase: 0.0, dampingFactor: 0.024, pointCount: 1000, freq: 10)
        let data3 = SCDDataManager.getDampedSinewave(withPad: 300, amplitude: 1.0, phase: 0.0, dampingFactor: 0.049, pointCount: 1000, freq: 10)
        
        ds1.append(x: data1.xValues, y: data1.yValues)
        ds2.append(x: data2.xValues, y: data2.yValues)
        ds3.append(x: data3.xValues, y: data3.yValues)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds1, brushColor: 0x77b4efdb, strokeColor: 0xFF68bcae))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds2, brushColor: 0x77efb4d3, strokeColor: 0xFFae418d))
            self.surface.renderableSeries.add(self.getRenderableSeriesWith(ds3, brushColor: 0x77b4bfed, strokeColor: 0xFF274b92))
            self.surface.chartModifiers.add(items: SCIPinchZoomModifier(), SCIZoomPanModifier(), SCIZoomExtentsModifier())
        }
    }

    fileprivate func getRenderableSeriesWith(_ dataSeries: SCIXyDataSeries, brushColor: UInt32, strokeColor: UInt32) -> SCIFastMountainRenderableSeries {
        let rSeries = SCIFastMountainRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(color: strokeColor, thickness: 1)
        rSeries.areaStyle = SCISolidBrushStyle(color: brushColor)
        rSeries.dataSeries = dataSeries
        
        SCIAnimations.wave(rSeries, duration: 3.0, andEasingFunction: SCICubicEase())
        
        return rSeries
    }
}
