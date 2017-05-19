//
//  SCSStackedColumnVerticalChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 11/10/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSStackedColumnChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        let xAxis = SCIDateTimeAxis()
        xAxis.textFormatting = "yyyy"
        xAxes.add(xAxis)
        yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries() {
        
        let stackedGroup = SCIVerticallyStackedColumnsCollection()
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(0, andFillColor: 0xff226fb7))
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(1, andFillColor: 0xffff9a2e))
        
        let stackedGroup_2 = SCIVerticallyStackedColumnsCollection()
        stackedGroup_2.add(self.p_getRenderableSeriesWithIndex(2, andFillColor: 0xffdc443f))
        stackedGroup_2.add(self.p_getRenderableSeriesWithIndex(3, andFillColor: 0xffaad34f))
        stackedGroup_2.add(self.p_getRenderableSeriesWithIndex(4, andFillColor: 0xff8562b4))
        
        let horizontalStacked = SCIHorizontallyStackedColumnsCollection()
        horizontalStacked.add(stackedGroup)
        horizontalStacked.add(stackedGroup_2)
        renderableSeries.add(horizontalStacked)
    }
    
    fileprivate func p_getRenderableSeriesWithIndex(_ index: Int, andFillColor fillColor: uint) -> SCIStackedColumnRenderableSeries {
        let renderableSeries = SCIStackedColumnRenderableSeries()
        renderableSeries.strokeStyle = nil;
        renderableSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: fillColor)
        renderableSeries.dataSeries = SCSDataManager.stackedVerticalColumnSeries()[index]
        return renderableSeries
    }
    
}
