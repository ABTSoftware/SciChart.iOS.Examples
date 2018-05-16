//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSFactoryAxis.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation
import SciChart

class SCSFactoryAxis {
    
    static func createDefaultNumericAxis(withAxisStyle axisStyle: SCIAxisStyle, isVisible: Bool = true) -> SCIAxis2DProtocol {
        let axis = SCINumericAxis()
        axis.style = axisStyle
        axis.isVisible = isVisible
        let valueYMin: Float = 0.1
        let valueYMax: Float = 0.1
        axis.autoRange = .once
        axis.growBy = SCIFloatRange(min: SCIGeneric(valueYMin), max: SCIGeneric(valueYMax))
        
        return axis
    }
    
    static func createDefaultDateTimeAxis(withAxisStyle axisStyle: SCIAxisStyle) -> SCIAxis2DProtocol {
        let axis = SCIDateTimeAxis()
        axis.style = axisStyle
        axis.textFormatting = "dd/MM/yyyy"
        let valueXMin: Float = 0.1
        let valueXMax: Float = 0.1
        axis.growBy = SCIDoubleRange(min: SCIGeneric(valueXMin), max: SCIGeneric(valueXMax))
        return axis
    }
    
    static func createCategoryDateTimeAxis(withAxisStyle axisStyle: SCIAxisStyle) -> SCIAxis2DProtocol {
        
        let axis = SCICategoryDateTimeAxis()
        axis.style = axisStyle
        let valueXMin: Float = 0.1
        let valueXMax: Float = 0.1
        axis.growBy = SCIDoubleRange(min: SCIGeneric(valueXMin), max: SCIGeneric(valueXMax))
        return axis
    }
    
    static func createCategoryNumericAxis(withAxisStyle axisStyle: SCIAxisStyle) -> SCIAxis2DProtocol {
        
        let axis = SCICategoryNumericAxis()
        axis.style = axisStyle
        let valueXMin: Float = 0.1
        let valueXMax: Float = 0.1
        axis.growBy = SCIDoubleRange(min: SCIGeneric(valueXMin), max: SCIGeneric(valueXMax))
        return axis
    }
    
}
