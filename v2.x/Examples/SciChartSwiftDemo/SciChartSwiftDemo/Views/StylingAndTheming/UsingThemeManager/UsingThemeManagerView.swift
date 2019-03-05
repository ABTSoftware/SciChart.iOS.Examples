//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingThemeManagerView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class UsingThemeManagerView: UsingThemeManagerLayout {
  
    override func commonInit() {
        selectThemeButton.setTitle("Chart V4 Dark", for: .normal)
        selectThemeButton.addTarget(self, action: #selector(changeTheme), for: .touchUpInside)
    }

    @objc func changeTheme(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Theme", message: "", preferredStyle: .actionSheet)
        
        let themeNames = ["Black Steel", "Bright Spark", "Chrome", "Chart V4 Dark", "Electric", "Expression Dark", "Expression Light", "Oscilloscope"]
        let themeKeys = [SCIChart_BlackSteelStyleKey, SCIChart_Bright_SparkStyleKey, SCIChart_ChromeStyleKey, SCIChart_SciChartv4DarkStyleKey, SCIChart_ElectricStyleKey, SCIChart_ExpressionDarkStyleKey, SCIChart_ExpressionLightStyleKey, SCIChart_OscilloscopeStyleKey]
        
        for themeName: String in themeNames {
            let actionTheme = UIAlertAction(title: themeName, style: .default, handler: { (action: UIAlertAction) -> Void in
                let themeKey = themeKeys[themeNames.index(of: themeName)!]
                SCIThemeManager.applyTheme(toThemeable: self.surface, withThemeKey: themeKey)
                sender.setTitle(themeName, for: .normal)
            })
            alertController.addAction(actionTheme)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let controller = alertController.popoverPresentationController {
            controller.sourceView = self
            controller.sourceRect = sender.frame
        }
        self.window!.rootViewController!.present(alertController, animated: true, completion: nil)
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(150), max: SCIGeneric(180))
        
        let yRightAxis = SCINumericAxis()
        yRightAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yRightAxis.axisAlignment = .right
        yRightAxis.autoRange = .always
        yRightAxis.axisId = "PrimaryAxisId"
        yRightAxis.labelProvider = ThousandsLabelProvider()
        
        let yLeftAxis = SCINumericAxis()
        yLeftAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(3))
        yLeftAxis.axisAlignment = .left
        yLeftAxis.autoRange = .always
        yLeftAxis.axisId = "SecondaryAxisId"
        yLeftAxis.labelProvider = BillionsLabelProvider()
        
        let priceData = DataManager.getPriceDataIndu()
        let size = priceData!.size()
        
        let movingAverageArray = [Double](repeating: 0, count: Int(size))
        let movingAverageArrayPointer: UnsafeMutablePointer<Double> = UnsafeMutablePointer(mutating: movingAverageArray)

        let mountainDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        mountainDataSeries.seriesName = "Mountain Series"
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        lineDataSeries.seriesName = "Line Series"
        let columnDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        columnDataSeries.seriesName = "Column Series"
        let candlestickDataSeries = SCIOhlcDataSeries(xType: .double, yType: .double)
        candlestickDataSeries.seriesName = "Candlestick Series"

        mountainDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()), y: DataManager.getGenericDataArrayWithOffset(priceData!.closeData(), size: size, offset: -1000), count: size)
        let movingAverage = SCIGeneric(DataManager.computeMovingAverage(of: priceData!.closeData(), destArray: movingAverageArrayPointer, sourceArraySize: size, length: 50))
        lineDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()), y: movingAverage, count: size)
        columnDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()), y: DataManager.getGenericDataLongArray(priceData!.volumeData()), count: size)
        candlestickDataSeries.appendRangeX(DataManager.getGenericDataArray(priceData!.indexesAsDouble()),
                                           open: DataManager.getGenericDataArray(priceData!.openData()),
                                           high: DataManager.getGenericDataArray(priceData!.highData()),
                                           low: DataManager.getGenericDataArray(priceData!.lowData()),
                                           close: DataManager.getGenericDataArray(priceData!.closeData()),
                                           count: size)
        
        let mountainSeries = SCIFastMountainRenderableSeries()
        mountainSeries.dataSeries = mountainDataSeries
        mountainSeries.yAxisId = "PrimaryAxisId"

        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = lineDataSeries
        lineSeries.yAxisId = "PrimaryAxisId"
        
        let columnSeries = SCIFastColumnRenderableSeries()
        columnSeries.dataSeries = columnDataSeries
        columnSeries.yAxisId = "SecondaryAxisId"

        let candlestickSeries = SCIFastCandlestickRenderableSeries()
        candlestickSeries.dataSeries = candlestickDataSeries
        candlestickSeries.yAxisId = "PrimaryAxisId"
        
        let legendModifier = SCILegendModifier()
        legendModifier.showCheckBoxes = false
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yRightAxis)
            self.surface.yAxes.add(yLeftAxis)
            self.surface.renderableSeries.add(mountainSeries)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.renderableSeries.add(candlestickSeries)
            self.surface.renderableSeries.add(columnSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [legendModifier, SCICursorModifier(), SCIZoomExtentsModifier()])
            
            mountainSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            lineSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            columnSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            mountainSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            
            SCIThemeManager.applyDefaultTheme(toThemeable: self.surface)
        }
    }
}
