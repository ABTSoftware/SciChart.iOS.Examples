//
//  SCSHeatmapChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSHeatmapChartView: UIView {
    
    var heatmapDataSeries : SCIUniformHeatmapDataSeries!
    var size: Int32 = 100
    var increment = 0
    var timer: Timer!
    var scale = 0.1
    var colorMapView = SCIChartHeatmapColourMap()
    var data = [SCIGenericType]()
    let width = 300
    let height = 200
    
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
        addAxis()
        addModifiers()
        addDataSeries()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.04,
                                         target: self,
                                         selector: #selector(SCSHeatmapChartView.updateHeatmapData),
                                         userInfo: nil,
                                         repeats: true)
        }
    }
    
    func addModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let tooltipModifier = SCITooltipModifier()
        tooltipModifier.modifierName = "TooltipModifier"
        tooltipModifier.style.colorMode = .seriesColor
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, tooltipModifier])
        
        surface.chartModifiers = groupModifier
        
        colorMapView.minimum = 0.0
        colorMapView.maximum = 200.0
        addSubview(colorMapView)
        
        let layoutViews = ["colorMapView" : colorMapView]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(8)-[colorMapView]-(>=8)-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: layoutViews))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[colorMapView]-(40)-|",
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: layoutViews))
        
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        if timer != nil {
            timer.invalidate()
        }
    }
    
    // MARK: Private Functions
    
    fileprivate func createData() {
        
        let seriesPerPeriod = 30
        
        for i in 0...seriesPerPeriod {
            
            let angle = Double.pi*2.0*Double(i)/Double(seriesPerPeriod)
            
            let zValues = UnsafeMutablePointer<Double>.allocate(capacity: width*height)
            
            let cx = 150.0
            let cy = 100.0
            
            for x in 0...width {
                for y in 0...height {
                    let v = (1.0+sin(Double(x)*0.04+angle))*50.0+(1.0+sin(Double(y)*0.1+angle))*50.0*(1.0+sin(angle*2.0))
                    let r = sqrt((Double(x)-cx)*(Double(x)-cx)+(Double(y)-cy)*(Double(y)-cy))
                    let exp = max(0.0, 1.0-r*0.008)
                    let d = (v*exp+Double(arc4random_uniform(50)))
                    zValues[x*height + y] = d

                }
            }
            
            data.append(SCIGeneric(zValues))
        }
        
        heatmapDataSeries.updateZValues(data[0], size: Int32(height*width))
        
    }
    
    fileprivate func addAxis() {
        surface.xAxes.add(SCINumericAxis())
        surface.yAxes.add(SCINumericAxis())
        surface.leftAxisAreaForcedSize = 0.0;
        surface.topAxisAreaForcedSize = 0.0;
    }
    
    fileprivate func addDataSeries() {
        
        let array2d = SCIArrayController2D(type: .double, sizeX: Int32(width), y: Int32(height))
        for i in 0...size-1 {
            for j in 0...size-1{
                array2d.setValue(SCIGeneric(i*j/10), atX: Int32(i), y: Int32(j))
            }
        }
        
        heatmapDataSeries = SCIUniformHeatmapDataSeries(zValues: array2d,
                                                        startX: SCIGeneric(0.0),
                                                        stepX: SCIGeneric(1.0),
                                                        startY: SCIGeneric(0.0),
                                                        stepY: SCIGeneric(1.0))
        
        heatmapDataSeries.seriesName = "HeatSeriesName"
        
        let countColors = 6
        
        let stops = UnsafeMutablePointer<Float>.allocate(capacity: countColors)
        stops[0] = 0.0
        stops[1] = 0.2
        stops[2] = 0.4
        stops[3] = 0.6
        stops[4] = 0.8
        stops[5] = 1.0
        
        let gradientColor = UnsafeMutablePointer<uint>.allocate(capacity: countColors)
        gradientColor[0] = 0xFF00008B;
        gradientColor[1] = 0xFF6495ED;
        gradientColor[2] = 0xFF006400;
        gradientColor[3] = 0xFF7FFF00;
        gradientColor[4] = 0xFFFFFF00;
        gradientColor[5] = 0xFFFF0000;
        
        let colorMap = SCITextureOpenGL.init(gradientCoords: stops,
                                             colors: gradientColor,
                                             count: Int32(countColors))
        
        let heatRenderableSeries = SCIFastUniformHeatmapRenderableSeries()
        heatRenderableSeries.maximum = 200.0
        heatRenderableSeries.minimum = 1.0
        heatRenderableSeries.dataSeries = heatmapDataSeries
        heatRenderableSeries.colorMap = colorMap
        
        colorMapView.colourMap = colorMap
        createData()
        surface.renderableSeries.add(heatRenderableSeries)
        
        
    }
    
    @objc func updateHeatmapData() {
        
        increment += 1
        if increment > 30 {
            increment = 0
        }
        
        heatmapDataSeries.updateZValues(data[increment], size: Int32(height*width))
        
        surface.invalidateElement()
        
    }
  
}
