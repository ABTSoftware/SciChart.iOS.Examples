//
//  SCSStackedColumnChartView.swift
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
        let axisStyle = generateDefaultAxisStyle()
        let xAxis = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        xAxis.axisAlignment = .right
        chartSurface.xAxes.add(xAxis)
        let yAxis = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        yAxis.flipCoordinates = true
        yAxis.axisAlignment = .bottom
        chartSurface.yAxes.add(yAxis)
    }
   
    fileprivate func addDataSeries() {
        let stackedGroup = SCIStackedVerticalColumnGroupSeries()
        stackedGroup.add(self.p_getRenderableSeries(0, andFillColorStart: 0xff3D5568, andFinish: 0xff567893))
        stackedGroup.add(self.p_getRenderableSeries(1, andFillColorStart: 0xff439aaf, andFinish: 0xffACBCCA))
        stackedGroup.add(self.p_getRenderableSeries(2, andFillColorStart: 0xffb6c1c3, andFinish: 0xffdbe0e1))
        chartSurface.renderableSeries.add(stackedGroup)
    }
    
    fileprivate func p_getRenderableSeries(_ index: Int, andFillColorStart fillColor: uint, andFinish finishColor: uint) -> SCIStackedColumnRenderableSeries {
        let renderableSeries = SCIStackedColumnRenderableSeries()
        renderableSeries.style.fillBrush = SCILinearGradientBrushStyle(colorCodeStart: fillColor, finish: finishColor, direction: .horizontal)
        renderableSeries.style.borderPen = SCISolidPenStyle(colorCode: fillColor, withThickness: 0.5)
        renderableSeries.style.drawBorders = true
        renderableSeries.dataSeries = SCSDataManager.stackedBarChartSeries()[index]
        return renderableSeries
    }
    
}
