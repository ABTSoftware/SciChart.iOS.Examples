//
//  SCSInteractionWithAnnotations.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 03/05/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSInteractionWithAnnotations: SCSBaseChartView {
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        addSeries()
        setupAnnotations()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        chartSurface.xAxes.add(SCICategoryDateTimeAxis())
        
        let yAxis = SCINumericAxis()
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(30), max: SCIGeneric(37))
        yAxis.growBy = SCIDoubleRange.init(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        chartSurface.yAxes.add(yAxis)
    }
    
    override func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let zoomPanModifier = SCIZoomPanModifier()
        zoomPanModifier.clipModeX = .none;
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, zoomPanModifier])
        
        chartSurface.chartModifiers = groupModifier
    }
    
    private func addSeries(){
        let marketManager = SCSMarketDataService.init(start: Date.init(), timeFrameMinutes: 5, tickTimerIntervals: 5)
        let data:[SCSMultiPaneItem] = marketManager.getHistoricalData(200)
        
        let dataSeries = SCIOhlcDataSeries.init(xType: .dateTime, yType: .double, seriesType: .xCategory)
        for i in 0..<data.count {
            dataSeries.appendX(SCIGeneric(data[i].dateTime), open: SCIGeneric(data[i].open), high: SCIGeneric(data[i].high), low: SCIGeneric(data[i].low), close: SCIGeneric(data[i].close))
        }
        
        let candles = SCIFastCandlestickRenderableSeries()
        candles.dataSeries = dataSeries
        
        chartSurface.renderableSeries.add(candles)
    }
    
    fileprivate func setupAnnotations() {
        let annotationCollection = SCIAnnotationCollection()
        
        var textStyle = SCITextFormattingStyle()
        textStyle.fontSize = 20
        
        buildTextAnnotation(annotationCollection: annotationCollection,x:10, y:30.5,horizontalAnchorPoint: .left, verticalAnchorPoint: .bottom, textStyle: textStyle, coordMode: .absolute, text: "Buy!",color: 0xFFFFFFFF)
        buildTextAnnotation(annotationCollection: annotationCollection,x:50, y:34,horizontalAnchorPoint: .left, verticalAnchorPoint: .top, textStyle: textStyle, coordMode: .absolute, text: "Sell!",color: 0xFFFFFFFF)
        buildTextAnnotation(annotationCollection: annotationCollection,x:80, y:37,horizontalAnchorPoint: .left, verticalAnchorPoint: .top, textStyle: textStyle, coordMode: .absolute, text: "Rotated Text!",color: 0xFFFFFFFF)
        
        buildBoxAnnotation(annotationCollection: annotationCollection, x1: 50, y1: 35.5, x2: 120, y2: 32, brush: SCISolidBrushStyle.init(colorCode: 0x33FF6600), pen: SCISolidPenStyle.init(colorCode: 0x77FF6600, withThickness: 1.0))
        
        buildLineAnnotation(annotationCollection: annotationCollection, x1: 40, y1: 30.5, x2: 60, y2: 33.5, color: 0xAAFF6600, strokeThickness: 2.0)
        buildLineAnnotation(annotationCollection: annotationCollection, x1: 120, y1: 30.5, x2: 175, y2: 36, color: 0xAAFF6600, strokeThickness: 2.0)
        buildLineAnnotation(annotationCollection: annotationCollection, x1: 50, y1: 35, x2: 80, y2: 31.4, color: 0xAAFF6600, strokeThickness: 2.0)
        
        buildAxisMarkerAnnotation(annotationCollection: annotationCollection, id: chartSurface.yAxes.item(at: 0).axisId, isXAxis: false, axisValue: 32.7)
        buildAxisMarkerAnnotation(annotationCollection: annotationCollection, id: chartSurface.xAxes.item(at: 0).axisId, isXAxis: true, axisValue: 100)
        
        
        let horizontalLine = SCIHorizontalLineAnnotation()
        horizontalLine.coordinateMode = .absolute;
        horizontalLine.x1 = SCIGeneric(150);
        horizontalLine.y1 = SCIGeneric(32.2);
        horizontalLine.style.horizontalAlignment = .right;
        horizontalLine.style.linePen = SCISolidPenStyle.init(color: UIColor.red, withThickness: 2.0)
        annotationCollection.add(horizontalLine)
        
        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.coordinateMode = .absolute;
        horizontalLine1.x1 = SCIGeneric(130);
        horizontalLine1.y1 = SCIGeneric(32.2);
        horizontalLine1.style.horizontalAlignment = .right;
        horizontalLine1.style.linePen = SCISolidPenStyle.init(color: UIColor.blue, withThickness: 2.0)
        annotationCollection.add(horizontalLine1)
        
        
        let veticalLine = SCIVerticalLineAnnotation()
        veticalLine.coordinateMode = .absolute;
        veticalLine.x1 = SCIGeneric(20);
        veticalLine.y1 = SCIGeneric(35);
        veticalLine.style.linePen = SCISolidPenStyle.init(colorCode: 0xFF006400, withThickness: 2.0)
        annotationCollection.add(veticalLine)
        
        let veticalLine1 = SCIVerticalLineAnnotation()
        veticalLine1.coordinateMode = .absolute;
        veticalLine1.x1 = SCIGeneric(40);
        veticalLine1.y1 = SCIGeneric(34);
        veticalLine1.style.verticalAlignment = .top;
        veticalLine1.style.linePen = SCISolidPenStyle.init(color: UIColor.green, withThickness: 2.0)
        annotationCollection.add(veticalLine1)
        
        textStyle = SCITextFormattingStyle()
        textStyle.fontSize = 72
        buildTextAnnotation(annotationCollection: annotationCollection,x:0.5, y:0.5, horizontalAnchorPoint: .center, verticalAnchorPoint: .center, textStyle: textStyle, coordMode: .relative, text: "EUR/USD!",color: 0x77FFFFFF)
        
        chartSurface.annotationCollection = annotationCollection
    }
    
    private func buildTextAnnotation(annotationCollection:SCIAnnotationCollection, x:Double, y:Double, horizontalAnchorPoint:SCIHorizontalAnchorPoint, verticalAnchorPoint:SCIVerticalAnchorPoint, textStyle:SCITextFormattingStyle, coordMode:SCIAnnotationCoordinateMode, text:String, color:uint){
        
        let textAnnotation = SCITextAnnotation()
        textAnnotation.coordinateMode = coordMode;
        textAnnotation.x1 = SCIGeneric(x);
        textAnnotation.y1 = SCIGeneric(y);
        textAnnotation.horizontalAnchorPoint = horizontalAnchorPoint;
        textAnnotation.verticalAnchorPoint = verticalAnchorPoint;
        textAnnotation.text = text;
        textAnnotation.style.textStyle = textStyle;
        textAnnotation.style.textColor = UIColor.fromARGBColorCode(color);
        textAnnotation.style.backgroundColor = UIColor.clear
        
        annotationCollection.add(textAnnotation);
    }
    
    private func buildLineAnnotation(annotationCollection:SCIAnnotationCollection, x1:(Double), y1:(Double), x2:(Double), y2:(Double), color:(uint), strokeThickness:Double){
        
        let lineAnnotationRelative = SCILineAnnotation();
        lineAnnotationRelative.coordinateMode = .absolute;
        lineAnnotationRelative.x1 = SCIGeneric(x1);
        lineAnnotationRelative.y1 = SCIGeneric(y1);
        lineAnnotationRelative.x2 = SCIGeneric(x2);
        lineAnnotationRelative.y2 = SCIGeneric(y2);
        lineAnnotationRelative.style.linePen = SCISolidPenStyle.init(colorCode:color, withThickness:Float(strokeThickness));
        
        annotationCollection.add(lineAnnotationRelative);
    }
    
    private func buildBoxAnnotation(annotationCollection:SCIAnnotationCollection, x1:Double, y1:Double, x2:Double, y2:Double, brush:SCIBrushStyle, pen:SCISolidPenStyle){
        
        let boxAnnotation = SCIBoxAnnotation()
        boxAnnotation.coordinateMode = .absolute;
        boxAnnotation.x1 = SCIGeneric(x1);
        boxAnnotation.y1 = SCIGeneric(y1);
        boxAnnotation.x2 = SCIGeneric(x2);
        boxAnnotation.y2 = SCIGeneric(y2);
        boxAnnotation.style.fillBrush = brush;
        boxAnnotation.style.borderPen = pen;
        
        annotationCollection.add(boxAnnotation);
    }
    
    private func buildAxisMarkerAnnotation(annotationCollection:SCIAnnotationCollection,id :String,isXAxis:(Bool), axisValue:Double){
        let axisMarker = SCIAxisMarkerAnnotation ()
        axisMarker.coordinateMode = .absolute;
        axisMarker.position = SCIGeneric(axisValue);
        
        if(isXAxis){
            axisMarker.xAxisId = id;
        }else{
            axisMarker.yAxisId = id;
        }
        
        annotationCollection.add(axisMarker)
    }
    
}
