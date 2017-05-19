//
//  SCSPanAndZoomChartView.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 23/03/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSPanAndZoomChartView: SCSBaseChartView {

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
        
        let zoomPanModifier = SCIZoomPanModifier()
        zoomPanModifier.clipModeX = .stretchAtExtents
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, zoomPanModifier])
        
        chartModifiers = groupModifier
    }
    
    fileprivate func addAxis() {
        let xAxis = SCINumericAxis()
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(3), max: SCIGeneric(6))
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries () {

        let pen1 = SCISolidPenStyle(colorCode: 0xFF177B17, withThickness: 1.0)
        let pen2 = SCISolidPenStyle(colorCode: 0xFFDD0909, withThickness: 1.0)
        let pen3 = SCISolidPenStyle(colorCode: 0xFF0944CF, withThickness: 1.0)
        
        let brush1 = SCISolidBrushStyle(colorCode: 0x77279B27)
        let brush2 = SCISolidBrushStyle(colorCode: 0x77FF1919)
        let brush3 = SCISolidBrushStyle(colorCode: 0x771964FF)
        
        let wave1 : SCIFastMountainRenderableSeries = SCIFastMountainRenderableSeries()
        wave1.areaStyle = brush1
        wave1.style.strokeStyle = pen1
        wave1.dataSeries = getDampedSinewave(pad: 300, amplitude: 1.0, phase: 0.0, dampingFactor: 0.01, pointCount: 1000, freq: 10)
        
        let wave2 : SCIFastMountainRenderableSeries = SCIFastMountainRenderableSeries()
        wave2.areaStyle = brush2
        wave2.style.strokeStyle = pen2
        wave2.dataSeries = getDampedSinewave(pad: 300, amplitude: 1.0, phase: 0.0, dampingFactor: 0.024, pointCount: 1000, freq: 10)
        
        let wave3 : SCIFastMountainRenderableSeries = SCIFastMountainRenderableSeries()
        wave3.areaStyle = brush3
        wave3.style.strokeStyle = pen3
        wave3.dataSeries = getDampedSinewave(pad: 300, amplitude: 1.0, phase: 0.0, dampingFactor: 0.049, pointCount: 1000, freq: 10)
        
        renderableSeries.add(wave1);
        renderableSeries.add(wave2);
        renderableSeries.add(wave3);
        
        invalidateElement()
    }

    func getDampedSinewave(pad : Int, amplitude : Double, phase : Double, dampingFactor: Double, pointCount : Int, freq: Int) -> SCIXyDataSeries {
        let data : SCIXyDataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType);
    
        for i in 0...pad {
            let time : Double = Double(10 * i) / Double(pointCount);
            data .appendX(SCIGeneric(time), y: SCIGeneric(0));
        }
    
        var amp = amplitude;
        var j : Int = 0
        for i in pad...pointCount {
            let time : Double = Double(10 * i) / Double(pointCount);
            let wn : Double = 4 * Double.pi / (Double(pointCount) / Double(freq));
        
            let d : Double = amp * sin(Double(j) * wn + phase);
            data .appendX(SCIGeneric(time), y: SCIGeneric(d));
        
            amp *= (1.0 - dampingFactor);
            j+=1
        }
        
        return data;
    }
    
}
