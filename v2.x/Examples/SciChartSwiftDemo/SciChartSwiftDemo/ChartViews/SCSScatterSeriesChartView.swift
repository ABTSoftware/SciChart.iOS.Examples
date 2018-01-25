//
//  SCSScatterSeriesChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSScatterSeriesChartView: UIView {
    
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
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier])
        
        
        let cursor = SCICursorModifier()
        cursor.style.hitTestMode = .point
        cursor.modifierName = "CursorModifier"
        cursor.style.hitTestMode = .point
        cursor.style.colorMode = SCITooltipColorMode.seriesColorToDataView;
        cursor.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        groupModifier.add(cursor)
        
        surface.chartModifiers = groupModifier
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        surface.xAxes.add(SCIDateTimeAxis())
        surface.yAxes.add(SCINumericAxis())
    }
    

    fileprivate func addDataSeries() {
        
        surface.renderableSeries.add(getScatterRenderableSeries(withDetalization: 3,
            colorCode: 0xFFffeb01,
            negative: false))
        surface.renderableSeries.add(getScatterRenderableSeries(withDetalization: 6,
            colorCode: 0xFFffa300,
            negative: false))
        
        surface.renderableSeries.add(getScatterRenderableSeries(withDetalization: 3,
            colorCode: 0xFFff6501,
            negative: true))
        surface.renderableSeries.add(getScatterRenderableSeries(withDetalization: 6,
            colorCode: 0xFFffa300,
            negative: true))
        
        
        
    }
    
    fileprivate func getScatterRenderableSeries(withDetalization pointMarker: Int32, colorCode: UInt32, negative: Bool) -> SCIXyScatterRenderableSeries {
        
        
        let dataSeries = SCIXyDataSeries(xType: .dateTime, yType: .float)
        putDataInto(dataSeries, belowZeroY: negative)
        
        dataSeries.seriesName = (pointMarker == 6) ?
            (negative ? "Negative Hex" : "Positive Hex") :
            (negative ? "Negative" : "Positive")
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let scatterRenderableSeries = SCIXyScatterRenderableSeries()
        scatterRenderableSeries.dataSeries = dataSeries
        
        let ellipse = SCIEllipsePointMarker()
        ellipse.fillStyle = SCISolidBrushStyle(colorCode: colorCode)
        ellipse.strokeStyle = SCISolidPenStyle(colorCode: 0xfffffff, withThickness: 0.1)
        ellipse.detalization = pointMarker
        ellipse.height = 6.0
        ellipse.width = 6.0
        
        scatterRenderableSeries.style.pointMarker = ellipse
        let animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        scatterRenderableSeries.addAnimation(animation)
        
        return scatterRenderableSeries
    }
    
    fileprivate func putDataInto(_ dataSeries: SCIXyDataSeries, belowZeroY: Bool) {
        
        var i : UInt32 = 0
        while i < 200 {
            
            let x = i
            let time = (i < 100) ? arc4random_uniform(x+10) : arc4random_uniform(200-x+10)
            let y = time*time*time
            
            if belowZeroY {
                dataSeries.appendX(SCIGeneric(Double(x)), y: SCIGeneric(-Int32(y)))
            }
            else {
                dataSeries.appendX(SCIGeneric(Double(x)), y: SCIGeneric(y))
            }
            
            i = i + 1
        }
        
    }
    
}
