//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StackedColumnChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class StackedColumnChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let porkData = [10, 13, 7, 16, 4, 6, 20, 14, 16, 10, 24, 11]
        let vealData = [12, 17, 21, 15, 19, 18, 13, 21, 22, 20, 5, 10]
        let tomatoesData = [7, 30, 27, 24, 21, 15, 17, 26, 22, 28, 21, 22]
        let cucumberData = [16, 10, 9, 8, 22, 14, 12, 27, 25, 23, 17, 17]
        let pepperData = [7, 24, 21, 11, 19, 17, 14, 27, 26, 22, 28, 16]

        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        ds1.seriesName = "Pork Series"
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        ds2.seriesName = "Veal Series"
        let ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        ds3.seriesName = "Tomato Series"
        let ds4 = SCIXyDataSeries(xType: .double, yType: .double)
        ds4.seriesName = "Cucumber Series"
        let ds5 = SCIXyDataSeries(xType: .double, yType: .double)
        ds5.seriesName = "Pepper Series"
        
        let data = 1992
        for i in 0 ..< porkData.count {
            let xValue = data + i;
            ds1.append(x: xValue, y: porkData[i])
            ds2.append(x: xValue, y: vealData[i])
            ds3.append(x: xValue, y: tomatoesData[i])
            ds4.append(x: xValue, y: cucumberData[i])
            ds5.append(x: xValue, y: pepperData[i])
        }
        
        let verticalCollection1 = SCIVerticallyStackedColumnsCollection()
        verticalCollection1.add(getRenderableSeriesWith(dataSeries: ds1, fillColor: 0xff274b92))
        verticalCollection1.add(getRenderableSeriesWith(dataSeries: ds2, fillColor: 0xffe97064))
        
        let verticalCollection2 = SCIVerticallyStackedColumnsCollection()
        verticalCollection2.add(getRenderableSeriesWith(dataSeries: ds3, fillColor: 0xffae418d))
        verticalCollection2.add(getRenderableSeriesWith(dataSeries: ds4, fillColor: 0xff68bcae))
        verticalCollection2.add(getRenderableSeriesWith(dataSeries: ds5, fillColor: 0xff634e96))
        
        let columnCollection = SCIHorizontallyStackedColumnsCollection()
        columnCollection.add(verticalCollection1)
        columnCollection.add(verticalCollection2)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(SCINumericAxis())
            self.surface.yAxes.add(SCINumericAxis())
            self.surface.renderableSeries.add(columnCollection)
            self.surface.chartModifiers.add(items: SCIZoomExtentsModifier(), SCIRolloverModifier())
        }
    }
    
    fileprivate func getRenderableSeriesWith(dataSeries: SCIXyDataSeries, fillColor: UInt32) -> SCIStackedColumnRenderableSeries {
        let rSeries = SCIStackedColumnRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.fillBrushStyle = SCISolidBrushStyle(color: fillColor)
        rSeries.strokeStyle = SCISolidPenStyle(color: fillColor, thickness: 1.0)
        
        SCIAnimations.wave(rSeries, duration: 3.0, andEasingFunction: SCICubicEase())
        
        return rSeries
    }
}
