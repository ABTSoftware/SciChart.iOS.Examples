//
//  SCSMountainChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/2/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSMountainChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCIDateTimeAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let priceData = DataManager.getPriceDataIndu()
        let dataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        dataSeries.appendRangeX(SCIGeneric(priceData!.dateData()), y: SCIGeneric(priceData!.closeData()), count: priceData!.size())
        
        let rSeries = SCIFastMountainRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.zeroLineY = 10000
        rSeries.areaStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xAAFF8D42, finish: 0x88090E11, direction: .vertical)
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xAAFFC9A8, withThickness: 1.0)
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        SCIUpdateSuspender.usingWithSuspendable(surface, with:{
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCITooltipModifier()])
            
            rSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        })
    }
}
