//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DonutChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class DonutChartView: SCDSingleChartViewController<SCIPieChartSurface> {
    
    override var associatedType: AnyClass { return SCIPieChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }

    override func initExample() {
        let donutSeries = SCIDonutRenderableSeries()
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 40, title: "Green", centerColor: 0xff84BC3D, edgeColor: 0xff5B8829))
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 10, title: "Red", centerColor: 0xffe04a2f, edgeColor: 0xffB7161B))
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 20, title: "Blue", centerColor: 0xff4AB6C1, edgeColor: 0xff2182AD))
        donutSeries.segmentsCollection.add(segmentWithValue(segmentValue: 15, title: "Yellow", centerColor: 0xffFFFF00, edgeColor: 0xfffed325))
        
        let selectionModifier = SCIPieSegmentSelectionModifier()
        
        let legendModifier = SCIPieChartLegendModifier()
        legendModifier.sourceSeries = donutSeries;
        legendModifier.margins = SCIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        legendModifier.position = [.bottom, .centerHorizontal];
        
        surface.holeRadius = 100;
        surface.holeRadiusSizingMode = .absolute
        
        surface.renderableSeries.add(donutSeries)
        surface.chartModifiers.add(legendModifier)
        surface.chartModifiers.add(selectionModifier)
        
        // setting scale to 0 - needed for animation
        // by default scale == 1, so that when the animation starts - the pie chart might be already drawn
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
