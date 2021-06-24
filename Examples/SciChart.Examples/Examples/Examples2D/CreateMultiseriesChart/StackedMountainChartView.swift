//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StackedMountainChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class StackedMountainChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let yValues1 = [4.0,  7,    5.2,  9.4,  3.8,  5.1, 7.5,  12.4, 14.6, 8.1, 11.7, 14.4, 16.0, 3.7, 5.1, 6.4, 3.5, 2.5, 12.4, 16.4, 7.1, 8.0, 9.0];
        let yValues2 = [15.0, 10.1, 10.2, 10.4, 10.8, 1.1, 11.5, 3.4,  4.6,  0.1, 1.7, 14.4, 6.0, 13.7, 10.1, 8.4, 8.5, 12.5, 1.4, 0.4, 10.1, 5.0, 1.0];

        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)

        for i in 0 ..< yValues1.count {
            ds1.append(x: i, y: yValues1[i])
            ds2.append(x: i, y: yValues2[i])
        }
        
        let rSeries1 = SCIStackedMountainRenderableSeries()
        rSeries1.dataSeries = ds1
        rSeries1.strokeStyle = SCISolidPenStyle(color: 0xFFFFFFFF, thickness: 1)
        rSeries1.areaStyle = SCILinearGradientBrushStyle(start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: 1.0, y: 1.0), startColor: 0xDDDBE0E1, endColor: 0x88B6C1C3)
        
        let rSeries2 = SCIStackedMountainRenderableSeries()
        rSeries2.dataSeries = ds2
        rSeries2.strokeStyle = SCISolidPenStyle(color: 0xFFFFFFFF, thickness: 1)
        rSeries2.areaStyle = SCILinearGradientBrushStyle(start: CGPoint(x: 0.0, y: 0.0), end: CGPoint(x: 1.0, y: 1.0), startColor: 0xDDACBCCA, endColor: 0x88439AAF)

        let seriesCollection = SCIVerticallyStackedMountainsCollection()
        seriesCollection.add(rSeries1)
        seriesCollection.add(rSeries2)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(SCINumericAxis())
            self.surface.yAxes.add(SCINumericAxis())
            self.surface.renderableSeries.add(seriesCollection)
            self.surface.chartModifiers.add(SCITooltipModifier())
            
            SCIAnimations.wave(rSeries1, duration: 3.0, andEasingFunction: SCICubicEase())
            SCIAnimations.wave(rSeries2, duration: 3.0, andEasingFunction: SCICubicEase())
        }
    }
}
