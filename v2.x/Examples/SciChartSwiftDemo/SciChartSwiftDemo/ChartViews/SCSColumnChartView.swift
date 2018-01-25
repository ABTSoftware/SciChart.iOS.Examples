//
//  SCSColumnChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class ColumnsTripleColorPalette : SCIPaletteProvider {
    let style1 : SCIColumnSeriesStyle = SCIColumnSeriesStyle()
    let style2 : SCIColumnSeriesStyle = SCIColumnSeriesStyle()
    let style3 : SCIColumnSeriesStyle = SCIColumnSeriesStyle()
    
    override init() {
        super.init()
        style1.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFFa9d34f,
                                                       finish: 0xFF93b944,
                                                       direction: .vertical)
        style1.strokeStyle = SCISolidPenStyle(colorCode: 0xFF232323, withThickness: 0.4)
        
        style2.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFFfc9930,
                                                       finish: 0xFFd17f28,
                                                       direction: .vertical)
        style2.strokeStyle = SCISolidPenStyle(colorCode: 0xFF232323, withThickness: 0.4)
        
        style3.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFFd63b3f,
                                                       finish: 0xFFbc3337,
                                                       direction: .vertical)
        style3.strokeStyle = SCISolidPenStyle(colorCode: 0xFF232323, withThickness: 0.4)
    }
    
    override func styleFor(x: Double, y: Double, index: Int32) -> SCIStyleProtocol! {
        let styleIndex : Int32 = index % 3;
        if (styleIndex == 0) {
            return style1;
        } else if (styleIndex == 1) {
            return style2;
        } else {
            return style3;
        }
    }
}

class SCSColumnChartView: UIView {
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
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        surface.xAxes.add(SCIDateTimeAxis())
        surface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries() {
        
        let dataSeries = SCIXyDataSeries(xType: .dateTime, yType: .float)
        
        SCSDataManager.loadData(into: dataSeries,
                                fileName: "ColumnData",
                                startIndex: 0,
                                increment: 1,
                                reverse: false)
        
        let columnRenderableSeries = SCIFastColumnRenderableSeries()
        columnRenderableSeries.paletteProvider = ColumnsTripleColorPalette()
        columnRenderableSeries.dataSeries = dataSeries
        
        let animation = SCIWaveRenderableSeriesAnimation(duration: 1.5, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        columnRenderableSeries.addAnimation(animation)
        
        surface.renderableSeries.add(columnRenderableSeries)
        
    }
    
}
