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
        
        let line: LineAnnotationWithListener = LineAnnotationWithListener()
        line.coordinateMode = .relative
        line.x1 = SCIGeneric(0.2)
        line.y1 = SCIGeneric(0.2)
        line.x2 = SCIGeneric(0.3)
        line.y2 = SCIGeneric(0.8)
        self.annotations.add(line)
        line.isEditable = true
        
        self.invalidateElement()
    }
    
    fileprivate func addSeries() {
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        for i in 0...10 {
             let yValue = Int(arc4random_uniform(10))
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(yValue))
        }

        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries
        renderSeries.strokeStyle = SCISolidPenStyle(color: UIColor.cyan, withThickness: 1)
        self.renderableSeries.add(renderSeries)
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
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier])
        
        self.chartModifiers = groupModifier
    }
    
}
