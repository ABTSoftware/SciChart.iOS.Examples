//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
        let pieSeries = SCIPieRenderableSeries()
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 34, title: "Ecologic", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xff84BC3D, edgeColorCode: 0xff5B8829)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 34.4, title: "Municipal", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xffe04a2f, edgeColorCode: 0xffB7161B)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 31.6, title: "Personal", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xff4AB6C1, edgeColorCode: 0xff2182AD)))

        let donutSeries = SCIDonutRenderableSeries()
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 28.8, title: "Walking", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xff84BC3D, edgeColorCode: 0xff5B8829)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 5.2, title: "Bycicle", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xff84BC3D, edgeColorCode: 0xff5B8829)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 12.3, title: "Metro", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xffe04a2f, edgeColorCode: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 3.5, title: "Tram", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xffe04a2f, edgeColorCode: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 5.9, title: "Rail", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xffe04a2f, edgeColorCode: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 9.7, title: "Bus", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xffe04a2f, edgeColorCode: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 3, title: "Taxi", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xffe04a2f, edgeColorCode: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 23.1, title: "Car", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xff4AB6C1, edgeColorCode: 0xff2182AD)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 3.1, title: "Motor", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xff4AB6C1, edgeColorCode: 0xff2182AD)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 5.3, title: "Other", gradientBrush: SCIRadialGradientBrushStyle(centerColorCode: 0xff4AB6C1, edgeColorCode: 0xff2182AD)))
        
        // Initializing and hiding the pie and donut Renderable series - needed for animation
        // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
        pieSeries.isVisible = false
        donutSeries.isVisible = false
        
        let legendModifier = SCIPieLegendModifier()
        legendModifier.sourceSeries = pieSeries;
        legendModifier.margins = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        legendModifier.position = [.bottom, .centerHorizontal];
        
        pieChartSurface.renderableSeries.add(pieSeries)
        pieChartSurface.renderableSeries.add(donutSeries)
        pieChartSurface.chartModifiers.add(legendModifier)
        pieChartSurface.chartModifiers.add(SCIPieTooltipModifier())
        
        DispatchQueue.main.async {
            pieSeries.animate(0.7)
            pieSeries.isVisible = true
            donutSeries.animate(0.7)
            donutSeries.isVisible = true
        }
    }
    
    func buildSegmentWithValue(segmentValue: Double, title: String, gradientBrush: SCIRadialGradientBrushStyle) -> SCIPieSegment {
        let segment = SCIPieSegment()
        segment.fillStyle = gradientBrush
        segment.value = segmentValue
        segment.title = title
        
        return segment
    }
}
