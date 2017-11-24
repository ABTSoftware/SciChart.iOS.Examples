//
//  SCSNestedPieChartsView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 11/17/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSNestedPieChartsView: UIView{
    let surface = SCIPieChartSurface()
    let pieSeries = SCIPieRenderableSeries()
    let donutSeries = SCIDonutRenderableSeries()
    
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
        surface.backgroundColor = UIColor.darkGray;
        surface.layoutManager?.seriesSpacing = 3
        surface.layoutManager?.segmentSpacing = 3
    }
    
    func addRenderSeries() {
        
        // hiding the pie and donut Renderable series - needed for animation
        // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
        pieSeries.isVisible = false
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 34, title: "Ecologic", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff84BC3D, finish: 0xff5B8829)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 34.4, title: "Municipal", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 31.6, title: "Personal", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff4AB6C1, finish: 0xff2182AD)))
        pieSeries.drawLabels = true
        
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
        donutSeries.drawLabels = true
        
        // adding animations for the pie renderable series
        self.pieSeries.isVisible = false
        self.donutSeries.isVisible = false
        DispatchQueue.main.async {
            self.pieSeries.animate(0.7)
            self.pieSeries.isVisible = true
            self.donutSeries.animate(0.7)
            self.donutSeries.isVisible = true
        }
        
        surface.renderableSeries.add(pieSeries)
        surface.renderableSeries.add(donutSeries)
        
        // Adding some basic modifiers - Legend and Selection
        let pieLegendModifier = SCIPieLegendModifier.init(position: .bottom, andOrientation: .vertical)
        pieLegendModifier?.pieSeries = pieSeries;
        
        surface.chartModifiers.add(pieLegendModifier!)
        surface.chartModifiers.add(SCIPieSelectionModifier())
    }
    
    /*
     Function for building the Segments for Pie and Donut Renderable series
     */
    func buildSegmentWithValue(segmentValue: Double, title: String, gradientBrush: SCIRadialGradientBrushStyle) -> SCIPieSegment{
        let segment = SCIPieSegment()
        segment.fillStyle = gradientBrush
        segment.value = segmentValue
        segment.title = title
        return segment
    }
}
