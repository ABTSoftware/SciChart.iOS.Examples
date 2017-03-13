//
//  SCSTooltipCustomizationChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import SciChart

class SCSTooltipCustomizationChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addModifiers()
        addAxes()
        initializeSurfaceRenderableSeries()
    }
    
    fileprivate func addAxes() {
        chartSurface.xAxes.add(SCINumericAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    func addModifiers() {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        let customBlueColor = UIColor(red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
        let customOrangeColor = UIColor(red: 226.0 / 255.0, green: 70.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0)
        let tooltipModifier = SCITooltipModifier()
        tooltipModifier.style.numberFormatter = formatter
        tooltipModifier.modifierName = "Tooltip modifier"
        tooltipModifier.style.tooltipSize = CGSize(width: CGFloat.nan, height: CGFloat.nan)
        tooltipModifier.style.colorMode = .default
        tooltipModifier.style.tooltipColor = customBlueColor
        tooltipModifier.style.tooltipOpacity = 0.8
        let textFormatting = SCITextFormattingStyle()
        textFormatting.fontSize = 14
        textFormatting.fontName = "Helvetica"
        textFormatting.color = UIColor.black
        tooltipModifier.style.dataStyle = textFormatting
        tooltipModifier.style.tooltipBorderWidth = 1
        tooltipModifier.style.tooltipBorderColor = customOrangeColor
        let pointMarker = SCIEllipsePointMarker()
        pointMarker.borderPen = SCISolidPenStyle(color: UIColor.gray, withThickness: 0.5)
        pointMarker.width = 10
        pointMarker.height = 10
        tooltipModifier.style.targetMarker = pointMarker
        chartSurface.chartModifier = tooltipModifier
    }

    
    func initializeSurfaceRenderableSeries() {
        self.attachRenderebleSeriesWithYValue(1000, andColor: UIColor(red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0), seriesName: "Curve A", isVisible: true)
        self.attachRenderebleSeriesWithYValue(2000, andColor: UIColor(red: 226.0 / 255.0, green: 70.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0), seriesName: "Curve B", isVisible: true)
    }
    
    func attachRenderebleSeriesWithYValue(_ yValue: Double, andColor color: UIColor, seriesName: String, isVisible: Bool) {
        let dataCount = 500
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        var yData = Double(arc4random_uniform(100))
        var i = 0
        while (i < dataCount) {
            let xData = SCIGeneric(i)
            let value = yData + SCSDataManager.randomize(-5.0, max: 5.0)
            yData = value
            dataSeries.appendX(xData, y: SCIGeneric(value))
            i += 1
        }
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.style.linePen = SCISolidPenStyle(color: color, withThickness: 0.5)
        rSeries.dataSeries = dataSeries
        chartSurface.renderableSeries.add(rSeries)
        chartSurface.invalidateElement()
    }
    
}
