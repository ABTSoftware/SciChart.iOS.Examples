//
//  SCSMountainChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/2/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSMountainChartView: SCSBaseChartView {

    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addModifiers()
        addDataSeries()
    }
    
    func addModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.hitTestMode = .vertical
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        chartSurface.chartModifiers = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        let xAxis = SCIDateTimeAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries () {
        let brush = SCILinearGradientBrushStyle(colorCodeStart: 0xAAFF8D42,
                                           finish: 0x88090E11,
                                           direction: .vertical)
        let pen = SCISolidPenStyle(colorCode: 0xAAFFC9A8, withThickness: 1.0)
        
        chartSurface.renderableSeries.add(getMountainRenderSeries(withBrush: brush, and: pen))
        chartSurface.invalidateElement()
    }
    
    fileprivate func getMountainRenderSeries(withBrush brush:SCILinearGradientBrushStyle, and pen: SCISolidPenStyle) -> SCIFastMountainRenderableSeries {
        let dataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .float, seriesType: .defaultType)
        
        SCSDataManager.getPriceIndu(dataSeries: dataSeries, fileName: "INDU_Daily")
        
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.zeroLineY = 10000
        mountainRenderSeries.areaStyle = brush
        mountainRenderSeries.style.strokeStyle = pen
        mountainRenderSeries.dataSeries = dataSeries
               
        return mountainRenderSeries
    }
}
