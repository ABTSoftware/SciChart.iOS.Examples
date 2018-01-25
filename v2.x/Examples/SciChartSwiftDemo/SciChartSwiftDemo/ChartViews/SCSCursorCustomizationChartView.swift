//
//  SCSCursorCustomizationChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import SciChart

class SCSCursorCustomizationChartView: UIView {
    let surface = SCIChartSurface()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        surface.chartModifiers = groupModifier
    }
    
    // MARK: initialize surface
    fileprivate func addSurface() {
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(surface)
    }
    
    // MARK: Overrided Functions
    
    func completeConfiguration() {
        addSurface()
        addModifiers()
        addAxes()
        initializeSurfaceRenderableSeries()
    }
    
    fileprivate func addAxes() {
        surface.xAxes.add(SCINumericAxis())
        surface.yAxes.add(SCINumericAxis())
    }
    
    func addModifiers() {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        let customBlueColor = UIColor(red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
        let customOrangeColor = UIColor(red: 226.0 / 255.0, green: 70.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0)
        let customRedColor = UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0)
        let cursorModifier = SCICursorModifier()
        cursorModifier.style.numberFormatter = formatter
        cursorModifier.modifierName = "Rollover modifier"
        cursorModifier.style.tooltipSize = CGSize(width: CGFloat.nan, height: CGFloat.nan)
        cursorModifier.style.colorMode = .default
        cursorModifier.style.tooltipColor = customBlueColor
        cursorModifier.style.tooltipOpacity = 0.8
        let textFormatting = SCITextFormattingStyle()
        textFormatting.fontSize = 12
        textFormatting.fontName = "Helvetica"
        textFormatting.color = UIColor.black
        cursorModifier.style.dataStyle = textFormatting
        cursorModifier.style.tooltipBorderWidth = 1
        cursorModifier.style.tooltipBorderColor = customOrangeColor
        cursorModifier.style.cursorPen = SCISolidPenStyle(color: customOrangeColor, withThickness: 0.5)
        cursorModifier.style.axisVerticalTooltipColor = customRedColor
        cursorModifier.style.axisVerticalTextStyle = textFormatting
        cursorModifier.style.axisHorizontalTooltipColor = customRedColor
        cursorModifier.style.axisHorizontalTextStyle = textFormatting
        surface.chartModifiers.add(cursorModifier)
    }

    
    func initializeSurfaceRenderableSeries() {
        self.attachRenderebleSeriesWithYValue(1000, andColor: UIColor(red: 100.0 / 255.0, green: 149.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0), seriesName: "Curve A", isVisible: true)
        self.attachRenderebleSeriesWithYValue(2000, andColor: UIColor(red: 226.0 / 255.0, green: 70.0 / 255.0, blue: 12.0 / 255.0, alpha: 1.0), seriesName: "Curve B", isVisible: true)
    }
    
    func attachRenderebleSeriesWithYValue(_ yValue: Double, andColor color: UIColor, seriesName: String, isVisible: Bool) {
        let dataCount = 500
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
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
        rSeries.strokeStyle = SCISolidPenStyle(color: color, withThickness: 0.5)
        rSeries.dataSeries = dataSeries
        
        let animation = SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        animation.repeatable = true
        rSeries.addAnimation(animation)
        
        surface.renderableSeries.add(rSeries)
        
    }
    
}
