//
//  SCSUsingTooltipModifierChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import SciChart

class SCSUsingTooltipModifierChartView: UIView {
    
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
        let toolTipModifier = SCITooltipModifier()
        toolTipModifier.style.colorMode = .seriesColorToDataView
        surface.chartModifiers.add(toolTipModifier)
    }
    
    func initializeSurfaceRenderableSeries() {
        self.attachLissajousCurveSeries()
        self.attachSinewaveSeries()
    }
    
    func attachSinewaveSeries() {
        let dataCount = 500
        let freq = 10
        let amplitude = 1.5
        let phase = 1.0
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        dataSeries.seriesName = "Sinewave"
        var i = 0;
        while (i < dataCount) {
            let x = 10.0 * Double(i) / Double(dataCount)
            let wn = 2.0 * Double.pi / (Double(dataCount) / Double(freq))
            let y = amplitude * sin(Double(i) * wn + phase)
            dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
            i += 1;
        }
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(color: UIColor(red:255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0), withThickness: 0.5)
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = nil
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0))
        ellipsePointMarker.height = 5
        ellipsePointMarker.width = 5
        rSeries.style.pointMarker = ellipsePointMarker
        rSeries.dataSeries = dataSeries
        rSeries.addAnimation(SCIFadeRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        surface.renderableSeries.add(rSeries)
        
    }
    
    func attachLissajousCurveSeries() {
        let dataCount = 500
        let alpha = 0.8
        let beta = 0.2
        let delta = 0.43
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        dataSeries.acceptUnsortedData = true
        dataSeries.seriesName = "Lissajou"
        var i = 0
        while (i < dataCount) {
            let x = sin(alpha * Double(i) * 0.1 + delta)
            let y = sin(beta * Double(i) * 0.1)
            dataSeries.appendX(SCIGeneric((x + 1.0) * 5.0), y: SCIGeneric(y))
            i += 1
        }
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(color: UIColor(red: 70.0 / 255.0, green: 130.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0), withThickness: 0.5)
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = nil
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: UIColor(red: 70.0 / 255.0, green: 130.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0))
        ellipsePointMarker.height = 5
        ellipsePointMarker.width = 5
        rSeries.style.pointMarker = ellipsePointMarker
        rSeries.dataSeries = dataSeries
        rSeries.addAnimation(SCIFadeRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        surface.renderableSeries.add(rSeries)
        
    }
    

}
