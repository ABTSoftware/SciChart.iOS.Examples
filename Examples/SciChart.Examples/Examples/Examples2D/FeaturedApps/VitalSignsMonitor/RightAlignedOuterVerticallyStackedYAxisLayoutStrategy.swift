//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RightAlignedOuterVerticallyStackedYAxisLayoutStrategy.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

class RightAlignedOuterVerticallyStackedYAxisLayoutStrategy: SCIVerticalAxisLayoutStrategy {
    override func measureAxes(withAvailableWidth width: CGFloat, height: CGFloat, andChartLayoutState chartLayoutState: SCIChartLayoutState) {
        for i in 0 ..< axes.count {
            let axis = axes[i] as! ISCIAxis
            axis.updateMeasurements()
            
            let axisLayoutState = axis.axisLayoutState
            chartLayoutState.rightOuterAreaSize = max(SCIVerticalAxisLayoutStrategy.getRequiredAxisSize(from: axisLayoutState), chartLayoutState.rightOuterAreaSize)
        }
    }
    
    override func layout(withLeft left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        let count = axes.count
        let height = bottom - top
        let axisHeight = height / CGFloat(count)
        
        var topPlacement = top
        
        for i in 0 ..< count {
            let axis = axes[i] as! ISCIAxis
            let axisLayoutState = axis.axisLayoutState
            let bottomPlacement = round(topPlacement + axisHeight)
            axis.layoutArea(withLeft: left, top: topPlacement, right: left + SCIVerticalAxisLayoutStrategy.getRequiredAxisSize(from: axisLayoutState), bottom: bottomPlacement)
            topPlacement = bottomPlacement
        }
    }
}
