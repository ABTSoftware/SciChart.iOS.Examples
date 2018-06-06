//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class StackedColumnChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        
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
        for i in 0..<porkData.count {
            let xValue = data + i;
            ds1.appendX(SCIGeneric(xValue), y: SCIGeneric(porkData[i]))
            ds2.appendX(SCIGeneric(xValue), y: SCIGeneric(vealData[i]))
            ds3.appendX(SCIGeneric(xValue), y: SCIGeneric(tomatoesData[i]))
            ds4.appendX(SCIGeneric(xValue), y: SCIGeneric(cucumberData[i]))
            ds5.appendX(SCIGeneric(xValue), y: SCIGeneric(pepperData[i]))
        }
        
        let verticalCollection1 = SCIVerticallyStackedColumnsCollection()
        verticalCollection1.add(getRenderableSeriesWith(dataSeries: ds1, fillColor: 0xff226fb7))
        verticalCollection1.add(getRenderableSeriesWith(dataSeries: ds2, fillColor: 0xffff9a2e))
        
        let verticalCollection2 = SCIVerticallyStackedColumnsCollection()
        verticalCollection2.add(getRenderableSeriesWith(dataSeries: ds3, fillColor: 0xffdc443f))
        verticalCollection2.add(getRenderableSeriesWith(dataSeries: ds4, fillColor: 0xffaad34f))
        verticalCollection2.add(getRenderableSeriesWith(dataSeries: ds5, fillColor: 0xff8562b4))
        
        let columnCollection = SCIHorizontallyStackedColumnsCollection()
        columnCollection.add(verticalCollection1)
        columnCollection.add(verticalCollection2)
        
        let xDragModifier = SCIXAxisDragModifier()
        xDragModifier.clipModeX = .none
        
        let yDragModifier = SCIYAxisDragModifier()
        yDragModifier.dragMode = .pan
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(columnCollection)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [xDragModifier, yDragModifier, SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIRolloverModifier()])

            columnCollection.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
    
    fileprivate func getRenderableSeriesWith(dataSeries: SCIXyDataSeries, fillColor: uint) -> SCIStackedColumnRenderableSeries {
        let renderableSeries = SCIStackedColumnRenderableSeries()
        renderableSeries.dataSeries = dataSeries
        renderableSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: fillColor)
        renderableSeries.strokeStyle = nil
        
        return renderableSeries
    }
}
