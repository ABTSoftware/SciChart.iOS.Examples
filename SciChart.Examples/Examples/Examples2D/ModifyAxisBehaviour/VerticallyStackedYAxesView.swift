//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// VerticallyStackedYAxesView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class LeftAlignedOuterVerticallyStackedYAxisLayoutStrategy: SCIVerticalAxisLayoutStrategy {
    
    override func measureAxes(withAvailableWidth width: CGFloat, height: CGFloat, andChartLayoutState chartLayoutState: SCIChartLayoutState) {
        for i in 0 ..< axes.count {
            let axis = axes[i] as! ISCIAxis
            axis.updateMeasurements()
            
            let requiredAxisSize = SCIVerticalAxisLayoutStrategy.getRequiredAxisSize(from: axis.axisLayoutState)
            chartLayoutState.leftOuterAreaSize = max(requiredAxisSize, chartLayoutState.leftOuterAreaSize)
        }
    }
    
    override func layout(withLeft left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        let count = axes.count
        let height = bottom - top
        let axisSize = height / CGFloat(count)
        
        var topPlacement = top
        for i in 0 ..< count {
            let axis = axes[i] as! ISCIAxis
            let axisLayoutState = axis.axisLayoutState
            
            let bottomPlacement = topPlacement + axisSize
            
            let requiredAxisSize = SCIVerticalAxisLayoutStrategy.getRequiredAxisSize(from: axisLayoutState)
            axis.layoutArea(withLeft: right - requiredAxisSize + axisLayoutState.additionalLeftSize, top: topPlacement, right: right - axisLayoutState.additionalRightSize, bottom: bottomPlacement)
            
            topPlacement = bottomPlacement
        }
    }
}

class VerticallyStackedYAxesView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        var dataSeries = [ISCIXyDataSeries]()
        for i in 0 ..< 5 {
            let ds = SCIXyDataSeries(xType: .double, yType: .double)
            dataSeries.append(ds)
            
            let sinewave = SCDDataManager.getSinewaveWithAmplitude(3, phase: Double(i), pointCount: 1000)
            ds.append(x: sinewave.xValues, y: sinewave.yValues)
        }
        
        let layoutManager = SCIDefaultLayoutManager()
        layoutManager.leftOuterAxisLayoutStrategy = LeftAlignedOuterVerticallyStackedYAxisLayoutStrategy()
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.layoutManager = layoutManager
            
            self.surface.xAxes.add(SCINumericAxis())
            self.surface.yAxes.add(self.newAxis(axisId: "Ch0"))
            self.surface.yAxes.add(self.newAxis(axisId: "Ch1"))
            self.surface.yAxes.add(self.newAxis(axisId: "Ch2"))
            self.surface.yAxes.add(self.newAxis(axisId: "Ch3"))
            self.surface.yAxes.add(self.newAxis(axisId: "Ch4"))
            
            self.surface.renderableSeries.add(self.newLineSeriesi(dataSeries: dataSeries[0], color: 0xFFFF1919, axisId: "Ch0"))
            self.surface.renderableSeries.add(self.newLineSeriesi(dataSeries: dataSeries[0], color: 0xFFFC9C29, axisId: "Ch1"))
            self.surface.renderableSeries.add(self.newLineSeriesi(dataSeries: dataSeries[0], color: 0xFFFF1919, axisId: "Ch2"))
            self.surface.renderableSeries.add(self.newLineSeriesi(dataSeries: dataSeries[0], color: 0xFFFC9C29, axisId: "Ch3"))
            self.surface.renderableSeries.add(self.newLineSeriesi(dataSeries: dataSeries[0], color: 0xFF4083B7, axisId: "Ch4"))
            
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
        }
        
        self.surface.zoomExtents()
    }
    
    fileprivate func newLineSeriesi(dataSeries: ISCIXyDataSeries, color: UInt32, axisId: String) -> SCIFastLineRenderableSeries {
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.strokeStyle = SCISolidPenStyle(color: color, thickness: 1.0)
        rSeries.yAxisId = axisId
        
        SCIAnimations.sweep(rSeries, duration: 3.0, easingFunction: SCICubicEase())
        
        return rSeries
    }
    
    fileprivate func newAxis(axisId: String) -> ISCIAxis {
        let axis = SCINumericAxis()
        axis.axisAlignment = .left
        axis.axisId = axisId
        axis.axisTitle = axisId
        axis.visibleRange = SCIDoubleRange(min: -2, max: 2)
        axis.autoRange = .never
        axis.drawMajorBands = false
        axis.drawMajorGridLines = false
        axis.drawMinorGridLines = false
        
        return axis
    }
}
