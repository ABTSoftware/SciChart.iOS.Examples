//
//  SCSStackedColumnSideBySideChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 11/10/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSStackedColumnSideBySideChartView: UIView {
    let surface = SCIChartSurface()
    
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
        addAxis()
        addDefaultModifiers()
        addDataSeries()
    }
    
    // MARK: Private Methods
    
    func addDefaultModifiers() {
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        surface.chartModifiers = groupModifier
        
        let legendModifier = SCILegendModifier()
        surface.chartModifiers.add(legendModifier)
    }
    
    fileprivate func addAxis() {
        surface.xAxes.add(SCICategoryNumericAxis())
        
        let yAxis = SCINumericAxis()
        yAxis.axisTitle = "billions of People"
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        let horizontalStacked = SCIHorizontallyStackedColumnsCollection()
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(0, andFillColor: 0xff3399ff, andBorderColor: 0xff2d68bc, seriesName: "China"))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(1, andFillColor: 0xff014358, andBorderColor: 0xff013547, seriesName: "India"))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(2, andFillColor: 0xff1f8a71, andBorderColor: 0xff1b5d46, seriesName: "USA"))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(3, andFillColor: 0xffbdd63b, andBorderColor: 0xff7e952b, seriesName: "Indonesia"))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(4, andFillColor: 0xffffe00b, andBorderColor: 0xffaa8f0b, seriesName: "Brazil"))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(5, andFillColor: 0xfff27421, andBorderColor: 0xffa95419, seriesName: "Pakistan"))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(6, andFillColor: 0xffbb0000, andBorderColor: 0xff840000, seriesName: "Nigeria"))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(7, andFillColor: 0xff550033, andBorderColor: 0xff370018, seriesName: "Bangladesh"))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(8, andFillColor: 0xff339933, andBorderColor: 0xff2d773d, seriesName: "Russia"))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(9, andFillColor: 0xff00ada9, andBorderColor: 0xff006c6a, seriesName: "Japan"))
        horizontalStacked.add(self.p_getRenderableSeriesWithIndex(10, andFillColor: 0xff560068, andBorderColor: 0xff3d0049, seriesName: "Rest of The World"))
        
        let animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        horizontalStacked.addAnimation(animation)
        
        surface.renderableSeries.add(horizontalStacked)
    }
    
    fileprivate func p_getRenderableSeriesWithIndex(_ index: Int, andFillColor fillColor: uint, andBorderColor borderColor: uint, seriesName:String) -> SCIStackedColumnRenderableSeries {
        let renderableSeries = SCIStackedColumnRenderableSeries()
        renderableSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: fillColor)
        renderableSeries.strokeStyle = SCISolidPenStyle(colorCode: borderColor, withThickness: 1)
        renderableSeries.dataSeries = SCSDataManager.stackedSideBySideDataSeries()[index]
        renderableSeries.dataSeries.seriesName = seriesName
        
        return renderableSeries
    }
    
}
