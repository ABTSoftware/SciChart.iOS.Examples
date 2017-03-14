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
        let extendZoomModifier = SCIZoomExtentsModifier()
        let pinchZoomModifier = SCIPinchZoomModifier()
        let zoomPanModifier = SCIZoomPanModifier()
        
        let groupModifier = SCIModifierGroup(childModifiers: [pinchZoomModifier, extendZoomModifier, zoomPanModifier])
        
        chartSurface.chartModifier = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min:SCIGeneric(1.1), max: SCIGeneric(2.7))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        let xy1DataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        let xy2DataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)

        fillDataInto(1.0, dampingFactor: 0.01, phase: 0.0, frequency: 10, count: 1000, dataSeries: xy1DataSeries)
        fillDataInto(1.0, dampingFactor: 0.005, phase: 0.0, frequency: 12, count: 1000, dataSeries: xy2DataSeries)
        
        let dataSeries = SCIXyyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        dataSeries.y1Column = xy1DataSeries.yColumn
        dataSeries.y2Column = xy2DataSeries.yColumn
        dataSeries.xColumn = xy1DataSeries.xColumn
        
        let renderebleDataSeries = SCIBandRenderableSeries()
        renderebleDataSeries.style.brush2 = SCISolidBrushStyle(colorCode: 0x50279b27)
        renderebleDataSeries.style.brush1 = SCISolidBrushStyle(colorCode: 0x50ff1919)
        renderebleDataSeries.style.pen2 = SCISolidPenStyle(colorCode: 0xFF279b27, withThickness: 1.0)
        renderebleDataSeries.style.pen1 = SCISolidPenStyle(colorCode: 0xFFff1919, withThickness: 1.0)
        renderebleDataSeries.style.drawPointMarkers = false
        renderebleDataSeries.dataSeries = dataSeries
        
        chartSurface.renderableSeries.add(renderebleDataSeries)
    }
    
    fileprivate func fillDataInto(_ amplitude:(Double), dampingFactor dFactor:(Double), phase ph:(Double), frequency freq:(Double), count pCount:(Int), dataSeries:(SCIXyDataSeries)) {
        var j = 0.0
        var amp = amplitude
        for i in 0..<pCount{
            let wn = 2 * M_PI / (Double(pCount)/Double(freq));
            let d = amp * sin(j * wn + ph);
            dataSeries.appendX(SCIGeneric(Double(10*i)/Double(pCount)),y:SCIGeneric(d))
            amp *= (1.0 - dFactor)
            j += 1.0
        }
    }
}
