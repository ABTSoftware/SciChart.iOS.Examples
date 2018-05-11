//
//  DigitalLineView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 7/18/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSDigitalLineChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(1), max: SCIGeneric(1.25))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(2.3), max: SCIGeneric(3.3))
        
        let fourierSeries = DataManager.getFourierSeries(withAmplitude: 1.0, phaseShift: 0.1, count: 5000)
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        dataSeries.appendRangeX(fourierSeries!.xValues, y: fourierSeries!.yValues, count: fourierSeries!.size)
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        rSeries.dataSeries = dataSeries
        rSeries.isDigitalLine = true
        
        SCIUpdateSuspender.usingWithSuspendable(surface, with:{
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
            
            rSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        })
    }
}
