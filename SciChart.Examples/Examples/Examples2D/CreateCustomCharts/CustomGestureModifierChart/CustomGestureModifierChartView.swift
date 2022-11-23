//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomGestureModifierChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class CustomGestureModifierChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let ds1points = SCDDataManager.getDampedSinewave(withAmplitude: 1.0, dampingFactor: 0.05, pointCount: 50, freq: 5)
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        dataSeries.append(x: ds1points.xValues, y: ds1points.yValues)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = SCIPenStyle.transparent
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: 0xFF47bde6)
        ellipsePointMarker.size = CGSize(width: 10, height: 10)
        
        let rSeries = SCIFastImpulseRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = ellipsePointMarker
        rSeries.strokeStyle = SCISolidPenStyle(color: 0xFF47bde6, thickness: 1.0)
        
#if os(OSX)
        let zoomText = "Pan vertically to Zoom In/Out."
#elseif os(iOS)
        let zoomText = "Double Tap and pan vertically to Zoom In/Out."
#endif
        let annotation = SCITextAnnotation()
        annotation.text = zoomText + " \nDouble tap to Zoom Extents."
        annotation.fontStyle = SCIFontStyle(fontSize: 16, andTextColor: .white)
        annotation.set(x1: 0.5)
        annotation.set(y1: 0)
        annotation.coordinateMode = .relative
        annotation.verticalAnchorPoint = .top
        annotation.horizontalAnchorPoint = .center
        
        let customGestureModifier = CustomGestureModifier()
        customGestureModifier.receiveHandledEvents = true
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.annotations.add(annotation)
            self.surface.chartModifiers.add(items: customGestureModifier, SCIZoomExtentsModifier())
            
            SCIAnimations.wave(rSeries, duration: 3.0, andEasingFunction: SCICubicEase())
        }
    }
}
