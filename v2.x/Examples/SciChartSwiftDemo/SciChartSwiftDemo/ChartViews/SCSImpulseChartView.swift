//
//  SCSImpulseChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/15/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSImpulseChartView: SCSBaseChartView {
    
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
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.drawBorder = false
        ellipsePointMarker.fillBrush = SCISolidBrushStyle(color: UIColor.blue)
        ellipsePointMarker.height = 10
        ellipsePointMarker.width = 10
        
        let dataSeries = SCSDataManager.getDampedSinewave(1.0,
                                                          phase: 0.0,
                                                          dampingFactor: 0.05,
                                                          pointCount: 50,
                                                          freq: 5)
     
        let impulseRenderSeries = SCIFastImpulseRenderableSeries()
        impulseRenderSeries.dataSeries = dataSeries
        impulseRenderSeries.style.pointMarker = ellipsePointMarker;
        impulseRenderSeries.style.linePen = SCISolidPenStyle(color: UIColor.blue, withThickness: 0.7)
        chartSurface.renderableSeries.add(impulseRenderSeries)
        
        chartSurface.invalidateElement()
        
    }
    
}
