//
//  DigitalLineView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 7/18/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSDigitalLineChartView: SCSBaseChartView {
    
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
        renderSeries.style.isDigitalLine = true
        renderSeries.hitTestProvider().hitTestMode = .verticalInterpolate
        chartSurface.renderableSeries.add(renderSeries)
        chartSurface.invalidateElement()
        
    }
    
}
