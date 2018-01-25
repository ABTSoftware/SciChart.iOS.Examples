//
//  StackedColumnFullFillChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 5/22/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSStackedColumnFullFillChartView: UIView {
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
        
        surface.chartModifiers.add(SCILegendModifier())
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        let xAxis = SCIDateTimeAxis()
        xAxis.textFormatting = "dd/MM/yyyy"
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.01), max: SCIGeneric(0.01))
        surface.xAxes.add(xAxis)
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.01), max: SCIGeneric(0.01))
        surface.yAxes.add(yAxis)
    }
    
    fileprivate func addDataSeries() {
        
        let stackedGroup = SCIVerticallyStackedColumnsCollection()
        stackedGroup.isOneHundredPercentSeries = true
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(2, andFillColor: 0xffdc443f))
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(4, andFillColor: 0xff8562b4))
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(1, andFillColor: 0xffff9a2e))
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(0, andFillColor: 0xff226fb7))
        stackedGroup.add(self.p_getRenderableSeriesWithIndex(3, andFillColor: 0xffaad34f))
        
        let animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        stackedGroup.addAnimation(animation)
        
        surface.renderableSeries.add(stackedGroup)
    }
    
    fileprivate func p_getRenderableSeriesWithIndex(_ index: Int, andFillColor fillColor: uint) -> SCIStackedColumnRenderableSeries {
        let renderableSeries = SCIStackedColumnRenderableSeries()
        renderableSeries.strokeStyle = nil;
        renderableSeries.fillBrushStyle = SCISolidBrushStyle(colorCode: fillColor)
        renderableSeries.dataSeries = SCSDataManager.stackedVerticalColumnSeries()[index]
        return renderableSeries
    }
    
    
}
