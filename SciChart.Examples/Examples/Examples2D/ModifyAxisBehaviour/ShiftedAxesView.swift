//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ShiftedAxesView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

// MARK: - Inner Top/Left Layout Strategies

class CenteredTopAlignmentInnerAxisLayoutStrategy: SCITopAlignmentInnerAxisLayoutStrategy {
    let yAxis: ISCIAxis;

    init(yAxis: ISCIAxis) {
        self.yAxis = yAxis
    }
    
    override func layout(withLeft left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        // find the coordinate of 0 on the Y Axis in pixels
        // place the stack of the top-aligned X Axes at this coordinate
        let topCoord = CGFloat(yAxis.currentCoordinateCalculator.getCoordinate(0))
        SCIHorizontalAxisLayoutStrategy.layoutAxesFromTop(toBottom: self.axes as! [ISCIAxis], withLeft: left, top: topCoord, right: right)
    }
}

class CenteredLeftAlignmentInnerAxisLayoutStrategy: SCILeftAlignmentInnerAxisLayoutStrategy {
    let xAxis: ISCIAxis;

    init(xAxis: ISCIAxis) {
        self.xAxis = xAxis
    }
    
    override func layout(withLeft left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) {
        // find the coordinate of 0 on the X Axis in pixels
        // place the stack of the left-aligned Y Axes at this coordinate
        let leftCoord = CGFloat(xAxis.currentCoordinateCalculator.getCoordinate(0))
        SCIVerticalAxisLayoutStrategy.layoutAxesFromLeft(toRight: self.axes as! [ISCIAxis], withLeft: leftCoord, top: top, bottom: bottom)
    }
}

// MARK: - Layout Manager

class CenterLayoutManager: NSObject, ISCILayoutManager {
    let layoutManager = SCIDefaultLayoutManager()
    var isFirstLayout = false
    
    init(xAxis: ISCIAxis, yAxis: ISCIAxis) {
        // need to override default inner layout strategies for bottom and right aligned axes
        // because xAxis has right axis alignment and yAxis has bottom axis alignment
        layoutManager.leftInnerAxisLayoutStrategy = CenteredLeftAlignmentInnerAxisLayoutStrategy(xAxis: xAxis)
        layoutManager.topInnerAxisLayoutStrategy = CenteredTopAlignmentInnerAxisLayoutStrategy(yAxis: yAxis)
    }
    
    func attach(_ axis: ISCIAxis, isXAxis: Bool) {
        layoutManager.attach(axis, isXAxis: isXAxis)
    }
    
    func detach(_ axis: ISCIAxis) {
        layoutManager.detach(axis)
    }
    
    func onAxisPlacementChanged(_ axis: ISCIAxis, oldAxisAlignment: SCIAxisAlignment, oldIsCenterAxis: Bool, newAxisAlignment: SCIAxisAlignment, newIsCenterAxis: Bool) {
        layoutManager.onAxisPlacementChanged(axis, oldAxisAlignment: oldAxisAlignment, oldIsCenterAxis: oldIsCenterAxis, newAxisAlignment: newAxisAlignment, newIsCenterAxis: newIsCenterAxis)
    }
    
    func attach(to services: ISCIServiceContainer) {
        layoutManager.attach(to: services)

        // need to perform 2 layout passes during first layout of chart
        isFirstLayout = true
    }
    
    func detach() {
        layoutManager.detach()
    }

    var isAttached: Bool {
        get { return layoutManager.isAttached }
    }
    
    func onLayoutChart(withAvailableSize size: CGSize) -> CGSize {
        // need to perform additional layout pass if it is a first layout pass
        // because we don't know correct size of axes during first layout pass
        if isFirstLayout {
            layoutManager.onLayoutChart(withAvailableSize: size)
            isFirstLayout = false
        }
        return layoutManager.onLayoutChart(withAvailableSize: size)
    }
}

class ShiftedAxesView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }

    override func initExample() {
        let xAxis = newAxis(axisAlignment: .top)
        let yAxis = newAxis(axisAlignment: .left)
        
        let butterflyCurve = SCDDataManager.getButterflyCurve(20000)
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.acceptsUnsortedData = true
        dataSeries.append(x: butterflyCurve.xValues, y: butterflyCurve.yValues)
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = dataSeries
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.layoutManager = CenterLayoutManager(xAxis: xAxis, yAxis: yAxis)
            
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            
            SCIAnimations.sweep(rSeries, duration: 20, easingFunction: nil)
        }
    }
    
    func newAxis(axisAlignment: SCIAxisAlignment) -> ISCIAxis {
        let axis = SCINumericAxis()
        axis.axisAlignment = axisAlignment
        axis.majorTickLineStyle = SCISolidPenStyle(color: 0xFFFFFFFF, thickness: 2)
        axis.textFormatting = "0.00"
        axis.drawMinorTicks = false
        axis.isCenterAxis = true
        axis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        return axis
    }
}
