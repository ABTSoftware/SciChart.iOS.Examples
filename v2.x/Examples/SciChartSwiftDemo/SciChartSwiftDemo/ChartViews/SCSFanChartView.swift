//
//  SCSFanChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/22/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSFanChartView: SCSBaseChartView {

    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        chartSurface.xAxes.add(SCIDateTimeAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries() {
        
        let dataSeries = SCIXyDataSeries(xType:.dateTime, yType:.float, seriesType: .defaultType)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()

        let xyyDataSeries = SCIXyyDataSeries(xType:.dateTime, yType:.float, seriesType: .defaultType)
        xyyDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()

        let xyyDataSeries1 = SCIXyyDataSeries(xType:.dateTime, yType:.float, seriesType: .defaultType)
        xyyDataSeries1.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let xyyDataSeries2 = SCIXyyDataSeries(xType:.dateTime, yType:.float, seriesType: .defaultType)
        xyyDataSeries2.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        self.generatingDataPoints(10) { (result: SCSDataPoint) in
            dataSeries.appendX(SCIGeneric(result.date), y: SCIGeneric(result.actualValue))
            xyyDataSeries.appendX(SCIGeneric(result.date), y1: SCIGeneric(result.maxValue), y2: SCIGeneric(result.minValue))
            xyyDataSeries1.appendX(SCIGeneric(result.date), y1: SCIGeneric(result.value1), y2: SCIGeneric(result.value4))
            xyyDataSeries2.appendX(SCIGeneric(result.date), y1: SCIGeneric(result.value2), y2: SCIGeneric(result.value3))
        }
      
        let dataRenderSeries = SCIFastLineRenderableSeries()
        dataRenderSeries.dataSeries = dataSeries
        dataRenderSeries.style.linePen = SCISolidPenStyle(color: UIColor.red, withThickness: 1.0)
        
        chartSurface.renderableSeries.add(createRenderableSeriesWith(xyyDataSeries))
        chartSurface.renderableSeries.add(createRenderableSeriesWith(xyyDataSeries1))
        chartSurface.renderableSeries.add(createRenderableSeriesWith(xyyDataSeries2))
        chartSurface.renderableSeries.add(dataRenderSeries)
        chartSurface.invalidateElement()
        
    }
    
    fileprivate func createRenderableSeriesWith(_ dataSeries: SCIXyyDataSeries) -> SCIBandRenderableSeries {
        let renderebleDataSeries = SCIBandRenderableSeries()
        renderebleDataSeries.style.brush1 = SCISolidBrushStyle(color: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5))
        renderebleDataSeries.style.brush2 = SCISolidBrushStyle(color: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5))
        renderebleDataSeries.style.pen1 = SCISolidPenStyle(color: UIColor.green, withThickness: 0.5)
        renderebleDataSeries.style.pen2 = SCISolidPenStyle(color: UIColor.clear, withThickness: 0.5)
        renderebleDataSeries.style.drawPointMarkers = false
        renderebleDataSeries.dataSeries = dataSeries
        return renderebleDataSeries;
    }
    
    fileprivate func generatingDataPoints(_ count: Int, handler: (SCSDataPoint) -> Void) {
        var dateTime = Date()
        var lastValue: Double = 0.0
        var i: Int = 0
        while i <= count {
            let nextValue = lastValue + SCSDataManager.randomize(-0.5, max: 0.5)
            lastValue = nextValue
            dateTime = dateTime.addingTimeInterval(3600*24)
            
            var dataPoint = SCSDataPoint()
            dataPoint.date = dateTime
            dataPoint.actualValue = nextValue
            if i > 4 {
                dataPoint.maxValue = nextValue + (Double(i) - 5) * 0.3
                dataPoint.value1 = nextValue + (Double(i) - 5) * 0.2
                dataPoint.value2 = nextValue + (Double(i) - 5) * 0.1
                dataPoint.value3 = nextValue - (Double(i) - 5) * 0.1
                dataPoint.value4 = nextValue - (Double(i) - 5) * 0.2
                dataPoint.minValue = nextValue - (Double(i) - 5) * 0.3
            }
            
            handler(dataPoint)
            
            i += 1
        }
        
    }
    
}

public struct SCSDataPoint {
    var maxValue = Double.nan
    var minValue = Double.nan
    var value1 = Double.nan
    var value2 = Double.nan
    var value3 = Double.nan
    var value4 = Double.nan
    var actualValue = Double.nan
    var date = Date()
    
    
}
