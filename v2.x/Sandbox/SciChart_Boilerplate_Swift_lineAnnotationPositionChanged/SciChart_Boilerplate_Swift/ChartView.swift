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
        addAnnotation()
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
    
    func addAnnotation() {
        let line = CustomLineAnnotation();
        line.coordinateMode = .absolute;
        line.isEditable = true;
        line.x1 = SCIGeneric(1);
        line.y1 = SCIGeneric(1);
        line.x2 = SCIGeneric(7);
        line.y2 = SCIGeneric(5);
        line.lineMoved = { (moved, x1, y1, x2, y2) -> Void in
            if (moved) {
                NSLog("Moved to X1:%g Y1:%g X2:%g Y2:%g", SCIGenericDouble(x1), SCIGenericDouble(y1), SCIGenericDouble(x2), SCIGenericDouble(y2));
            }
        }
        self.annotations.add(line);
    }
    
}
