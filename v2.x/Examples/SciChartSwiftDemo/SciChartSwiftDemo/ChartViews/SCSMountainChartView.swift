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
        
        let groupModifier = SCIModifierGroup(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        chartSurface.chartModifier = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        chartSurface.xAxes.add(SCIDateTimeAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries () {
       
        
        let brush = SCILinearGradientBrushStyle(colorCodeStart: 0xff975831,
                                           finish: 0x88110E09,
                                           direction: .vertical)
        let pen = SCISolidPenStyle(colorCode: 0xFFd7a789, withThickness: 0.5)
        
        
        chartSurface.renderableSeries.add(getMountainRenderSeries(withBrush: brush, and: pen))
        chartSurface.invalidateElement()
    }
    
    
    fileprivate func getMountainRenderSeries(withBrush brush:SCILinearGradientBrushStyle, and pen: SCISolidPenStyle) -> SCIFastMountainRenderableSeries {
        
        let dataSeries = SCIXyDataSeries(xType: .dateTime, yType: .float, seriesType: .defaultType)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        SCSDataManager.loadData(into: dataSeries,
                                fileName: "FinanceData",
                                startIndex: 0,
                                increment: 1,
                                reverse: true)
        
        
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.style.areaBrush = brush
        mountainRenderSeries.style.borderPen = pen
        mountainRenderSeries.dataSeries = dataSeries
               
        return mountainRenderSeries
        
    }
    
    
    
}
