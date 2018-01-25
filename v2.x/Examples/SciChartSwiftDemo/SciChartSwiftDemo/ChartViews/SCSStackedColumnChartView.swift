//
//  SCSStackedColumnVerticalChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 11/10/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSStackedColumnChartView: UIView {
    let surface = SCIChartSurface()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
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
    
    fileprivate func addAxis() {
        let xAxis = SCIDateTimeAxis()
        xAxis.textFormatting = "yyyy"
        surface.xAxes.add(xAxis)
        surface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries() {
        
        let stackedGroup = SCIVerticallyStackedColumnsCollection()
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(0, andFillColor: 0xff226fb7))
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(1, andFillColor: 0xffff9a2e))
        
        let stackedGroup_2 = SCIVerticallyStackedColumnsCollection()
        stackedGroup_2.add(self.p_getRenderableSeriesWithIndex(2, andFillColor: 0xffdc443f))
        stackedGroup_2.add(self.p_getRenderableSeriesWithIndex(3, andFillColor: 0xffaad34f))
        stackedGroup_2.add(self.p_getRenderableSeriesWithIndex(4, andFillColor: 0xff8562b4))
        
        let horizontalStacked = SCIHorizontallyStackedColumnsCollection()
        horizontalStacked.add(stackedGroup)
        horizontalStacked.add(stackedGroup_2)
        horizontalStacked.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        surface.renderableSeries.add(horizontalStacked)
    }
    
    fileprivate func p_getRenderableSeriesWithIndex(_ index: Int, andFillColor fillColor: uint) -> SCIStackedColumnRenderableSeries {
        let renderableSeries = SCIStackedColumnRenderableSeries()
        renderableSeries.strokeStyle = nil;
        renderableSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: fillColor)
        renderableSeries.dataSeries = SCSDataManager.stackedVerticalColumnSeries()[index]
        return renderableSeries
    }
    
}
