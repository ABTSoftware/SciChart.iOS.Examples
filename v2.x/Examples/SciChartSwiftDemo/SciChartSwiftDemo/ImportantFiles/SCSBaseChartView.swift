//
//  SCSBaseChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSBaseChartView: SCIChartSurface {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    // MARK: Overrided Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        completeConfiguration()
    }
    
    // MARK: Internal Functions
    
    func completeConfiguration() {

    }
   
    func addDefaultModifiers() {
        
//        let xAxisDragmodifier = SCIXAxisDragModifier()
//        xAxisDragmodifier.dragMode = .scale
//        xAxisDragmodifier.clipModeX = .none
//
//        let yAxisDragmodifier = SCIYAxisDragModifier()
//        yAxisDragmodifier.dragMode = .pan
//
//        let extendZoomModifier = SCIZoomExtentsModifier()
//
//        let pinchZoomModifier = SCIPinchZoomModifier()
//
//        let rolloverModifier = SCIRolloverModifier()
//        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        
//        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
//        surface.chartModifiers = groupModifier
    }
    
}
