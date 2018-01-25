//
//  SCSFanChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/22/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSFanChartView: UIView {
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
        surface.xAxes.add(SCIDateTimeAxis())
        surface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addDataSeries() {
        
        let dataSeries = SCIXyDataSeries(xType:.dateTime, yType:.float)
        let xyyDataSeries = SCIXyyDataSeries(xType:.dateTime, yType:.float)
        let xyyDataSeries1 = SCIXyyDataSeries(xType:.dateTime, yType:.float)
        let xyyDataSeries2 = SCIXyyDataSeries(xType:.dateTime, yType:.float)
        
        self.generatingDataPoints(10) { (result: SCSDataPoint) in
            dataSeries.appendX(SCIGeneric(result.date), y: SCIGeneric(result.actualValue))
            xyyDataSeries.appendX(SCIGeneric(result.date), y1: SCIGeneric(result.maxValue), y2: SCIGeneric(result.minValue))
            xyyDataSeries1.appendX(SCIGeneric(result.date), y1: SCIGeneric(result.value1), y2: SCIGeneric(result.value4))
            xyyDataSeries2.appendX(SCIGeneric(result.date), y1: SCIGeneric(result.value2), y2: SCIGeneric(result.value3))
        }
      
        let dataRenderSeries = SCIFastLineRenderableSeries()
        dataRenderSeries.dataSeries = dataSeries
        dataRenderSeries.strokeStyle = SCISolidPenStyle(color: UIColor.red, withThickness: 1.0)
        dataRenderSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        
        surface.renderableSeries.add(createRenderableSeriesWith(xyyDataSeries))
        surface.renderableSeries.add(createRenderableSeriesWith(xyyDataSeries1))
        surface.renderableSeries.add(createRenderableSeriesWith(xyyDataSeries2))
        surface.renderableSeries.add(dataRenderSeries)
        
        
    }
    
    fileprivate func createRenderableSeriesWith(_ dataSeries: SCIXyyDataSeries) -> SCIFastBandRenderableSeries {
        let renderebleDataSeries = SCIFastBandRenderableSeries()
        renderebleDataSeries.style.fillBrushStyle = SCISolidBrushStyle(color: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5))
        renderebleDataSeries.style.fillY1BrushStyle = SCISolidBrushStyle(color: UIColor.init(red: 1.0, green: 0.4, blue: 0.4, alpha: 0.5))
        renderebleDataSeries.style.strokeStyle = SCISolidPenStyle(color: UIColor.clear, withThickness: 1.0)
        renderebleDataSeries.style.strokeY1Style = SCISolidPenStyle(color: UIColor.clear, withThickness: 1.0)
        renderebleDataSeries.dataSeries = dataSeries
        renderebleDataSeries.addAnimation(SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        return renderebleDataSeries;
    }
    
    fileprivate func generatingDataPoints(_ count: Int, handler: (SCSDataPoint) -> Void) {
        var dateTime = Date()
        var lastValue: Double = 0.0

        for i in 0..<count {
            let nextValue = lastValue + SCSDataManager.randomize(-0.5, max: 0.5)
            lastValue = nextValue
            dateTime = dateTime.addingTimeInterval(3600*24)
            
            var dataPoint = SCSDataPoint()
            dataPoint.date = dateTime
            dataPoint.actualValue = nextValue
            if i > 4 {
                dataPoint.maxValue = nextValue + (Double(i) - 5) * 0.3
                dataPoint.value4 = nextValue + (Double(i) - 5) * 0.2
                dataPoint.value3 = nextValue + (Double(i) - 5) * 0.1
                dataPoint.value2 = nextValue - (Double(i) - 5) * 0.1
                dataPoint.value1 = nextValue - (Double(i) - 5) * 0.2
                dataPoint.minValue = nextValue - (Double(i) - 5) * 0.3
            }
            handler(dataPoint)
        }
    }
}

public struct SCSDataPoint {
    var maxValue = Double.nan
    var minValue = Double.nan
    var value1 = Double.nan
    var value2 = Double.nan
    var value3 = Double.nan
    var value4 = Double.nan
    var actualValue = Double.nan
    var date = Date()
}
