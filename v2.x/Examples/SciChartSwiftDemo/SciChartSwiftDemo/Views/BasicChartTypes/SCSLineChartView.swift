//
//  SCSLineChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 5/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSLineChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(1.1), max: SCIGeneric(2.7))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let fourierSeries = DataManager.getFourierSeries(withAmplitude: 1.0, phaseShift: 0.1, count: 5000)
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        dataSeries.appendRangeX(fourierSeries!.xValues, y: fourierSeries!.yValues, count: fourierSeries!.size)
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
        rSeries.dataSeries = dataSeries

        SCIUpdateSuspender.usingWithSuspendable(surface, with:{
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
            
            rSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        })
    }
}
