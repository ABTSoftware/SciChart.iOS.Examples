//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DragAreaToZoomViewController.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class DragAreaToZoomViewController: SCDDragAreaToZoomViewControllerBase {

    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let data = SCDRandomWalkGenerator().setBias(0.0001).getRandomWalkSeries(10000)
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.append(x: data.xValues, y: data.yValues)
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 1.0)
        
        rubberBand = SCIRubberBandXyZoomModifier()
        rubberBand.isXAxisOnly = isXAxisOnly
        rubberBand.isAnimated = useAnimation
        rubberBand.zoomExtentsY = zoomExtentsY
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(items: SCIZoomExtentsModifier(), self.rubberBand)
            
            SCIAnimations.sweep(rSeries, duration: 3.0, easingFunction: SCICubicEase())
        }
    }
}
