//
//  SCSLineChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 5/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSLineChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addSeries()
        addDefaultModifiers()
    }
    
    // MARK: Private Functions

    fileprivate func addAxes() {
        chartSurface.xAxes.add(SCINumericAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addSeries() {
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.putDataInto(dataSeries)
        
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.putFourierDataInto(fourierDataSeries)
        
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        fourierDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.drawBorder = true
        ellipsePointMarker.fillBrush = SCISolidBrushStyle(colorCode: 0xFFd7ffd6)
        ellipsePointMarker.height = 5
        ellipsePointMarker.width = 5
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries
        renderSeries.style.pointMarker = ellipsePointMarker
        renderSeries.style.drawPointMarkers = true
        renderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 0.7)
        chartSurface.renderableSeries.add(renderSeries)
        
        let fourierRenderSeries = SCIFastLineRenderableSeries()
        fourierRenderSeries.dataSeries = fourierDataSeries
        fourierRenderSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFFff8a4c, withThickness: 0.7)
        chartSurface.renderableSeries.add(fourierRenderSeries)
        
        chartSurface.invalidateElement()
        
    }
    
}
