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

class FixWidthYAxisLayoutStrategy: SCIVerticalAxisLayoutStrategy {
    
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
        for i in 0 ..< count {
            let axis = axes[i] as! ISCIAxis
            let axisLayoutState = axis.axisLayoutState
            axisLayoutState.axisSize = 100;
            
            SCIVerticalAxisLayoutStrategy.layoutAxesFromLeft(toRight: self.axes as! [ISCIAxis], withLeft: left, top: top, bottom: bottom)
        }
    }
}

class FixHeightXAxisLayoutStrategy: SCIHorizontalAxisLayoutStrategy {
    
    override func measureAxes(withAvailableWidth width: CGFloat, height: CGFloat, andChartLayoutState chartLayoutState: SCIChartLayoutState) {
        for i in 0 ..< axes.count {
            let axis = axes[i] as! ISCIAxis
            axis.updateMeasurements()
           
            let requiredAxisSize = SCIHorizontalAxisLayoutStrategy.getRequiredAxisSize(from: axis.axisLayoutState)
            chartLayoutState.bottomOuterAreaSize = max(requiredAxisSize, chartLayoutState.bottomOuterAreaSize)
        }
    }
    
    override func layout(withLeft left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        let count = axes.count
        for i in 0 ..< count {
            let axis = axes[i] as! ISCIAxis
            let axisLayoutState = axis.axisLayoutState
            axisLayoutState.axisSize = 100;
            
            SCIHorizontalAxisLayoutStrategy.layoutAxesFromBottom(toTop: self.axes as! [ISCIAxis], withLeft: left, bottom: bottom, right: right)
        }
    }
}


class FixedWidthAxisChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        var dataSeries = [ISCIXyDataSeries]()
        for i in 0 ..< 1 {
            let ds = SCIXyDataSeries(xType: .double, yType: .double)
            dataSeries.append(ds)
            
            let sinewave = SCDDataManager.getSinewaveWithAmplitude(3, phase: Double(i), pointCount: 1000)
            ds.append(x: sinewave.xValues, y: sinewave.yValues)
        }
        
        let layoutManager = SCIDefaultLayoutManager()
        layoutManager.leftOuterAxisLayoutStrategy = FixWidthYAxisLayoutStrategy()
        
        let xAxisLayoutManager = SCIDefaultLayoutManager()
        xAxisLayoutManager.bottomOuterAxisLayoutStrategy = FixHeightXAxisLayoutStrategy()
        
        let yAxis = SCINumericAxis()
        yAxis.axisAlignment = .left
        yAxis.axisTitle = "Ch0"
        yAxis.visibleRange = SCIDoubleRange(min: -2, max: 2)
        yAxis.autoRange = .never
        yAxis.drawMajorBands = false
        yAxis.drawMajorGridLines = false
        yAxis.drawMinorGridLines = false
        yAxis.axisTitleAlignment = .center
        yAxis.textFormatting = "$$0.0"
        yAxis.axisTickLabelStyle = SCIAxisTickLabelStyle.init(alignment: .center, andMargins: .zero)
        
        let xAxis = SCINumericAxis()
        xAxis.axisAlignment = .bottom
        xAxis.axisTitle = "Ch0"
        xAxis.visibleRange = SCIDoubleRange(min: -2, max: 2)
        xAxis.autoRange = .never
        xAxis.axisTitleAlignment = .center
        xAxis.textFormatting = "$$0.0"
        xAxis.axisTickLabelStyle = SCIAxisTickLabelStyle.init(alignment: .center, andMargins: .zero)
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = dataSeries[0]
        rSeries.strokeStyle = SCISolidPenStyle(color: 0xFFFF1919, thickness: 1.0)
        
        SCIAnimations.sweep(rSeries, duration: 3.0, easingFunction: SCICubicEase())
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.layoutManager = layoutManager
            self.surface.layoutManager = xAxisLayoutManager
            
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            
            self.surface.renderableSeries.add(rSeries)
            
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
        }
        
        self.surface.zoomExtents()
    }
}
