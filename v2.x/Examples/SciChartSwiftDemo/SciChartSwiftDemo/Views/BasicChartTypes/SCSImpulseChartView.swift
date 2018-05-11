//
//  SCSImpulseChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/15/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSImpulseChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let ds1points = DataManager.getDampedSinewave(withAmplitude: 1.0, dampingFactor: 0.05, pointCount: 50, freq: 5)
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.appendRangeX(ds1points!.xValues, y: ds1points!.yValues, count: ds1points!.size)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = nil
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFF0066FF)
        ellipsePointMarker.height = 10
        ellipsePointMarker.width = 10
        
        let rSeries = SCIFastImpulseRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF0066FF, withThickness: 1.0)
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = ellipsePointMarker
        
        SCIUpdateSuspender.usingWithSuspendable(surface, with:{
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
            
            rSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        })
    }
}
