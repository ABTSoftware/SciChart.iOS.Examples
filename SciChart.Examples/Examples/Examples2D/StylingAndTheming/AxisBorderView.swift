//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AxisBorderView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

// The class defines a custom SciChart example that demonstrates how to configure
// multiple axes with customized borders and styles.
class AxisBorderView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    private let primaryColors: [UInt32] = [
        0xFF4FBEE6, // Light blue
        0xFFAD3D8D, // Magenta
        0xFF6BBDAE, // Teal
        0xFFE76E63, // Coral red
        0xFF2C4B92  // Deep blue
    ]
    
    override func initExample() {
        
        let axisTitleSize: Float = 12.0
        let labelSize: Float = 10.0
        let tickSize: Float = 8.0
        let tickThickness: Float = 2.0
        
        let xAxis1 = SCINumericAxis()
        xAxis1.axisId = "xAxis1"
        xAxis1.axisTitle = "X Axis"
        xAxis1.axisAlignment = .bottom
        xAxis1.drawMajorBands = false
        xAxis1.drawMajorGridLines = true
        xAxis1.drawMinorGridLines = false
        xAxis1.drawMajorTicks = true
        xAxis1.visibleRange = SCIDoubleRange(min: -10.0, max: 110.0)
        
        let xAxis2 = SCINumericAxis()
        xAxis2.axisId = "xAxis2"
        xAxis2.axisTitle = "Flipped X Axis"
        xAxis2.axisAlignment = .bottom
        xAxis2.flipCoordinates = true
        xAxis2.drawMajorBands = false
        xAxis2.drawMajorGridLines = false
        xAxis2.drawMinorGridLines = false
        xAxis2.drawMajorTicks = true
        xAxis2.visibleRange = SCIDoubleRange(min: -10.0, max: 110.0)
        // Apply only top border to distinguish this axis
        xAxis2.axisBorderStyle = SCIAxisBorderStyle(color: primaryColors[1], antiAliasing: true, topThickness: 0.8, leftThickness: 0, bottomThickness: 0, rightThickness: 0) ?? SCIAxisBorderStyle()
        
        let xAxis3 = SCINumericAxis()
        xAxis3.axisId = "xAxis3"
        xAxis3.axisTitle = "Stacked X Axis"
        xAxis3.axisAlignment = .right
        xAxis3.drawMajorBands = false
        xAxis3.drawMajorGridLines = false
        xAxis3.drawMinorGridLines = false
        xAxis3.drawMajorTicks = true
        xAxis3.visibleRange = SCIDoubleRange(min: -10.0, max: 110.0)
        // Apply distinguish thickness for each side
        xAxis3.axisBorderStyle = SCIAxisBorderStyle(color: primaryColors[2], antiAliasing: false, topThickness: 1, leftThickness: 0.5, bottomThickness: 5, rightThickness: 3) ?? SCIAxisBorderStyle()
        
        let yAxis1 = SCINumericAxis()
        yAxis1.axisId = "yAxis1"
        yAxis1.axisTitle = "Flipped Y Axis - Left Aligned"
        yAxis1.axisTitlePlacement = .right
        yAxis1.axisAlignment = .left
        yAxis1.flipCoordinates = true
        yAxis1.drawMajorBands = false
        yAxis1.drawMajorGridLines = true
        yAxis1.drawMinorGridLines = false
        yAxis1.drawMajorTicks = true
        yAxis1.visibleRange = SCIDoubleRange(min: -10.0, max: 140.0)
        // Apply uniform border styling
        yAxis1.axisBorderStyle = SCIAxisBorderStyle(color: primaryColors[0], thickness: 2.0)
        
        
        let yAxis2 = SCINumericAxis()
        yAxis2.axisId = "yAxis2"
        yAxis2.axisTitle = "Stacked Y Axis"
        yAxis2.axisAlignment = .left
        yAxis2.drawMajorBands = false
        yAxis2.drawMajorGridLines = false
        yAxis2.drawMinorGridLines = false
        yAxis2.drawMajorTicks = true
        yAxis2.visibleRange = SCIDoubleRange(min: -10.0, max: 140.0)
        // Apply uniform border styling
        yAxis2.axisBorderStyle = SCIAxisBorderStyle(color: primaryColors[1], thickness: 8)
        
        let yAxis3 = SCINumericAxis()
        yAxis3.axisId = "yAxis3"
        yAxis3.axisTitle = "Y Axis - Top Aligned"
        yAxis3.axisAlignment = .top
        yAxis3.drawMajorBands = false
        yAxis3.drawMajorGridLines = false
        yAxis3.drawMinorGridLines = false
        yAxis3.drawMajorTicks = true
        yAxis3.visibleRange = SCIDoubleRange(min: -10.0, max: 140.0)
        // Apply only bottom border
        yAxis3.axisBorderStyle = SCIAxisBorderStyle(color: primaryColors[2], antiAliasing: true, topThickness: 0, leftThickness: 0, bottomThickness: 3, rightThickness: 0) ?? SCIAxisBorderStyle()
        
        let xAxes = [xAxis1, xAxis2, xAxis3]
        let yAxes = [yAxis1, yAxis2, yAxis3]
        
        for i in 0..<xAxes.count {
            let colorCode = self.primaryColors[i]
            
            let xAxis = xAxes[i]
            let yAxis = yAxes[i]
            
            // Styling axis title and labels
            xAxis.titleStyle = SCIFontStyle(fontSize: axisTitleSize, andTextColorCode: colorCode)
            yAxis.titleStyle = SCIFontStyle(fontSize: axisTitleSize, andTextColorCode: colorCode)
            
            xAxis.tickLabelStyle = SCIFontStyle(fontSize: labelSize, andTextColorCode: colorCode)
            yAxis.tickLabelStyle = SCIFontStyle(fontSize: labelSize, andTextColorCode: colorCode)
            
            // Ticks style
            xAxis.majorTickLineStyle = SCISolidPenStyle.init(color: colorCode, thickness: tickThickness)
            yAxis.majorTickLineStyle = SCISolidPenStyle.init(color: colorCode, thickness: tickThickness)
            
            xAxis.majorTickLineLength = tickSize
            yAxis.majorTickLineLength = tickSize
        }
        
        // Create data series
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        for j in 0..<100 {
            let x = Double(j)
            let y = sin(Double(j) * 0.1) * Double(j) + 50.0
            dataSeries.append(x: x, y: y)
        }
        
        // Create line series
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = dataSeries
        lineSeries.xAxisId = "xAxis1"
        lineSeries.yAxisId = "yAxis1"
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(items: xAxis1, xAxis2, xAxis3)
            self.surface.yAxes.add(items: yAxis1, yAxis2, yAxis3)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.chartModifiers.add(items: SCDExampleBaseViewController.createDefaultModifiers())
        }
    }
}
    


