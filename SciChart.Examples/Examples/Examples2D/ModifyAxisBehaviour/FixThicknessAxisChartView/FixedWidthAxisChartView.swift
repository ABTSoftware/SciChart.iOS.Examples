//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FixedWidthAxisChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class FixedWidthAxisChartView: SCDFixThicknessAxisChartViewController {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        var dataSeries = [ISCIXyDataSeries]()
        let ds = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.append(ds)
        
        let sinewave = SCDDataManager.getSinewaveWithAmplitude(3, phase: Double(0), pointCount: 1000)
        ds.append(x: sinewave.xValues, y: sinewave.yValues)
        
        xTopAxisTitle = "x Top Axis"
        xTopAxis = self.newAxis(axisTitle: xTopAxisTitle, axisAlignment: .top, axisTickLabelAlignment: xTopAxisTickLabelAlignment, axisTitleAlignment: .center, textFormatting: "0.0")
        xTopAxis.axisId = "Ch2"
        
        xBottomAxisTitle = "x Bottom Axis"
        xBottomAxis = self.newAxis(axisTitle: xBottomAxisTitle, axisAlignment: .bottom, axisTickLabelAlignment: xBottomAxisTickLabelAlignment, axisTitleAlignment: .center, textFormatting: "0.0")
        xBottomAxis.axisThickness = 50
        
        yRightAxisTitle = "Y Right Axis"
        yRightAxis = self.newAxis(axisTitle: yRightAxisTitle, axisAlignment: .right, axisTickLabelAlignment: yRightAxisTickLabelAlignment, axisTitleAlignment: .center, textFormatting: "0.0")
        yRightAxis.axisId = "Ch2"
        
        yLeftAxisTitle = "Y Left Axis"
        yLeftAxis = self.newAxis(axisTitle: yLeftAxisTitle, axisAlignment: .left, axisTickLabelAlignment: yLeftAxisTickLabelAlignment, axisTitleAlignment: .center, textFormatting: "$ 0.0")
        yLeftAxis.axisThickness = 60
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = dataSeries[0]
        rSeries.strokeStyle = SCISolidPenStyle(color: 0xFFFF1919, thickness: 1.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            
            self.surface.xAxes.add(self.xTopAxis)
            self.surface.xAxes.add(self.xBottomAxis)
            self.surface.yAxes.add(self.yRightAxis)
            self.surface.yAxes.add(self.yLeftAxis)
            
            self.surface.renderableSeries.add(rSeries)
            
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
        }
        
        self.surface.zoomExtents()
    }
    
    private func newAxis(axisTitle: String = "",
                             axisAlignment: SCIAxisAlignment? = nil,
                             axisTickLabelAlignment: SCIAlignment? = nil,
                             axisTitleAlignment: SCIAlignment? = nil,
                             textFormatting: String? = nil) -> SCINumericAxis {
        let axis = SCINumericAxis()
        
        if let axisAlignment = axisAlignment {
            axis.axisAlignment = axisAlignment
        }
        
        axis.axisTitle = axisTitle
        axis.visibleRange = SCIDoubleRange(min: -2, max: 2)
        axis.autoRange = .never
        axis.drawMajorBands = false
        axis.drawMajorGridLines = false
        axis.drawMinorGridLines = false
        
        if let axisTitleAlignment = axisTitleAlignment {
            axis.axisTitleAlignment = axisTitleAlignment
        }
        
        if let textFormatting = textFormatting {
            axis.textFormatting = textFormatting
        }
        
        if let axisTickLabelAlignment = axisTickLabelAlignment {
    #if os(OSX)
            axis.axisTickLabelStyle = SCIAxisTickLabelStyle.init(alignment: axisTickLabelAlignment, andMargins: NSEdgeInsetsZero)
    #else
            axis.axisTickLabelStyle = SCIAxisTickLabelStyle.init(alignment: axisTickLabelAlignment, andMargins: .zero)
    #endif
        }
        
        return axis
    }

}
