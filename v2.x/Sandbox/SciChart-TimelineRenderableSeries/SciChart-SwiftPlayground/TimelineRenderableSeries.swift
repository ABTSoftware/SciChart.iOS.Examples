//
//  StaticLineAnnotation.swift
//  SciChart-SwiftPlayground
//
//  Created by Andriy Shkinder on 4/25/19.
//  Copyright © 2019 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class TimelineRenderableSeries: SCICustomRenderableSeries {
    
    var height: Float = 10
    
    fileprivate func convert<T>(data: UnsafePointer<T>, count: Int) -> [T] {
        let buffer = UnsafeBufferPointer(start: data, count: count)
        return Array(buffer)
    }
    
    override func internalDraw(withContext renderContext: SCIRenderContext2DProtocol!, withData renderPassData: SCIRenderPassDataProtocol!) {
        let pointSeries = renderPassData.pointSeries() as! SCIPointSeries
        
        let xCalc = renderPassData.xCoordinateCalculator()!
        
        let xController = pointSeries.xValues()!
        let yController = pointSeries.yValues()!
        
        let xValues = convert(data: xController.doubleData()!, count:Int(xController.count()))
        let yValues = convert(data: yController.doubleData()!, count:Int(yController.count()))
        
        for i in 0..<Int(pointSeries.count()) {
            let xStart = xCalc.getCoordinateFrom(xValues[i])
            let xEnd = xCalc.getCoordinateFrom(xValues[i] + yValues[i])
            let yTop = Float(renderContext.viewportSize().height) - height
            let yBottom = Float(renderContext.viewportSize().height)
            
            let color = provideColor(at: i)
            
            let brush = renderContext.createBrush(fromStyle: SCISolidBrushStyle(color: color))
            renderContext.drawRect(withBrush: brush, fromX: Float(xStart), y: yTop, toX: Float(xEnd), y:yBottom)
        }
    }
    
    let colors = [UIColor.red, UIColor.blue, UIColor.green]
    fileprivate func provideColor(at index: Int) -> UIColor {
        return colors[index]
    }
    
    override func getXRange() -> SCIRangeProtocol! {
        let count = dataSeries.count()
        
        let min = dataSeries.xValues().value(at: 0)
        let max = SCIGeneric(SCIGenericDouble(dataSeries.xValues().value(at:count - 1)) + SCIGenericDouble(dataSeries.yValues().value(at: count - 1)))
        
        return SCIDoubleRange(min: min, max: max)
    }
}
