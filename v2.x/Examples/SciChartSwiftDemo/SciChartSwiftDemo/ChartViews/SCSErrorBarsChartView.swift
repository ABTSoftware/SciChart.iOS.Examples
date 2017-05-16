//
//  SCSErrorBarsChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/20/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSErrorBarsChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addDefaultModifiers()
        addSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        chartSurface.xAxes.add(SCINumericAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addSeries() {
        
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        
        SCSDataManager.getFourierDataZoomed(dataSeries, amplitude: 1.0, phaseShift: 0.1, xStart: 5.0, xEnd: 5.15, count: 5000)
        
        let dataSeries0 = SCIHlcDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        let dataSeries1 = SCIHlcDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        
        fillSeries(dataSeries: dataSeries0, sourceData: dataSeries, scale: 1.0)
        fillSeries(dataSeries: dataSeries1, sourceData: dataSeries, scale: 1.3)
        
        let errorBars0 = SCIFastErrorBarsRenderableSeries()
        errorBars0.dataPointWidth = 0.7;
        errorBars0.dataSeries = dataSeries0
        errorBars0.strokeStyle = SCISolidPenStyle(colorCode: 0xFFC6E6FF, withThickness: 1.0)
        chartSurface.renderableSeries.add(errorBars0)
        
        let pMarker = SCIEllipsePointMarker()
        pMarker.strokeStyle = SCISolidPenStyle(colorCode:0xFFC6E6FF, withThickness: 1.0)
        pMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFFC6E6FF)
        pMarker.height = 5
        pMarker.width = 5
        
        let lineRenderSeries = SCIFastLineRenderableSeries()
        lineRenderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFC6E6FF, withThickness: 1.0)
        lineRenderSeries.dataSeries = dataSeries0
        lineRenderSeries.style.pointMarker = pMarker
        chartSurface.renderableSeries.add(lineRenderSeries)
        
        let errorBars1 = SCIFastErrorBarsRenderableSeries()
        errorBars1.dataPointWidth = 0.7;
        errorBars1.dataSeries = dataSeries1
        errorBars1.strokeStyle = SCISolidPenStyle(colorCode: 0xFFC6E6FF, withThickness: 1.0)
        chartSurface.renderableSeries.add(errorBars1)
        
        let ellipsePointMarker1 = SCIEllipsePointMarker()
        ellipsePointMarker1.fillStyle = SCISolidBrushStyle(colorCode:0x00FFFFFF)
        ellipsePointMarker1.height = 7
        ellipsePointMarker1.width = 7
        
        let scatterRenderSeries = SCIXyScatterRenderableSeries()
        scatterRenderSeries.dataSeries = dataSeries1
        scatterRenderSeries.style.pointMarker = ellipsePointMarker1
        
        chartSurface.renderableSeries.add(scatterRenderSeries)
        
        chartSurface.invalidateElement()
    }
    
    private func fillSeries(dataSeries:SCIHlcDataSeriesProtocol, sourceData:SCIXyDataSeriesProtocol, scale:Double){
        let xValues:SCIArrayController = sourceData.xValues() as! SCIArrayController
        let yValues:SCIArrayController = sourceData.yValues() as! SCIArrayController
        
        for i in 0..<sourceData.xValues().count(){
            let y = SCIGenericDouble(yValues.value(at: i)) * scale;
            dataSeries.appendX(xValues.value(at: i), y: SCIGeneric(y), high: SCIGeneric(drand48()*0.2), low: SCIGeneric(drand48()*0.2))
            
        }
    }
    
}
