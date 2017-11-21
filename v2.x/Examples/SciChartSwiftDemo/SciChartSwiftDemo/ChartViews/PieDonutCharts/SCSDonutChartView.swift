//
//  SCSDonutChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 11/15/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

//
//  SCSPieChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 11/14/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSDonutChartView: UIView{

    let surface = SCIPieChartSurface()
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
    }
    
    func addRenderSeries() {
        // hiding the Donut Renderable series - needed for animation
        // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
        donutSeries.isVisible = false
        
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 40, title: "Green", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff84BC3D, finish: 0xff5B8829)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 10, title: "Red", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffe04a2f, finish: 0xffB7161B)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 20, title: "Blue", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xff4AB6C1, finish: 0xff2182AD)))
        donutSeries.segments.add(buildSegmentWithValue(segmentValue: 15, title: "Yellow", gradientBrush: SCIRadialGradientBrushStyle.init(colorCodeStart: 0xffFFFF00, finish: 0xfffed325)))
        
        // setting the DonutChart's hole radius
        surface.holeRadius = 100
        
        // adding animations for the donut renderable series
        DispatchQueue.main.async {
            self.donutSeries.startAnimation()
            self.donutSeries.isVisible = true
        }
        
        surface.renderableSeries.add(donutSeries)
        
        // Adding some basic modifiers - Legend and Selection
        let legendModifier = SCIPieLegendModifier.init(position: .bottom, andOrientation: .vertical)
        legendModifier?.pieSeries = donutSeries;
        
        surface.chartModifiers.add(legendModifier!)
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
        segment.centerOffset = 2;
        return segment
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        let drawLabelsSwitch = UISwitch.init(frame: CGRect.init(x: surface.frame.size.width - 180, y: 20, width: 0, height: 0))
        drawLabelsSwitch.addTarget(self, action: #selector(switchChanged), for: .valueChanged)
        
        let drawLabelsLabel = UILabel.init(frame: CGRect.init(x: surface.frame.size.width - 120, y: 20, width: 110, height: 30))
        drawLabelsLabel.text = "Draw Labels"
        drawLabelsLabel.textColor = UIColor.white
        
        surface.addSubview(drawLabelsLabel)
        surface.addSubview(drawLabelsSwitch)
    }
    
    /*
     UISwitch valueChanged handler
     */
    @objc func switchChanged(sender: UISwitch) {
        if(sender.isOn){
            donutSeries.drawLabels = true
            surface.invalidateElement()
        } else{
            donutSeries.drawLabels = false
            surface.invalidateElement()
        }
    }
}

