//
//  SCSUsingPointMarkers.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 3/31/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSUsingPointMarkers: UIView {
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
        addAxes()
        addSeries()
        addDefaultModifiers()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addSeries() {
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds4 = SCIXyDataSeries(xType: .double, yType: .double)
        let ds5 = SCIXyDataSeries(xType: .double, yType: .double)
        
        let dataSize = 15;
        
        for i in 0..<dataSize{
            ds1.appendX(SCIGeneric(i), y: SCIGeneric(drand48()))
            ds2.appendX(SCIGeneric(i), y: SCIGeneric(1 + drand48()))
            ds3.appendX(SCIGeneric(i), y: SCIGeneric(2.5 + drand48()))
            ds4.appendX(SCIGeneric(i), y: SCIGeneric(4 + drand48()))
            ds5.appendX(SCIGeneric(i), y: SCIGeneric(5.5 + drand48()))
        }
        
        let pointMarker1:SCIEllipsePointMarker = SCIEllipsePointMarker()
        pointMarker1.width = 15
        pointMarker1.height = 15
        pointMarker1.fillStyle = SCISolidBrushStyle.init(colorCode: 0x990077ff);
        pointMarker1.strokeStyle = SCISolidPenStyle.init(colorCode:0xFFADD8E6, withThickness:2.0);
        
        let pointMarker2:SCISquarePointMarker = SCISquarePointMarker()
        pointMarker2.width = 15
        pointMarker2.height = 15
        pointMarker2.fillStyle = SCISolidBrushStyle.init(colorCode: 0x99ff0000);
        pointMarker2.strokeStyle = SCISolidPenStyle.init(colorCode:0xFFFF0000, withThickness:2.0);
        
        let pointMarker3:SCITrianglePointMarker = SCITrianglePointMarker()
        pointMarker3.width = 15
        pointMarker3.height = 15
        pointMarker3.fillStyle = SCISolidBrushStyle.init(colorCode: 0xFFFFDD00);
        pointMarker3.strokeStyle = SCISolidPenStyle.init(colorCode:0xFFFF6600, withThickness:2.0);
        
        let pointMarker4:SCICrossPointMarker = SCICrossPointMarker()
        pointMarker4.width = 15
        pointMarker4.height = 15
        pointMarker4.strokeStyle = SCISolidPenStyle.init(colorCode:0xFFFF00FF, withThickness:4.0);
        
        let pointMarker5:SCISpritePointMarker = SCISpritePointMarker()
        pointMarker5.width = 40
        pointMarker5.height = 40
        pointMarker5.textureBrush = SCITextureBrushStyle.init(texture: SCITextureOpenGL.init(image: UIImage.init(named: "Weather_Storm")))
        
        surface.renderableSeries.add(p_generateRenrerableSeries(dataSeries: ds1, pointMarker: pointMarker1, pen: SCISolidPenStyle(colorCode: 0xFFADD8E6, withThickness: 2.0)))
        surface.renderableSeries.add(p_generateRenrerableSeries(dataSeries: ds2, pointMarker: pointMarker2, pen: SCISolidPenStyle(colorCode: 0xFFFF0000, withThickness: 2.0)))
        surface.renderableSeries.add(p_generateRenrerableSeries(dataSeries: ds3, pointMarker: pointMarker3, pen: SCISolidPenStyle(colorCode: 0xFFFFFF00, withThickness: 2.0)))
        surface.renderableSeries.add(p_generateRenrerableSeries(dataSeries: ds4, pointMarker: pointMarker4, pen: SCISolidPenStyle(colorCode: 0xFFFF00FF, withThickness: 2.0)))
        surface.renderableSeries.add(p_generateRenrerableSeries(dataSeries: ds5, pointMarker: pointMarker5, pen: SCISolidPenStyle(colorCode: 0xFFF5DEB3, withThickness: 2.0)))
        
        
    }
    
    fileprivate func p_generateRenrerableSeries(dataSeries: SCIXyDataSeries, pointMarker:SCIPointMarkerProtocol, pen: SCISolidPenStyle)-> SCIFastLineRenderableSeries{
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries
        renderSeries.strokeStyle = pen
        renderSeries.style.pointMarker = pointMarker
        renderSeries.addAnimation(SCIFadeRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        
        return renderSeries
    }
}
