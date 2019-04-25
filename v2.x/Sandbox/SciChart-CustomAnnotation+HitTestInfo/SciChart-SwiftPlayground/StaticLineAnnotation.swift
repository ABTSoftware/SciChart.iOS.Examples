//
//  StaticLineAnnotation.swift
//  SciChart-SwiftPlayground
//
//  Created by Andriy Shkinder on 4/25/19.
//  Copyright © 2019 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class StaticLineAnnotation: SCIAnnotationBase {
    
    var position: CGFloat = 10.0
    let style = SCILineAnnotationStyle()
    var pointMarker: SCIPointMarkerProtocol?
    
    var onSelectedPointsChanged: (() -> ())?
    var selectedPointsSeriesInfo = [SCISeriesInfo]() {
        didSet {
            if !selectedPointsSeriesInfo.elementsEqual(oldValue) {
                onSelectedPointsChanged?()
            }
        }
    }
    
    override init() {
        super.init()
        style.linePen.color = UIColor.yellow
    }
    
    private var chartFrame: CGRect {
        return self.parentSurface.renderSurface!.chartFrame()
    }
    
    private var startX: Float  {
        return Float(chartFrame.width - position)
    }
    
    private var startY: Float  {
        return 0.0
    }
    
    private var endX: Float {
        return Float(chartFrame.width - position)
    }
    
    private var endY: Float {
        return Float(chartFrame.height)
    }
    
    private var context: SCIRenderContext2DProtocol {
        return style.annotationSurface == .aboveChart ? parentSurface.renderSurface!.modifierContext() : parentSurface.renderSurface!.secondaryContext()
    }
    
    override func draw() {
        guard !self.isHidden else {
            return
        }
        
        guard self.style.linePen != nil else {
            return
        }
        context.save()
        context.setDrawingArea(chartFrame)
        context.drawLine(withBrush: context.createPen(fromStyle: style.linePen!)!, fromX: startX, y: startY, toX:endX, y: endY)
        drawPointMarkers()
        context.restore()
    }
    
    private func drawPointMarkers() {
        guard let marker = pointMarker else {
            return
        }
        let renderableSeries = parentSurface.renderableSeries
        var newSeriesInfo = [SCISeriesInfo]()
        
        for i in 0 ..< renderableSeries.count() {
            guard let rs = renderableSeries.item(at: UInt32(i)) else {
                continue
            }
            guard let data = rs.currentRenderPassData else {
                continue
            }
            guard let hitTest = rs.hitTestProvider() else {
                continue
            }
            
            let hitTestInfo = hitTest.hitTestAt(x: Double(startX), y: Double(startY), radius:1, onData: data, mode: .vertical)
            if hitTestInfo.match.boolValue == true {
                newSeriesInfo.append(rs.toSeriesInfo(withHitTest: hitTestInfo))
                let xCalc = data.xCoordinateCalculator()
                let yCalc = data.yCoordinateCalculator()
                if let xCoord = xCalc?.getCoordinateFrom(SCIGenericDouble(hitTestInfo.xValue)),
                    let yCoord = yCalc?.getCoordinateFrom(SCIGenericDouble(hitTestInfo.yValue)) {
                    guard !xCoord.isNaN && !yCoord.isNaN else {
                        continue
                    }
                    marker.strokeStyle.color = rs.seriesColor()
                    marker.fillStyle.color = rs.seriesColor()
                    marker.draw(toContext: context, atX: Float(xCoord), y: Float(yCoord))
                }
            }
        }
        selectedPointsSeriesInfo = newSeriesInfo
    }
}
