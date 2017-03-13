//
//  SCSErrorBarsChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/20/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSErrorBarsChartView: SCSBaseChartView {
    
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
        
        let dataCount = 10
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        var i = 1
        while i <= dataCount {
            let x = i
            let y = SCSDataManager.randomize(-1.5, max: 1.5);
            dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
            i += 1
        }
        

        
        let verticalRenderSeries = SCIFastFixedErrorBarsRenderableSeries()
        verticalRenderSeries.dataSeries = dataSeries
        verticalRenderSeries.errorType = SCIErrorBarTypeRelative
        verticalRenderSeries.errorLow = 0.1
        verticalRenderSeries.errorHigh = 0.3
        verticalRenderSeries.style.linePen = SCISolidPenStyle(color: UIColor.init(colorLiteralRed: 70.0/255.0,
            green: 130.0/255.0,
            blue: 180.0/255.0,
            alpha: 1.0), withThickness: 1.0)
        chartSurface.renderableSeries.add(verticalRenderSeries)
        
        let horizontalRenderSeries = SCIFastFixedErrorBarsRenderableSeries()
        horizontalRenderSeries.errorDirection = SCIErrorBarDirectionHorizontal
        horizontalRenderSeries.errorDataPointWidth = 0.5;
        horizontalRenderSeries.dataSeries = dataSeries
        horizontalRenderSeries.style.linePen = SCISolidPenStyle(color: UIColor.red, withThickness: 1.0)
        chartSurface.renderableSeries.add(horizontalRenderSeries)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.drawBorder = true
        ellipsePointMarker.fillBrush = SCISolidBrushStyle(color: UIColor.init(colorLiteralRed: 70.0/255.0,
            green: 130.0/255.0,
            blue: 180.0/255.0,
            alpha: 1.0))
        ellipsePointMarker.borderPen = SCISolidPenStyle(color: UIColor.init(colorLiteralRed: 176.0/255.0, green: 196.0/255.0, blue: 222.0/255.0, alpha: 1.0), withThickness: 2.0)
        ellipsePointMarker.height = 15
        ellipsePointMarker.width = 15
        
        let lineRenderSeries = SCIFastLineRenderableSeries()
        lineRenderSeries.dataSeries = dataSeries
        lineRenderSeries.style.pointMarker = ellipsePointMarker
        lineRenderSeries.style.drawPointMarkers = true;
        lineRenderSeries.style.linePen = SCISolidPenStyle(color: UIColor.init(colorLiteralRed: 176.0/255.0, green: 196.0/255.0, blue: 222.0/255.0, alpha: 1.0), withThickness: 1.0)
        chartSurface.renderableSeries.add(lineRenderSeries)
        
        chartSurface.invalidateElement()
        
    }
    
}
