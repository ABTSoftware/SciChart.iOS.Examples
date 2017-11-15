//
//  SCSPieChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 11/14/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSPieChartView: UIView{
    let surface = SCIPieChartSurface()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    // MARK: initialize surface
    fileprivate func addSurface() {
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(surface)
    }
    
    // MARK: Overrided Functions
    
    func completeConfiguration() {
        addSurface()
        addRenderSeries()
    }
    
    func addRenderSeries() {
        let pieSeries = SCIPieRenderableSeries()
        
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 40, title: "Green", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff84BC3D, finish: 0xff5B8829)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 10, title: "Red", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 20, title: "Blue", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff4AB6C1, finish: 0xff2182AD)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 15, title: "Yellow", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffFFFF00, finish: 0xfffed325)))
        
        surface.renderableSeries.add(pieSeries)
        
        let legendModifier = SCIPieLegendModifier.init(position: .top, andOrientation: .vertical)
        legendModifier?.pieSeries = pieSeries;
        
        surface.chartModifiers.add(legendModifier!)
    }
    
    func buildSegmentWithValue(segmentValue: Double, title: String, gradientBrush: SCIRadialGradientBrushStyle) -> SCIPieSegment{
        let segment = SCIPieSegment()
        segment.fillStyle = gradientBrush
        segment.value = segmentValue
        segment.title = title
        
        return segment
    }
}
