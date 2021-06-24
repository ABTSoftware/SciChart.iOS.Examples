//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// Style3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class Style3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    override func initExample() {

        let xAxis = SCINumericAxis3D()
        xAxis.minorsPerMajor = 5
        xAxis.maxAutoTicks = 7
        xAxis.textSize = 13
        xAxis.textColor = 0xFF00FF00
        xAxis.textFont = "RobotoCondensed-BoldItalic"
        xAxis.axisBandsStyle = SCISolidBrushStyle(color: 0xFF556B2F)
        xAxis.majorTickLineStyle = SCISolidPenStyle(color: 0xFF00FF00, thickness: 1.0)
        xAxis.majorTickLineLength = 8.0
        xAxis.majorTickLineStyle = SCISolidPenStyle(color: 0xFFC71585, thickness: 1.0)
        xAxis.majorTickLineLength = 4.0
        xAxis.majorGridLineStyle = SCISolidPenStyle(color: 0xFF00FF00, thickness: 1.0)
        xAxis.minorGridLineStyle = SCISolidPenStyle(color: 0xFF9400D3, thickness: 1.0)

        let yAxis = SCINumericAxis3D()
        yAxis.minorsPerMajor = 5
        yAxis.maxAutoTicks = 7
        yAxis.textSize = 13
        yAxis.textColor = 0xFFB22222
        yAxis.textFont = "RobotoCondensed-BoldItalic"
        yAxis.axisBandsStyle = SCISolidBrushStyle(color: 0xFFFF6347)
        yAxis.majorTickLineStyle = SCISolidPenStyle(color: 0xFFB22222, thickness: 1.0)
        yAxis.majorTickLineLength = 8.0
        yAxis.majorTickLineStyle = SCISolidPenStyle(color: 0xFFCD5C5C, thickness: 1.0)
        yAxis.majorTickLineLength = 4.0
        yAxis.majorGridLineStyle = SCISolidPenStyle(color: 0xFF006400, thickness: 1.0)
        yAxis.minorGridLineStyle = SCISolidPenStyle(color: 0xFF8CBED6, thickness: 1.0)
        
        let zAxis = SCINumericAxis3D()
        zAxis.minorsPerMajor = 5
        zAxis.maxAutoTicks = 7
        zAxis.textSize = 13
        zAxis.textColor = 0xFFDB7093
        zAxis.textFont = "RobotoCondensed-BoldItalic"
        zAxis.axisBandsStyle = SCISolidBrushStyle(color: 0xFFADFF2F)
        zAxis.majorTickLineStyle = SCISolidPenStyle(color: 0xFFDB7093, thickness: 1.0)
        zAxis.majorTickLineLength = 8.0
        zAxis.majorTickLineStyle = SCISolidPenStyle(color: 0xFF7FFF00, thickness: 1.0)
        zAxis.majorTickLineLength = 4.0
        zAxis.majorGridLineStyle = SCISolidPenStyle(color: 0xFFF5F5DC, thickness: 1.0)
        zAxis.minorGridLineStyle = SCISolidPenStyle(color: 0xFFA52A2A, thickness: 1.0)
    
        surface.backgroundBrushStyle = SCILinearGradientBrushStyle(start: CGPoint(x: 0.5, y: 1.0), end: CGPoint(x: 0.5, y: 0.0), startColor: 0xFF3D4703, endColor: 0x00000000)
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
        }
    }
}
