//
//  SCSStackedMountainChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSStackedMountainChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        chartSurface.xAxes.add(SCINumericAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries() {
        let mountainDataSeries1 = SCIXyDataSeries(xType:.int32, yType:.double, seriesType: .defaultType)
        let mountainDataSeries2 = SCIXyDataSeries(xType:.int32, yType:.double, seriesType: .defaultType)
        
        let yValues1:Array<Double> = [ 4.0,  7,    5.2,  9.4,  3.8,  5.1, 7.5,  12.4, 14.6, 8.1, 11.7, 14.4, 16.0, 3.7, 5.1, 6.4, 3.5, 2.5, 12.4, 16.4, 7.1, 8.0, 9.0 ]
        let yValues2:Array<Double> = [ 15.0, 10.1, 10.2, 10.4, 10.8, 1.1, 11.5, 3.4,  4.6,  0.1, 1.7, 14.4, 6.0, 13.7, 10.1, 8.4, 8.5, 12.5, 1.4, 0.4, 10.1, 5.0, 1.0 ]
        
        for i in 0..<yValues1.count{
            mountainDataSeries1.appendX(SCIGeneric(i), y:SCIGeneric(yValues1[i]));
        }
        for i in 0..<yValues2.count{
            mountainDataSeries2.appendX(SCIGeneric(i), y:SCIGeneric(yValues2[i]));
        }

        let brush = SCILinearGradientBrushStyle(colorCodeStart: 0xDDDBE0E1, finish: 0x88B6C1C3, direction: .vertical)
        let renderableSeroiesBottom = createRenderableSeriesWith(brush, pen: SCISolidPenStyle(colorCode: 0xFFffffff, withThickness: 1.0), dataSeries: mountainDataSeries2)
        
        let brush2 = SCILinearGradientBrushStyle(colorCodeStart: 0xDDACBCCA, finish: 0x88439AAF, direction: .vertical)
        let renderableSeroiesTop = createRenderableSeriesWith(brush2, pen: SCISolidPenStyle(colorCode: 0xFFffffff, withThickness: 1.0), dataSeries: mountainDataSeries1)
        
        let stackedGroup = SCIVerticallyStackedMountainsCollection()
        stackedGroup.add(renderableSeroiesBottom)
        stackedGroup.add(renderableSeroiesTop)
        chartSurface.renderableSeries.add(stackedGroup)
        
        chartSurface.invalidateElement()
    }
    
    fileprivate func createRenderableSeriesWith(_ brush: SCILinearGradientBrushStyle, pen: SCISolidPenStyle, dataSeries: SCIXyDataSeries) ->  SCIStackedMountainRenderableSeries {
        
        let renderableSeries = SCIStackedMountainRenderableSeries()
        renderableSeries.areaStyle = brush
        renderableSeries.style.strokeStyle = pen
        renderableSeries.dataSeries = dataSeries
        return renderableSeries;
    }
    
    fileprivate func fillDataInto(_ dataSeries: SCIXyDataSeries) {
        SCSDataManager.loadData(into: dataSeries,
                                fileName: "FinanceData",
                                startIndex: 1,
                                increment: 1,
                                reverse: true)
    }
    
    
    
}
