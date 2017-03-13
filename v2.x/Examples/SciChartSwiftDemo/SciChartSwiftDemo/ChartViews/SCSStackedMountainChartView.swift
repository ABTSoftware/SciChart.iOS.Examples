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
        chartSurface.xAxes.add(SCIDateTimeAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries() {
        
        let dataSeries = SCIXyDataSeries(xType:.dateTime, yType:.float, seriesType: .defaultType)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        fillDataInto(dataSeries)
        
        let brush = SCILinearGradientBrushStyle(colorCodeStart: 0x88909Aaf,
                                           finish: 0x88439Aaf,
                                           direction: .vertical)
        let renderableSeroiesBottom = createRenderableSeriesWith(brush,
                                                              pen: SCISolidPenStyle(colorCode: 0xAAffffff, withThickness: 0.5),
                                                              dataSeries: dataSeries)
        
        
        let dataSeries2 = SCIXyDataSeries(xType: .dateTime, yType: .float, seriesType: .defaultType)
        dataSeries2.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        fillDataInto(dataSeries2)
        
        let brush2 = SCILinearGradientBrushStyle(colorCodeStart: 0x88ffffff,
                                            finish: 0xDDE1E0DB,
                                            direction: .vertical)
        let renderableSeroiesTop = createRenderableSeriesWith(brush2,
                                                                 pen: SCISolidPenStyle(colorCode: 0xFFffffff, withThickness: 0.5),
                                                                 dataSeries: dataSeries2)
        
        
        let stackedGroup = SCIStackedGroupSeries()
        stackedGroup.add(renderableSeroiesBottom)
        stackedGroup.add(renderableSeroiesTop)
        chartSurface.renderableSeries.add(stackedGroup)
        
        chartSurface.invalidateElement()
    
    }
    
    fileprivate func createRenderableSeriesWith(_ brush: SCILinearGradientBrushStyle, pen: SCISolidPenStyle, dataSeries: SCIXyDataSeries) ->  SCIStackedMountainRenderableSeries {
        
        let renderableSeries = SCIStackedMountainRenderableSeries()
        renderableSeries.style.areaBrush = brush
        renderableSeries.style.borderPen = pen
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
