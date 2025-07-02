//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeTickingStockChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class OverviewChartView: SCDOverviewChartViewControllerBase {

    override func initExample() {
        
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        
        let count = 1500
        
        let randomWalkGenerator = SCDRandomWalkGenerator()
        let data1 = randomWalkGenerator.getRandomWalkSeries(count)
        
        let randomWalkGenerator1 = SCDRandomWalkGenerator()
        let data2 = randomWalkGenerator1.getRandomWalkSeries(count)
        
        let randomWalkGenerator2 = SCDRandomWalkGenerator()
        let data3 = randomWalkGenerator2.getRandomWalkSeries(count)
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        ds1.seriesName = "Line Series"
        ds1.append(x: data1.xValues, y: data1.yValues)
        
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        ds2.seriesName = "Mountain Series"
        ds2.append(x: data2.xValues, y: data2.yValues)

        let ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        ds3.seriesName = "Column Series"
        ds3.append(x: data3.xValues, y: data3.yValues)
        
        let rSeries1 = SCIFastLineRenderableSeries()
        rSeries1.dataSeries = ds1
        rSeries1.strokeStyle = SCISolidPenStyle(color: 0xFFFF70FF, thickness: 2)
        
        let rSeries2 = SCIFastMountainRenderableSeries()
        rSeries2.dataSeries = ds2
        rSeries2.strokeStyle = SCISolidPenStyle(color: 0xFFe9Fe64, thickness: 2)
        
        let rSeries3 = SCIFastColumnRenderableSeries()
        rSeries3.dataSeries = ds3
        rSeries3.strokeStyle = SCISolidPenStyle(color: 0xFFe97064, thickness: 2)
        
        let legendModifier = SCILegendModifier()
        legendModifier.margins = SCIEdgeInsets(top: 60, left: 10, bottom: 16, right: 16)
       
        SCIUpdateSuspender.usingWith(self.mainSurface) {
            self.mainSurface.xAxes.add(xAxis)
            self.mainSurface.yAxes.add(yAxis)
            self.mainSurface.renderableSeries.add(rSeries3)
            self.mainSurface.renderableSeries.add(rSeries2)
            self.mainSurface.renderableSeries.add(rSeries1)
            
            SCIAnimations.wave(rSeries1, duration: 3.0, andEasingFunction: SCICubicEase())
            SCIAnimations.wave(rSeries2, duration: 3.0, andEasingFunction: SCICubicEase())
            SCIAnimations.wave(rSeries3, duration: 3.0, andEasingFunction: SCICubicEase())
            
            self.mainSurface.chartModifiers.add(items:SCIPinchZoomModifier(), SCIZoomPanModifier(), SCIZoomExtentsModifier(), legendModifier)
            
            /// Create overview
            let customView = self.createCustomGripView()
            
            let options = SCIOverviewOptions()
            
            var filteredSeries: [ISCIRenderableSeries]
            filteredSeries = self.mainSurface.renderableSeries.toArray().filter({ series in
                if series.isKind(of: SCIFastMountainRenderableSeries.self) {
                    return false
                }
                return true
            }).map { series in
                if series.isKind(of: SCIFastLineRenderableSeries.self) {
                    let rSeries = SCIFastMountainRenderableSeries()
                    rSeries.dataSeries = series.dataSeries
                    return rSeries
                }
                return series
            }
            
            options.renderableSeries = NSMutableArray(array: filteredSeries)
            
            //Custom Grip
            self.overviewChart.createOverviewChart(forParentSurface: self.mainSurface, grip: customView, options: options)
            
            //Default Grip
//            self.overviewChart.createOverviewChart(forParentSurface: self.mainSurface, options: options)
        }
    }
}
