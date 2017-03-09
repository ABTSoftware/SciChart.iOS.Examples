//
//  SCSBandChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSBandChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addModifiers()
        addDataSeries()
    }
    
    func addModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.modifierName = xAxisDragModifierName
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.modifierName = yAxisDragModifierName
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        extendZoomModifier.modifierName = extendZoomModifierName
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        pinchZoomModifier.modifierName = pinchZoomModifierName
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.modifierName = rolloverModifierName
//        rolloverModifier.style.tooltipSize = CGSizeMake(200, CGFloat.NaN)
        
        let groupModifier = SCIModifierGroup(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        chartSurface.chartModifier = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        let axisStyle = generateDefaultAxisStyle()
        chartSurface.xAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle))
        chartSurface.yAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle))
    }
    
    fileprivate func addDataSeries() {
        
        let dataSeries = SCIXyyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        fillDataInto(dataSeries)
        
        let renderebleDataSeries = SCIBandRenderableSeries()
        renderebleDataSeries.style.brush1 = SCISolidBrushStyle(colorCode: 0x50279b27)
        renderebleDataSeries.style.brush2 = SCISolidBrushStyle(colorCode: 0x50ff1919)
        renderebleDataSeries.style.pen1 = SCISolidPenStyle(colorCode: 0xFF279b27, withThickness: 0.5)
        renderebleDataSeries.style.pen2 = SCISolidPenStyle(colorCode: 0xFFff1919, withThickness: 0.5)
        renderebleDataSeries.style.drawPointMarkers = false
        renderebleDataSeries.dataSeries = dataSeries
        
        chartSurface.renderableSeries.add(renderebleDataSeries)
        
    }
    
    fileprivate func fillDataInto(_ dataSeries: SCIXyyDataSeries) {
        
        var i = 0
        while i < 500 {
            
            let time = 10.0 * Float(i) / 500.0
            let wn = 2.0 * M_PI / (500.0 / 3.0)
            
            dataSeries.appendX(SCIGeneric(time),
                               y1: SCIGeneric(0.03 * sin(Double(i) * wn + 4)),
                               y2: SCIGeneric(0.05 * sin(Double(i) * wn + 12)))
            
            i += 1
            
        }
        
    }
    
    
}
