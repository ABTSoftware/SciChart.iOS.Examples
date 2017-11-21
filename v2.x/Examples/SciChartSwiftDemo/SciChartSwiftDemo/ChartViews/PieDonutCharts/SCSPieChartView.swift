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
    let pieSeries = SCIPieRenderableSeries()
    
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
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        // adding UISwitch to have an ability to turn on/off the Pie chart's labels
        let drawLabelsSwitch = UISwitch.init(frame: CGRect.init(x: self.frame.size.width - 180, y: 20, width: 0, height: 0))
        drawLabelsSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        // UILabel - just to show what the UISwitch is added for
        let drawLabelsLabel = UILabel.init(frame: CGRect.init(x: self.frame.size.width - 120, y: 20, width: 110, height: 30))
        drawLabelsLabel.text = "Draw Labels"
        drawLabelsLabel.textColor = UIColor.white
        
        surface.addSubview(drawLabelsLabel)
        surface.addSubview(drawLabelsSwitch)
    }
    
    func addRenderSeries() {
        
        // hiding the pieRenderable series - needed for animation
        // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
        pieSeries.isVisible = false
        
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 40, title: "Green", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff84BC3D, finish: 0xff5B8829)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 10, title: "Red", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 20, title: "Blue", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff4AB6C1, finish: 0xff2182AD)))
        pieSeries.segments.add(buildSegmentWithValue(segmentValue: 15, title: "Yellow", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffFFFF00, finish: 0xfffed325)))
        
        // adding animations for the pie renderable series
        DispatchQueue.main.async {
            self.pieSeries.startAnimation()
            self.pieSeries.isVisible = true
        }
        
        surface.renderableSeries.add(pieSeries)
        
        // adding legend modifier for pir renderable series
        // requires setting the pieSeries property
        let legendModifier = SCIPieLegendModifier.init(position: .bottom, andOrientation: .vertical)
        legendModifier?.pieSeries = pieSeries;
        
        surface.chartModifiers.add(legendModifier!)
        
        //adding the PieSelectionModifier
        surface.chartModifiers.add(SCIPieSelectionModifier())
    }
    
    /*
     Function for building the Segments for Pie Renderable series
     */
    func buildSegmentWithValue(segmentValue: Double, title: String, gradientBrush: SCIRadialGradientBrushStyle) -> SCIPieSegment{
        let segment = SCIPieSegment()
        segment.fillStyle = gradientBrush
        segment.value = segmentValue
        segment.title = title
        
        return segment
    }
    
    /*
     UISwitch valueChanged handler
     */
    @objc func switchChanged(sender: UISwitch) {
        if(sender.isOn){
            pieSeries.drawLabels = true
            surface.invalidateElement()
        } else{
            pieSeries.drawLabels = false
            surface.invalidateElement()
        }
    }
}
