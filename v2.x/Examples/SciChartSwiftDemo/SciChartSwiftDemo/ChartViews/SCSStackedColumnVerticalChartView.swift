//
//  SCSStackedColumnVerticalChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 11/10/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSStackedColumnVerticalChartView: SCSBaseChartView {
    
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
        
        let stackedGroup = SCIStackedVerticalColumnGroupSeries()
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(0, andFillColor: 0xff226fb7, andBorderColor: 0xff22579d))
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(1, andFillColor: 0xffff9a2e, andBorderColor: 0xffbe642d))
        
        let stackedGroup_2 = SCIStackedVerticalColumnGroupSeries()
        stackedGroup_2.add(self.p_getRenderableSeriesWithIndex(2, andFillColor: 0xffdc443f, andBorderColor: 0xffa33631))
        stackedGroup_2.add(self.p_getRenderableSeriesWithIndex(3, andFillColor: 0xffaad34f, andBorderColor: 0xff73953d))
        stackedGroup_2.add(self.p_getRenderableSeriesWithIndex(4, andFillColor: 0xff8562b4, andBorderColor: 0xff64458a))
        
        let horizontalStacked = SCIStackedHorizontalColumnGroupSeries()
        horizontalStacked.add(stackedGroup)
        horizontalStacked.add(stackedGroup_2)
        chartSurface.renderableSeries.add(horizontalStacked)
    }
    
    fileprivate func p_getRenderableSeriesWithIndex(_ index: Int, andFillColor fillColor: uint, andBorderColor borderColor: uint) -> SCIStackedColumnRenderableSeries {
        let renderableSeries = SCIStackedColumnRenderableSeries()
        renderableSeries.style.fillBrush = SCISolidBrushStyle(colorCode: fillColor)
        renderableSeries.style.borderPen = SCISolidPenStyle(colorCode: borderColor, withThickness: 2)
        renderableSeries.dataSeries = SCSDataManager.stackedVerticalColumnSeries()[index]
        return renderableSeries
    }
    
}
