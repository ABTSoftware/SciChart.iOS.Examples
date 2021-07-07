//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StackedColumnSideBySideChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart.Protected.SCILabelProviderBase

class YearsLabelProvider: SCILabelProviderBase<SCINumericAxis> {
    let _xLabels = ["2000", "2010", "2014", "2050"]
    
    init() {
        super.init(axisType: ISCINumericAxis.self)
    }
    
    override func formatLabel(_ dataValue: ISCIComparable) -> ISCIString {
        let i = Int(dataValue.toDouble())
        return NSString(string: i >= 0 && i < 4 ? _xLabels[i] : "")
    }
    
    override func formatCursorLabel(_ dataValue: ISCIComparable) -> ISCIString {
        let i = Int(dataValue.toDouble())
        var result: String
        if (i >= 0 && i < 4) {
            result = _xLabels[i]
        } else if (i < 0) {
            result = _xLabels[0]
        } else {
            result = _xLabels[3]
        }
        return NSString(string: result)
    }
}

class StackedColumnSideBySideChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoTicks = false
        xAxis.majorDelta = NSNumber(value: 1.0)
        xAxis.minorDelta = NSNumber(value: 0.5)
        xAxis.drawMajorBands = true
        xAxis.labelProvider = YearsLabelProvider()
        
        let yAxis = SCINumericAxis()
        yAxis.drawMajorBands = true
        yAxis.axisTitle = "billions of People"
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        yAxis.autoRange = .always
        
        let china = [1.269, 1.330, 1.356, 1.304]
        let india = [1.004, 1.173, 1.236, 1.656]
        let usa = [0.282, 0.310, 0.319, 0.439]
        let indonesia = [0.214, 0.243, 0.254, 0.313]
        let brazil = [0.176, 0.201, 0.203, 0.261]
        let pakistan = [0.146, 0.184, 0.196, 0.276]
        let nigeria = [0.123, 0.152, 0.177, 0.264]
        let bangladesh = [0.130, 0.156, 0.166, 0.234]
        let russia = [0.147, 0.139, 0.142, 0.109]
        let japan = [0.126, 0.127, 0.127, 0.094]
        let restOfTheWorld = [2.466, 2.829, 3.005, 4.306]
        
        let chinaDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        chinaDataSeries.seriesName = "China"
        let indiaDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        indiaDataSeries.seriesName = "India"
        let usaDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        usaDataSeries.seriesName = "USA"
        let indonesiaDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        indonesiaDataSeries.seriesName = "Indonesia"
        let brazilDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        brazilDataSeries.seriesName = "Brazil"
        let pakistanDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        pakistanDataSeries.seriesName = "Pakistan"
        let nigeriaDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        nigeriaDataSeries.seriesName = "Nigeria"
        let bangladeshDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        bangladeshDataSeries.seriesName = "Bangladesh"
        let russiaDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        russiaDataSeries.seriesName = "Russia"
        let japanDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        japanDataSeries.seriesName = "Japan"
        let restOfTheWorldDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        restOfTheWorldDataSeries.seriesName = "Rest Of The World";
        let totalDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        totalDataSeries.seriesName = "Total"
        
        for i in 0 ..< 4 {
            chinaDataSeries.append(x: i, y: china[i])
            if (i != 2) {
                indiaDataSeries.append(x: i, y: india[i])
                usaDataSeries.append(x: i, y: usa[i])
                indonesiaDataSeries.append(x: i, y: indonesia[i])
                brazilDataSeries.append(x: i, y: brazil[i])
            } else {
                indiaDataSeries.append(x: i, y: Double.nan)
                usaDataSeries.append(x: i, y: Double.nan)
                indonesiaDataSeries.append(x: i, y: Double.nan)
                brazilDataSeries.append(x: i, y: Double.nan)
            }
            pakistanDataSeries.append(x: i, y: pakistan[i])
            nigeriaDataSeries.append(x: i, y: nigeria[i])
            bangladeshDataSeries.append(x: i, y: bangladesh[i])
            russiaDataSeries.append(x: i, y: russia[i])
            japanDataSeries.append(x: i, y: japan[i])
            restOfTheWorldDataSeries.append(x: i, y: restOfTheWorld[i])
            totalDataSeries.append(x: i, y: china[i] + india[i] + usa[i] + indonesia[i] + brazil[i] + pakistan[i] + nigeria[i] + bangladesh[i] + russia[i] + japan[i] + restOfTheWorld[i])
        }
        
        let columnCollection = SCIHorizontallyStackedColumnsCollection()
        columnCollection.add(getRenderableSeriesWith(dataSeries: chinaDataSeries, fillColor:0xff3399ff, strokeColor:0xff2D68BC))
        columnCollection.add(getRenderableSeriesWith(dataSeries: indiaDataSeries, fillColor:0xff014358, strokeColor:0xff013547))
        columnCollection.add(getRenderableSeriesWith(dataSeries: usaDataSeries, fillColor:0xff1f8a71, strokeColor:0xff1B5D46))
        columnCollection.add(getRenderableSeriesWith(dataSeries: indonesiaDataSeries, fillColor:0xffbdd63b, strokeColor:0xff7E952B))
        columnCollection.add(getRenderableSeriesWith(dataSeries: brazilDataSeries, fillColor:0xffffe00b, strokeColor:0xffAA8F0B))
        columnCollection.add(getRenderableSeriesWith(dataSeries: pakistanDataSeries, fillColor:0xfff27421, strokeColor:0xffA95419))
        columnCollection.add(getRenderableSeriesWith(dataSeries: nigeriaDataSeries, fillColor:0xffbb0000, strokeColor:0xff840000))
        columnCollection.add(getRenderableSeriesWith(dataSeries: bangladeshDataSeries, fillColor:0xff550033, strokeColor:0xff370018))
        columnCollection.add(getRenderableSeriesWith(dataSeries: russiaDataSeries, fillColor:0xff339933, strokeColor:0xff2D732D))
        columnCollection.add(getRenderableSeriesWith(dataSeries: japanDataSeries, fillColor:0xff00aba9, strokeColor:0xff006C6A))
        columnCollection.add(getRenderableSeriesWith(dataSeries: restOfTheWorldDataSeries, fillColor:0xff560068, strokeColor:0xff3D0049))
        
        let legendModifier = SCILegendModifier()
        legendModifier.position = [.left, .top]
        legendModifier.margins = SCIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(columnCollection)
            self.surface.chartModifiers.add(legendModifier)
            self.surface.chartModifiers.add(SCITooltipModifier())
        }
    }
    
    fileprivate func getRenderableSeriesWith(dataSeries: SCIXyDataSeries, fillColor: uint, strokeColor: uint) -> SCIStackedColumnRenderableSeries {
        let rSeries = SCIStackedColumnRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.fillBrushStyle = SCISolidBrushStyle(color: fillColor)
        rSeries.strokeStyle = SCISolidPenStyle(color: strokeColor, thickness: 1)
        
        SCIAnimations.wave(rSeries, duration: 3.0, andEasingFunction: SCICubicEase())
        
        return rSeries
    }
}
