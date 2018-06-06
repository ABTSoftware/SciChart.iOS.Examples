//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MultiPieDonutChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class MultiPieDonutChartView: SinglePieChartWithLegendLayout {
    
    override func initExample() {
        // Initializing and hiding the pie and donut Renderable series - needed for animation
        // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn

        let pieSeries = SCIPieRenderableSeries()
        pieSeries.isVisible = false
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 34, title: "Ecologic", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff84BC3D, finish: 0xff5B8829)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 34.4, title: "Municipal", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 31.6, title: "Personal", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff4AB6C1, finish: 0xff2182AD)))

        let donutSeries = SCIDonutRenderableSeries()
        donutSeries.isVisible = false
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 28.8, title: "Walking", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff84BC3D, finish: 0xff5B8829)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 5.2, title: "Bycicle", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff84BC3D, finish: 0xff5B8829)))
        
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 12.3, title: "Metro", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 3.5, title: "Tram", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 5.9, title: "Rail", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 9.7, title: "Bus", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 3, title: "Taxi", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 23.1, title: "Car", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff4AB6C1, finish: 0xff2182AD)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 3.1, title: "Motor", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff4AB6C1, finish: 0xff2182AD)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 5.3, title: "Other", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff4AB6C1, finish: 0xff2182AD)))
        
        DispatchQueue.main.async {
            pieSeries.animate(0.7)
            pieSeries.isVisible = true
            donutSeries.animate(0.7)
            donutSeries.isVisible = true
        }
        
        let legendModifier = SCIPieLegendModifier()
        legendModifier.orientation = .vertical;
        legendModifier.position = .bottom;
        legendModifier.sourceSeries = pieSeries;
        
        pieChartSurface.renderableSeries.add(pieSeries)
        pieChartSurface.renderableSeries.add(donutSeries)
        pieChartSurface.chartModifiers.add(legendModifier)
        pieChartSurface.chartModifiers.add(SCIPieSelectionModifier())
    }
    
    func buildSegmentWithValue(segmentValue: Double, title: String, gradientBrush: SCIRadialGradientBrushStyle) -> SCIPieSegment {
        let segment = SCIPieSegment()
        segment.fillStyle = gradientBrush
        segment.value = segmentValue
        segment.title = title
        
        return segment
    }
}
