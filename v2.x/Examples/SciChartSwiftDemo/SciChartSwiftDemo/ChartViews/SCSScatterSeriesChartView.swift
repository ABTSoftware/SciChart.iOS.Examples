//
//  SCSScatterSeriesChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSScatterSeriesChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
    }
    
    override func addDefaultModifiers() {
        super.addDefaultModifiers()
        
        let cursor = SCICursorModifier()
        cursor.style.hitTestMode = .point
        cursor.modifierName = "CursorModifier"
        cursor.style.hitTestMode = .point
        cursor.style.colorMode = SCITooltipColorMode.seriesColorToDataView;
        cursor.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        
        let group = chartSurface.chartModifier as! SCIModifierGroup
        group .remove(at: group.itemCount()-1);
        group .addItem(cursor)
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        chartSurface.xAxes.add(SCIDateTimeAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    

    fileprivate func addDataSeries() {
        
        chartSurface.renderableSeries.add(getScatterRenderableSeries(withDetalization: 3,
            colorCode: 0xFFffeb01,
            negative: false))
        chartSurface.renderableSeries.add(getScatterRenderableSeries(withDetalization: 6,
            colorCode: 0xFFffa300,
            negative: false))
        
        chartSurface.renderableSeries.add(getScatterRenderableSeries(withDetalization: 3,
            colorCode: 0xFFff6501,
            negative: true))
        chartSurface.renderableSeries.add(getScatterRenderableSeries(withDetalization: 6,
            colorCode: 0xFFffa300,
            negative: true))
        
        chartSurface.invalidateElement()
        
    }
    
    fileprivate func getScatterRenderableSeries(withDetalization pointMarker: Int32, colorCode: UInt32, negative: Bool) -> SCIXyScatterRenderableSeries {
        
        
        let dataSeries = SCIXyDataSeries(xType: .dateTime, yType: .float, seriesType: .defaultType)
        putDataInto(dataSeries, belowZeroY: negative)
        
        dataSeries.seriesName = (pointMarker == 6) ?
            (negative ? "Negative Hex" : "Positive Hex") :
            (negative ? "Negative" : "Positive")
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let scatterRenderableSeries = SCIXyScatterRenderableSeries()
        scatterRenderableSeries.dataSeries = dataSeries
        
        let ellipse = SCIEllipsePointMarker()
        ellipse.drawBorder = true
        ellipse.fillBrush = SCISolidBrushStyle(colorCode: colorCode)
        ellipse.borderPen = SCISolidPenStyle(colorCode: 0xfffffff, withThickness: 0.1)
        ellipse.detalization = pointMarker
        ellipse.height = 6.0
        ellipse.width = 6.0
        
        scatterRenderableSeries.style.pointMarker = ellipse
        
        return scatterRenderableSeries
    }
    
    fileprivate func putDataInto(_ dataSeries: SCIXyDataSeries, belowZeroY: Bool) {
        
        var i : UInt32 = 0
        while i < 200 {
            
            let x = i
            let time = (i < 100) ? arc4random_uniform(x+10) : arc4random_uniform(200-x+10)
            let y = time*time*time
            
            if belowZeroY {
                dataSeries.appendX(SCIGeneric(Double(x)), y: SCIGeneric(-Int32(y)))
            }
            else {
                dataSeries.appendX(SCIGeneric(Double(x)), y: SCIGeneric(y))
            }
            
            i = i + 1
        }
        
    }
    
}
