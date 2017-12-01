//
//  SCSLineChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 5/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class ChartView: SCIChartSurface {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    // MARK: Private Functions

    fileprivate func completeConfiguration() {
        addAxes()
        addModifiers()
        addSeries()
    }
    
    fileprivate func addSeries() {
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        for i in 0...10 {
             let yValue = Int(arc4random_uniform(10))
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(yValue))
        }

        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries
        self.renderableSeries.add(renderSeries)
        
        self.invalidateElement()
        
    }
    
    fileprivate func addAxes() {
        self.xAxes.add(SCINumericAxis())
        self.yAxes.add(SCINumericAxis())
    }
    
    func addModifiers() {
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let zoomPanModifier = SCIZoomPanModifier()
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, zoomPanModifier])
        
        self.chartModifiers = groupModifier
    }
    
}
