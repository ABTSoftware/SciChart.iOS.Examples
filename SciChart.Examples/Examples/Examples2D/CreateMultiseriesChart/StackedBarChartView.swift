//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StackedBarChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class StackedBarChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
   
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.axisAlignment = .left
        
        let yAxis = SCINumericAxis()
        yAxis.axisAlignment = .bottom
        yAxis.flipCoordinates = true
        
        let yValues1 = [0.0, 0.1, 0.2, 0.4, 0.8, 1.1, 1.5, 2.4, 4.6, 8.1, 11.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 5.4, 6.4, 7.1, 8.0, 9.0]
        let yValues2 = [2.0, 10.1, 10.2, 10.4, 10.8, 1.1, 11.5, 3.4, 4.6, 0.1, 1.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 1.4, 0.4, 10.1, 0.0, 0.0]
        let yValues3 = [20.0, 4.1, 4.2, 10.4, 10.8, 1.1, 11.5, 3.4, 4.6, 5.1, 5.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 1.4, 10.4, 8.1, 10.0, 15.0]
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        ds1.seriesName = "Data 1"
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        ds2.seriesName = "Data 2"
        let ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        ds3.seriesName = "Data 3"
        
        for i in 0 ..< yValues1.count {
            ds1.append(x: i, y: yValues1[i])
            ds2.append(x: i, y: yValues2[i])
            ds3.append(x: i, y: yValues3[i])
        }
     
        SCIUpdateSuspender.usingWith(surface) {
            let columnCollection = SCIVerticallyStackedColumnsCollection()
            columnCollection.add(self.getRenderableSeriesWith(dataSeries: ds1, startColor: 0xff567893, endColor:0xff3D5568))
            columnCollection.add(self.getRenderableSeriesWith(dataSeries: ds2, startColor: 0xffACBCCA, endColor:0xff439AAF))
            columnCollection.add(self.getRenderableSeriesWith(dataSeries: ds3, startColor: 0xffDBE0E1, endColor:0xffB6C1C3))
            
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(columnCollection)
            self.surface.chartModifiers.add(items: SCIZoomExtentsModifier(), SCICursorModifier())
        }
    }
    
    fileprivate func getRenderableSeriesWith(dataSeries: SCIXyDataSeries, startColor: uint, endColor: uint) -> SCIStackedColumnRenderableSeries {
        let rSeries = SCIStackedColumnRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.fillBrushStyle = SCILinearGradientBrushStyle(start: CGPoint(x: 0.5, y: 0.0), end: CGPoint(x: 0.5, y: 1.0), startColor: startColor, endColor: endColor)
        rSeries.strokeStyle = SCISolidPenStyle(color: .black, thickness: 0.5)
        
        SCIAnimations.wave(rSeries, duration: 3.0, andEasingFunction: SCICubicEase())
        
        return rSeries
    }
    
}
