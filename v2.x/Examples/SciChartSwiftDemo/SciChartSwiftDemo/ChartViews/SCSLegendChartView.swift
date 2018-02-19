//
//  SCSLegendChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 8/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import SciChart
import UIKit

class SCSLegendChartView: UIView {
    
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
        let legend = SCILegendModifier(position: [.left, .top], andOrientation: .vertical)
        surface.chartModifiers.add(legend!)
    }
    
    func initializeSurfaceRenderableSeries() {
        self.attachRenderebleSeriesWithYValue(1000, andColor: UIColor.yellow, seriesName: "Curve A", isVisible: true)
        self.attachRenderebleSeriesWithYValue(2000, andColor: UIColor.green, seriesName: "Curve B", isVisible: true)
        self.attachRenderebleSeriesWithYValue(3000, andColor: UIColor.red, seriesName: "Curve C", isVisible: true)
        self.attachRenderebleSeriesWithYValue(4000, andColor: UIColor.blue, seriesName: "Curve D", isVisible: false)
    }
    
    func attachRenderebleSeriesWithYValue(_ yValue: Double, andColor color: UIColor, seriesName: String, isVisible: Bool) {
        let dataCount = 10
        let dataSeries1 = SCIXyDataSeries(xType: .float, yType: .float)
        var y = yValue
        var i = 1
        while i <= dataCount {
            let x = i
            y = yValue + y
            dataSeries1.appendX(SCIGeneric(x), y: SCIGeneric(y))
            i += 1
        }
        dataSeries1.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        dataSeries1.seriesName = seriesName
        let renderableSeries1 = SCIFastLineRenderableSeries()
        renderableSeries1.strokeStyle = SCISolidPenStyle(color: color, withThickness: 0.7)
        renderableSeries1.dataSeries = dataSeries1
        renderableSeries1.isVisible = isVisible
        renderableSeries1.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        surface.renderableSeries.add(renderableSeries1)
        
    }
    
}
