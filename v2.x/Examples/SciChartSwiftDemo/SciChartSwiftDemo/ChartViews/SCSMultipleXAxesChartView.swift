//
//  SCSMultipleAxesChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSMultipleXAxesChartView: UIView {
    
    let axisX1Id = "xBottom"
    let axisY1Id = "yLeft"
    let axisX2Id = "xTop"
    let axisY2Id = "yRight"
    
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

    func completeConfiguration() {
        addSurface()
        addAxes()
        
        addRenderableSeriesWithFillData(xID: axisX1Id,yID: axisY1Id, colorCode: 0xFFFF1919)
        addRenderableSeriesWithFillData(xID: axisX1Id,yID: axisY1Id, colorCode: 0xFF279B27)
        addRenderableSeriesWithFillData(xID: axisX2Id,yID: axisY2Id, colorCode: 0xFFFC9C29)
        addRenderableSeriesWithFillData(xID: axisX2Id,yID: axisY2Id, colorCode: 0xFF4083B7)
        
        addModifiers()
    }
    
    fileprivate func addAxes() {
        
        let xAxis1 = SCINumericAxis()
        xAxis1.axisId = axisX1Id
        xAxis1.style.labelStyle.colorCode = 0xFFFF1919
        xAxis1.axisAlignment = .bottom
        surface.xAxes.add(xAxis1)
        
        let xAxis2 = SCINumericAxis()
        xAxis2.axisId = axisX2Id
        xAxis2.axisAlignment = .top
        xAxis2.style.labelStyle.colorCode = 0xFF279B27
        surface.xAxes.add(xAxis2)
        
        
        let yAxis1 = SCINumericAxis()
        yAxis1.axisId = axisY1Id
        yAxis1.axisAlignment = .left
        yAxis1.style.labelStyle.colorCode = 0xFFFC9C29
        yAxis1.growBy = SCIDoubleRange.init(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.yAxes.add(yAxis1)
        
        let yAxis2 = SCINumericAxis()
        yAxis2.axisId = axisY2Id
        yAxis2.axisAlignment = .right
        yAxis2.style.labelStyle.colorCode = 0xFF4083B7
        yAxis2.growBy = SCIDoubleRange.init(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        surface.yAxes.add(yAxis2)
    }
    
    func addModifiers(){
        let xAxisDrag1 = SCIXAxisDragModifier()
        xAxisDrag1.axisId = axisX1Id
        xAxisDrag1.dragMode = .scale
        
        let xAxisDrag2 = SCIXAxisDragModifier()
        xAxisDrag2.axisId = axisX2Id
        xAxisDrag2.dragMode = .scale
        
        let yAxisDrag1 = SCIYAxisDragModifier()
        yAxisDrag1.axisId = axisY1Id
        yAxisDrag1.dragMode = .scale
        
        let yAxisDrag2 = SCIYAxisDragModifier()
        yAxisDrag2.axisId = axisY2Id
        yAxisDrag2.dragMode = .scale
        
        let legendModifier = SCILegendModifier()
        
        surface.chartModifiers = SCIChartModifierCollection.init(childModifiers: [xAxisDrag1, xAxisDrag2, yAxisDrag1, yAxisDrag2, legendModifier])
        
    }
    
    func addRenderableSeriesWithFillData(xID:String,yID:String,colorCode:UInt){
        let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)
        
        var randomWalk:Double = 10;
        for i in 0..<150 {
            randomWalk += RandomUtil.nextDouble() - 0.498;
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(randomWalk));
        }
        
        let lineRenderableSeries = SCIFastLineRenderableSeries();
        lineRenderableSeries.strokeStyle = SCISolidPenStyle.init(colorCode:UInt32(colorCode), withThickness: 1.0);
        lineRenderableSeries.xAxisId = xID;
        lineRenderableSeries.yAxisId = yID;
        lineRenderableSeries.dataSeries = dataSeries;
        lineRenderableSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        surface.renderableSeries.add(lineRenderableSeries);
    }
}
