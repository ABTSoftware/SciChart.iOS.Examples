//
//  SCSCandlestickChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/2/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSCandlestickChartView: SingleChartLayout {
    
    override func initExample() {
        let priceSeries = DataManager.getPriceDataIndu()
        let size = priceSeries!.size()
        
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(size - 30), max: SCIGeneric(size))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yAxis.autoRange = .always
        
        let dataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double)
        dataSeries.appendRangeX(SCIGeneric(priceSeries!.dateData()), open: SCIGeneric(priceSeries!.openData()), high: SCIGeneric(priceSeries!.highData()), low: SCIGeneric(priceSeries!.lowData()), close: SCIGeneric(priceSeries!.closeData()), count: priceSeries!.size())
        
        let rSeries = SCIFastCandlestickRenderableSeries()
        rSeries.dataSeries = dataSeries;
        rSeries.strokeUpStyle = SCISolidPenStyle(colorCode: 0xFF00AA00, withThickness: 1.0)
        rSeries.fillUpBrushStyle = SCISolidBrushStyle(colorCode: 0x9000AA00)
        rSeries.strokeDownStyle = SCISolidPenStyle(colorCode: 0xFFFF0000, withThickness: 1.0)
        rSeries.fillDownBrushStyle = SCISolidBrushStyle(colorCode: 0x90FF0000)
        
        SCIUpdateSuspender.usingWithSuspendable(surface, with:{
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
            
            rSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        })
    }
}
