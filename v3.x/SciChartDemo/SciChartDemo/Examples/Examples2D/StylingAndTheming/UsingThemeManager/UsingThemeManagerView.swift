//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
                SCIThemeManager.applyTheme(to: self.surface, withThemeKey: themeKey)
                sender.setTitle(themeName, for: .normal)
            })
            alertController.addAction(actionTheme)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        if let controller = alertController.popoverPresentationController {
            controller.sourceView = self
            controller.sourceRect = sender.frame
        }
        self.window!.rootViewController!.presentedViewController?.present(alertController, animated: true, completion: nil)
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.visibleRange = SCIDoubleRange(min: 150, max: 180)
        
        let yRightAxis = SCINumericAxis()
        yRightAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yRightAxis.axisAlignment = .right
        yRightAxis.autoRange = .always
        yRightAxis.axisId = "PrimaryAxisId"
        yRightAxis.labelProvider = SCDThousandsLabelProvider()
        
        let yLeftAxis = SCINumericAxis()
        yLeftAxis.growBy = SCIDoubleRange(min: 0, max: 3)
        yLeftAxis.axisAlignment = .left
        yLeftAxis.autoRange = .always
        yLeftAxis.axisId = "SecondaryAxisId"
        yLeftAxis.labelProvider = SCDBillionsLabelProvider()
        
        let priceData = SCDDataManager.getPriceDataIndu()
        
        let mountainDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        mountainDataSeries.seriesName = "Mountain Series"
        let lineDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        lineDataSeries.seriesName = "Line Series"
        let columnDataSeries = SCIXyDataSeries(xType: .double, yType: .long)
        columnDataSeries.seriesName = "Column Series"
        let candlestickDataSeries = SCIOhlcDataSeries(xType: .double, yType: .double)
        candlestickDataSeries.seriesName = "Candlestick Series"

        mountainDataSeries.append(x: priceData.indexesAsDouble, y: SCDDataManager.offset(priceData.closeData, offset: -1000))
        lineDataSeries.append(x: priceData.indexesAsDouble, y: SCDDataManager.computeMovingAverage(of: priceData.closeData, length: 50))
        columnDataSeries.append(x: priceData.indexesAsDouble, y: priceData.volumeData)
        candlestickDataSeries.append(x: priceData.indexesAsDouble, open:priceData.openData, high:priceData.highData, low:priceData.lowData, close:priceData.closeData)
        
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
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(items: yRightAxis, yLeftAxis)
            self.surface.renderableSeries.add(items: mountainSeries, lineSeries,candlestickSeries, columnSeries)
            self.surface.chartModifiers.add(items: ExampleViewBase.createDefaultModifiers(), legendModifier)
            
            SCIAnimations.scale(mountainSeries, withZeroLine: 10500, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(lineSeries, withZeroLine: 11700, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(columnSeries, withZeroLine: 12250, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(candlestickSeries, withZeroLine: 10500, duration: 3.0, andEasingFunction: SCIElasticEase())
        }
    }
}
