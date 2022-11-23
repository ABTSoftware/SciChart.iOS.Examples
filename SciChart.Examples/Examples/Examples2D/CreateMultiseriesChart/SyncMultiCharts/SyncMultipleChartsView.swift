//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SyncMultipleChartsView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SyncMultipleChartsView: SCDTwoChartsViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    let PointsCount = 500
    let SharedXRange = SCIDoubleRange(min: 0, max: 1)
    let SharedYRange = SCIDoubleRange(min: 0, max: 1)
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        initChart(surface: surface1!)
        initChart(surface: surface2!)
    }

    fileprivate func initChart(surface: SCIChartSurface) {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.visibleRange = SharedXRange
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.visibleRange = SharedYRange
        
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        for i in 0 ..< PointsCount {
            dataSeries.append(x: i, y: Double(PointsCount) * sin(Double(i) * .pi * 0.1) / Double(i))
        }
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 1.0)

        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.receiveHandledEvents = true
        rolloverModifier.eventsGroupTag = "SharedEventGroup"
        
        SCIUpdateSuspender.usingWith(surface) {
            surface.xAxes.add(xAxis)
            surface.yAxes.add(yAxis)
            surface.renderableSeries.add(rSeries)
            surface.chartModifiers.add(items: SCIZoomExtentsModifier(), SCIPinchZoomModifier(), rolloverModifier, SCIXAxisDragModifier(), SCIYAxisDragModifier())
            
            surface.zoomExtents()
            SCIAnimations.sweep(rSeries, duration: 3.0, easingFunction: SCICubicEase())
        }
    }
}
