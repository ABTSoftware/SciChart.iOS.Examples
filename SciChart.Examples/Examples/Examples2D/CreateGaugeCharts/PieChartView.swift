//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PieChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class PieChartView: SCDSingleChartViewController<SCIPieChartSurface> {
    
    override var associatedType: AnyClass { return SCIPieChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        let pieSeries = SCIPieRenderableSeries()
        pieSeries.segmentsCollection.add(segmentWithValue(segmentValue: 40, title: "Green", centerColor: 0xFF34c19c, edgeColor: 0xFF34c19c))
        pieSeries.segmentsCollection.add(segmentWithValue(segmentValue: 10, title: "Red", centerColor: 0xFFc43360, edgeColor: 0xFFc43360))
        pieSeries.segmentsCollection.add(segmentWithValue(segmentValue: 20, title: "Blue", centerColor: 0xFF373dbc, edgeColor: 0xFF373dbc))
        pieSeries.segmentsCollection.add(segmentWithValue(segmentValue: 15, title: "Yellow", centerColor: 0xffe8c667, edgeColor: 0xffe8c667))
        
        let selectionModifier = SCIPieSegmentSelectionModifier()

        let legendModifier = SCIPieChartLegendModifier()
        legendModifier.sourceSeries = pieSeries;
        legendModifier.margins = SCIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        legendModifier.position = [.bottom, .centerHorizontal];
        
        surface.renderableSeries.add(pieSeries)
        surface.chartModifiers.add(legendModifier)
        surface.chartModifiers.add(selectionModifier)
        
        // setting scale to 0 - needed for animation
        // by default scale == 1, so that when the animation starts - the pie chart might be already drawn
        pieSeries.scale = 0
        pieSeries.animate(withDuration: 0.7)
    }
    
    func segmentWithValue(segmentValue: Double, title: String, centerColor: UInt32, edgeColor: UInt32) -> SCIPieSegment {
        let segment = SCIPieSegment()
        segment.value = segmentValue
        segment.title = title
        segment.fillStyle = SCIRadialGradientBrushStyle(centerColor: centerColor, edgeColor: edgeColor)
        
        return segment
    }
}
