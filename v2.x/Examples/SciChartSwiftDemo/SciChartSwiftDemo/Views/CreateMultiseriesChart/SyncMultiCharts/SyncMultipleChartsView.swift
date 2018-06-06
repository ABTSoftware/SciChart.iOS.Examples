//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class SyncMultipleChartsView: SyncMultipleChartsLayout {
    
    let PointsCount = 500
    
    let _rangeSync = SCIAxisRangeSynchronization()
    let _zoomExtentsModifierSync = SCIMultiSurfaceModifier(modifierType: SCIZoomExtentsModifier.self)
    let _pinchZoomModifierSync = SCIMultiSurfaceModifier(modifierType: SCIPinchZoomModifier.self)
    let _xDragModifierSync = SCIMultiSurfaceModifier(modifierType: SCIXAxisDragModifier.self)
    let _yDragModifierSync = SCIMultiSurfaceModifier(modifierType: SCIYAxisDragModifier.self)
    let _rolloverModifierSync = SCIMultiSurfaceModifier(modifierType: SCIRolloverModifier.self)

    override func initExample() {
        initChart(surface: surface1)
        initChart(surface: surface2)
    }

    fileprivate func initChart(surface: SCIChartSurface) {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        for i in 0..<PointsCount {
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(Double(PointsCount) * sin(Double(i) * .pi * 0.1) / Double(i)))
        }
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.strokeStyle = SCISolidPenStyle(color: UIColor.green, withThickness: 1.0)
        rSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            surface.xAxes.add(xAxis)
            surface.yAxes.add(yAxis)
            surface.renderableSeries.add(rSeries)
            surface.chartModifiers = SCIChartModifierCollection(childModifiers: [self._xDragModifierSync, self._yDragModifierSync, self._pinchZoomModifierSync, self._zoomExtentsModifierSync, self._rolloverModifierSync])
            
            self._rangeSync.attachAxis(xAxis)
        }
    }
}
