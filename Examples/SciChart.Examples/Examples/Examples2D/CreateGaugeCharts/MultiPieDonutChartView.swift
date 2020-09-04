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

class MultiPieDonutChartView: SCDSingleChartViewController<SCIPieChartSurface> {
    
    override var associatedType: AnyClass { return SCIPieChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        let pieSeries = SCIPieRenderableSeries()
        pieSeries.segmentsCollection.add(segmentWithValue(segmentValue: 34, title: "Ecologic", centerColor: 0xff84BC3D, edgeColor: 0xff5B8829))
        pieSeries.segmentsCollection.add(segmentWithValue(segmentValue: 34.4, title: "Municipal", centerColor: 0xffe04a2f, edgeColor: 0xffB7161B))
        pieSeries.segmentsCollection.add(segmentWithValue(segmentValue: 31.6, title: "Personal", centerColor: 0xff4AB6C1, edgeColor: 0xff2182AD))

        let donutSeries = SCIDonutRenderableSeries()
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 28.8, title: "Walking", centerColor: 0xff84BC3D, edgeColor: 0xff5B8829))
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 5.2, title: "Bycicle", centerColor: 0xff84BC3D, edgeColor: 0xff5B8829))
        
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 12.3, title: "Metro", centerColor: 0xffe04a2f, edgeColor: 0xffB7161B))
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 3.5, title: "Tram", centerColor: 0xffe04a2f, edgeColor: 0xffB7161B))
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 5.9, title: "Rail", centerColor: 0xffe04a2f, edgeColor: 0xffB7161B))
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 9.7, title: "Bus", centerColor: 0xffe04a2f, edgeColor: 0xffB7161B))
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 3, title: "Taxi", centerColor: 0xffe04a2f, edgeColor: 0xffB7161B))
        
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 23.1, title: "Car", centerColor: 0xff4AB6C1, edgeColor: 0xff2182AD))
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 3.1, title: "Motor", centerColor: 0xff4AB6C1, edgeColor: 0xff2182AD))
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 5.3, title: "Other", centerColor: 0xff4AB6C1, edgeColor: 0xff2182AD))
        
        let legendModifier = SCIPieChartLegendModifier()
        legendModifier.sourceSeries = pieSeries;
        legendModifier.margins = SCIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        legendModifier.position = [.bottom, .centerHorizontal];
        
        surface.renderableSeries.add(pieSeries)
        surface.renderableSeries.add(donutSeries)
        surface.chartModifiers.add(legendModifier)
        surface.chartModifiers.add(SCIPieChartTooltipModifier())
        
        // setting scale to 0 - needed for animation
        // by default scale == 1, so that when the animation starts - the pie chart might be already drawn
        pieSeries.scale = 0
        pieSeries.animate(withDuration: 0.7)
        donutSeries.scale = 0
        donutSeries.animate(withDuration: 0.7)
    }
    
    func segmentWithValue(segmentValue: Double, title: String, centerColor: UInt32, edgeColor: UInt32) -> SCIPieSegment {
        let segment = SCIPieSegment()
        segment.value = segmentValue
        segment.title = title
        segment.fillStyle = SCIRadialGradientBrushStyle(centerColorCode: centerColor, edgeColorCode: edgeColor)
        
        return segment
    }
}
