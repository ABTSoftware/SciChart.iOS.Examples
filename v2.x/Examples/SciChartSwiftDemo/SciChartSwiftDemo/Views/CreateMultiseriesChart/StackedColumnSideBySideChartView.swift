//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class YearsLabelProvider: SCIFormatterLabelProviderBase {
    override init() {
        super.init(labelFormatter: YearsLabelFormatter())
    }
}

class YearsLabelFormatter: NSObject, SCILabelFormatterProtocol {
    
    let _xLabels = ["2000", "2010", "2014", "2050"]
    
    func update(withAxis axis: SCIAxis2DProtocol!) { }
    
    func formatLabel(_ dataValue: SCIGenericType) -> NSAttributedString! {
        let i = Int(SCIGenericDouble(dataValue))
        return NSMutableAttributedString(string: i >= 0 && i < 4 ? _xLabels[i] : "")
    }
    
    func formatCursorLabel(_ dataValue: SCIGenericType) -> NSAttributedString! {
        let i = Int(SCIGenericDouble(dataValue))
        var result: String
        if (i >= 0 && i < 4) {
            result = _xLabels[i]
        } else if (i < 0) {
            result = _xLabels[0]
        } else {
            result = _xLabels[3]
        }
        return NSMutableAttributedString(string: result)
    }
}

class StackedColumnSideBySideChartView: SingleChartLayout {
   
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoTicks = false
        xAxis.majorDelta = SCIGeneric(1.0)
        xAxis.minorDelta = SCIGeneric(0.5)
        xAxis.style.drawMajorBands = true
        xAxis.labelProvider = YearsLabelProvider()
        
        let yAxis = SCINumericAxis()
        yAxis.style.drawMajorBands = true
        yAxis.axisTitle = "billions of People"
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
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
        restOfTheWorldDataSeries.seriesName = "Rest O The World";
        let totalDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        totalDataSeries.seriesName = "Total"
        
        for i in 0..<4 {
            chinaDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(china[i]))
            if (i != 2) {
                indiaDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(india[i]))
                usaDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(usa[i]))
                indonesiaDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(indonesia[i]))
                brazilDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(brazil[i]))
            } else {
                indiaDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(Double.nan))
                usaDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(Double.nan))
                indonesiaDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(Double.nan))
                brazilDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(Double.nan))
            }
            pakistanDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(pakistan[i]))
            nigeriaDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(nigeria[i]))
            bangladeshDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(bangladesh[i]))
            russiaDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(russia[i]))
            japanDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(japan[i]))
            restOfTheWorldDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(restOfTheWorld[i]))
            totalDataSeries.appendX(SCIGeneric(i), y: SCIGeneric(china[i] + india[i] + usa[i] + indonesia[i] + brazil[i] + pakistan[i] + nigeria[i] + bangladesh[i] + russia[i] + japan[i] + restOfTheWorld[i]))
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
        
        let xDragModifier = SCIXAxisDragModifier()
        xDragModifier.clipModeX = .none
        
        let yDragModifier = SCIYAxisDragModifier()
        yDragModifier.dragMode = .pan
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(columnCollection)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [xDragModifier, yDragModifier, SCILegendModifier(), SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIRolloverModifier()])
            
            columnCollection.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
    
    fileprivate func getRenderableSeriesWith(dataSeries: SCIXyDataSeries, fillColor: uint, strokeColor: uint) -> SCIStackedColumnRenderableSeries {
        let renderableSeries = SCIStackedColumnRenderableSeries()
        renderableSeries.dataSeries = dataSeries
        renderableSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: fillColor)
        renderableSeries.strokeStyle = SCISolidPenStyle(colorCode: strokeColor, withThickness: 1)
        
        return renderableSeries
    }
}
