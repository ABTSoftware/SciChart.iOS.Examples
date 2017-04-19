//
//  SCSStackedColumnSideBySideChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 11/10/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSStackedColumnSideBySideChartView: SCSBaseChartView {
    
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
        let horizontalStacked = SCIHorizontallyStackedColumnsCollection()
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(0, andFillColor: 0xff3399ff, andBorderColor: 0xff2d68bc))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(1, andFillColor: 0xff014358, andBorderColor: 0xff013547))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(2, andFillColor: 0xff1f8a71, andBorderColor: 0xff1b5d46))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(3, andFillColor: 0xffbdd63b, andBorderColor: 0xff7e952b))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(4, andFillColor: 0xffffe00b, andBorderColor: 0xffaa8f0b))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(5, andFillColor: 0xfff27421, andBorderColor: 0xffa95419))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(6, andFillColor: 0xffbb0000, andBorderColor: 0xff840000))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(7, andFillColor: 0xff550033, andBorderColor: 0xff370018))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(8, andFillColor: 0xff339933, andBorderColor: 0xff2d773d))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(9, andFillColor: 0xff00ada9, andBorderColor: 0xff006c6a))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(10, andFillColor: 0xff560068, andBorderColor: 0xff3d0049))
        chartSurface.renderableSeries.add(horizontalStacked)
    }
    
    fileprivate func p_getRenderableSeriesWithIndex(_ index: Int, andFillColor fillColor: uint, andBorderColor borderColor: uint) -> SCIStackedColumnRenderableSeries {
        let renderableSeries = SCIStackedColumnRenderableSeries()
        renderableSeries.style.fillBrush = SCISolidBrushStyle(colorCode: fillColor)
        renderableSeries.style.borderPen = SCISolidPenStyle(colorCode: borderColor, withThickness: 2)
        renderableSeries.dataSeries = SCSDataManager.stackedSideBySideDataSeries()[index]
        return renderableSeries
    }
    
}
