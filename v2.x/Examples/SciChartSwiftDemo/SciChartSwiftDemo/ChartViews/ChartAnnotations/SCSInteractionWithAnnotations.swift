//
//  SCSInteractionWithAnnotations.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 03/05/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSInteractionWithAnnotations: UIView {
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
        addSeries()
        setupAnnotations()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        let xAxis = SCICategoryNumericAxis()
        xAxis.axisId = "xaxis"
        surface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.axisId = "yaxis"
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(30), max: SCIGeneric(37))
        yAxis.growBy = SCIDoubleRange.init(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        surface.yAxes.add(yAxis)
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.axisId = "xAxis"
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.axisId = "yAxis"
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let zoomPanModifier = SCIZoomPanModifier()
        zoomPanModifier.clipModeX = .none;
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, zoomPanModifier])
        
        surface.chartModifiers = groupModifier
    }
    
    private func addSeries(){
        let marketManager = SCSMarketDataService.init(start: Date.init(), timeFrameMinutes: 5, tickTimerIntervals: 5)
        let data:[SCSMultiPaneItem] = marketManager.getHistoricalData(200)
        
        let dataSeries = SCIOhlcDataSeries.init(xType: .double, yType: .double)
        for i in 0..<data.count {
            dataSeries.appendX(SCIGeneric(i), open: SCIGeneric(data[i].open), high: SCIGeneric(data[i].high), low: SCIGeneric(data[i].low), close: SCIGeneric(data[i].close))
        }
        
        let candles = SCIFastCandlestickRenderableSeries()
        candles.dataSeries = dataSeries
        candles.xAxisId = "xaxis"
        candles.yAxisId = "yaxis"
        candles.style.fillUpBrushStyle = SCISolidBrushStyle.init(colorCode: 0x7052CC54)
        candles.style.fillDownBrushStyle = SCISolidBrushStyle.init(colorCode: 0x70E26565)
        candles.style.strokeUpStyle = SCISolidPenStyle.init(colorCode: 0xFF52CC54, withThickness: 1)
        candles.style.strokeDownStyle = SCISolidPenStyle.init(colorCode: 0xFFE26565, withThickness: 1)
        surface.renderableSeries.add(candles)
    }
    
    fileprivate func setupAnnotations() {
        
        var textStyle = SCITextFormattingStyle()
        textStyle.fontSize = 20
        
        buildTextAnnotation(x:10, y:30.5,
                            horizontalAnchorPoint: .left,
                            verticalAnchorPoint: .bottom,
                            textStyle: textStyle,
                            coordMode: .absolute,
                            text: "Buy!",color: 0xFFFFFFFF)
        
        buildTextAnnotation(x:50, y:34,
                            horizontalAnchorPoint: .left,
                            verticalAnchorPoint: .top,
                            textStyle: textStyle,
                            coordMode: .absolute,
                            text: "Sell!",color: 0xFFFFFFFF)
        
        buildRotatedTextAnnotation(x:80, y:37,
                            horizontalAnchorPoint: .left,
                            verticalAnchorPoint: .top,
                            textStyle: textStyle,
                            coordMode: .absolute,
                            text: "Rotated Text!",color: 0xFFFFFFFF, setupBlock: {view in
                                view?.isUserInteractionEnabled = true
                                view?.layer.transform = CATransform3DMakeRotation (CGFloat(30 * Double.pi / 180), 0, 0, 1);
                                view?.frame = CGRect.init(x:view!.frame.origin.x, y:view!.frame.origin.y, width:50,height: 100);  })
        
        buildBoxAnnotation(x1: 50, y1: 35.5,
                           x2: 120, y2: 32,
                           brush: SCISolidBrushStyle.init(colorCode: 0x33FF6600),
                           pen: SCISolidPenStyle.init(colorCode: 0x77FF6600, withThickness: 1.0))
        
        buildLineAnnotation(x1: 40, y1: 30.5,
                            x2: 60, y2: 33.5,
                            color: 0xAAFF6600, strokeThickness: 2.0)
        
        buildLineAnnotation(x1: 120, y1: 30.5,
                            x2: 175, y2: 36,
                            color: 0xAAFF6600,
                            strokeThickness: 2.0)
        
        
        buildAxisMarkerAnnotation(id: surface.yAxes.item(at: 0).axisId, isXAxis: false, axisValue: 32.7)
        
        buildAxisMarkerAnnotation(id: surface.xAxes.item(at: 0).axisId, isXAxis: true, axisValue: 100)
        
        
        let horizontalLine = SCIHorizontalLineAnnotation()
        horizontalLine.coordinateMode = .absolute;
        horizontalLine.xAxisId = "xaxis"
        horizontalLine.yAxisId = "yaxis"
        horizontalLine.x1 = SCIGeneric(150)
        horizontalLine.y1 = SCIGeneric(32.2)
        horizontalLine.isEditable = true
        horizontalLine.horizontalAlignment = .right
        horizontalLine.style.linePen = SCISolidPenStyle.init(color: UIColor.red, withThickness: 2.0)
        horizontalLine.add(self.buildLineTextLabel("", alignment: .axis, backColor: UIColor.red, textColor: UIColor.white))
        surface.annotations.add(horizontalLine)
        
        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.coordinateMode = .absolute;
        horizontalLine1.xAxisId = "xaxis"
        horizontalLine1.yAxisId = "yaxis"
        horizontalLine1.x1 = SCIGeneric(130)
        horizontalLine1.x2 = SCIGeneric(160)
        horizontalLine1.y1 = SCIGeneric(33.9)
        horizontalLine1.horizontalAlignment = .center
        horizontalLine1.isEditable = true
        horizontalLine1.style.linePen = SCISolidPenStyle.init(color: UIColor.blue, withThickness: 2.0)
        horizontalLine1.add(self.buildLineTextLabel("Top", alignment: .top, backColor: UIColor.clear, textColor: UIColor.blue))
        horizontalLine1.add(self.buildLineTextLabel("Left", alignment: .left, backColor: UIColor.clear, textColor: UIColor.blue))
        horizontalLine1.add(self.buildLineTextLabel("Right", alignment: .right, backColor: UIColor.clear, textColor: UIColor.blue))
        horizontalLine1.add(self.buildLineTextLabel("Bottom", alignment: .bottom, backColor: UIColor.clear, textColor: UIColor.blue))
        surface.annotations.add(horizontalLine1)
        
        let verticalLine = SCIVerticalLineAnnotation()
        verticalLine.coordinateMode = .absolute;
        verticalLine.xAxisId = "xaxis"
        verticalLine.yAxisId = "yaxis"
        verticalLine.x1 = SCIGeneric(30);
        verticalLine.y1 = SCIGeneric(33);
        verticalLine.y2 = SCIGeneric(35);
        verticalLine.verticalAlignment = .center
        verticalLine.isEditable = true
        verticalLine.style.linePen = SCISolidPenStyle.init(colorCode: 0xFF006400, withThickness: 2.0)
        surface.annotations.add(verticalLine)
        
        let verticalLine1 = SCIVerticalLineAnnotation()
        verticalLine1.coordinateMode = .absolute;
        verticalLine1.xAxisId = "xaxis"
        verticalLine1.yAxisId = "yaxis"
        verticalLine1.x1 = SCIGeneric(40)
        verticalLine1.y1 = SCIGeneric(34)
        verticalLine1.verticalAlignment = .top
        verticalLine1.isEditable = true
        verticalLine1.style.linePen = SCISolidPenStyle.init(colorCode: 0xFF006400, withThickness: 2.0)
        verticalLine1.add(self.buildLineTextLabel("40", alignment: .top, backColor: UIColor.clear, textColor: UIColor.fromARGBColorCode(0xFF006400)))
        surface.annotations.add(verticalLine1)
        
        textStyle = SCITextFormattingStyle()
        textStyle.fontSize = 72
        buildTextAnnotation(x:0.5, y:0.5,
                            horizontalAnchorPoint: .left,
                            verticalAnchorPoint: .top,
                            textStyle: textStyle,
                            coordMode: .relative,
                            text: "EUR/USD",color: 0x77FFFFFF)
        
    }
    
    private func buildLineTextLabel(_ text: String, alignment: SCILabelPlacement, backColor: UIColor, textColor: UIColor) -> SCILineAnnotationLabel {
        let lineText = SCILineAnnotationLabel()
        lineText.text = text
        lineText.style.labelPlacement = alignment
        lineText.style.backgroundColor = backColor
        lineText.style.textStyle.color = textColor

        return lineText
    }
    
    private func buildTextAnnotation(x:Double, y:Double, horizontalAnchorPoint:SCIHorizontalAnchorPoint, verticalAnchorPoint:SCIVerticalAnchorPoint, textStyle:SCITextFormattingStyle, coordMode:SCIAnnotationCoordinateMode, text:String, color:uint){
        
        let textAnnotation = SCITextAnnotation()
        textAnnotation.coordinateMode = coordMode;
        textAnnotation.xAxisId = "xaxis"
        textAnnotation.yAxisId = "yaxis"
        textAnnotation.x1 = SCIGeneric(x);
        textAnnotation.y1 = SCIGeneric(y);
        textAnnotation.horizontalAnchorPoint = horizontalAnchorPoint;
        textAnnotation.verticalAnchorPoint = verticalAnchorPoint;
        textAnnotation.text = text;
        textAnnotation.style.textStyle = textStyle;
        textAnnotation.style.textColor = UIColor.fromARGBColorCode(color);
        textAnnotation.style.backgroundColor = UIColor.clear
        textAnnotation.isEditable = true
        surface.annotations.add(textAnnotation);
    }
    
    private func buildRotatedTextAnnotation(x:Double, y:Double, horizontalAnchorPoint:SCIHorizontalAnchorPoint, verticalAnchorPoint:SCIVerticalAnchorPoint, textStyle:SCITextFormattingStyle, coordMode:SCIAnnotationCoordinateMode, text:String, color:uint, setupBlock: @escaping (SCITextAnnotationViewSetupBlock)){
        
        let textAnnotation = SCITextAnnotation()
        textAnnotation.coordinateMode = coordMode;
        textAnnotation.xAxisId = "xaxis"
        textAnnotation.yAxisId = "yaxis"
        textAnnotation.x1 = SCIGeneric(x);
        textAnnotation.y1 = SCIGeneric(y);
        textAnnotation.horizontalAnchorPoint = horizontalAnchorPoint;
        textAnnotation.verticalAnchorPoint = verticalAnchorPoint;
        textAnnotation.text = text;
        textAnnotation.style.textStyle = textStyle;
        textAnnotation.style.textColor = UIColor.fromARGBColorCode(color);
        textAnnotation.style.backgroundColor = UIColor.clear
        textAnnotation.style.viewSetup = setupBlock
        textAnnotation.isEditable = true
        surface.annotations.add(textAnnotation);
    }
    
    private func buildLineAnnotation(x1:(Double), y1:(Double), x2:(Double), y2:(Double), color:(uint), strokeThickness:Double){
        
        let lineAnnotationRelative = SCILineAnnotation();
        lineAnnotationRelative.coordinateMode = .absolute;
        lineAnnotationRelative.xAxisId = "xaxis"
        lineAnnotationRelative.yAxisId = "yaxis"
        lineAnnotationRelative.x1 = SCIGeneric(x1);
        lineAnnotationRelative.y1 = SCIGeneric(y1);
        lineAnnotationRelative.x2 = SCIGeneric(x2);
        lineAnnotationRelative.y2 = SCIGeneric(y2);
        lineAnnotationRelative.style.linePen = SCISolidPenStyle.init(colorCode:color, withThickness:Float(strokeThickness));
        
        surface.annotations.add(lineAnnotationRelative);
    }
    
    private func buildBoxAnnotation(x1:Double, y1:Double, x2:Double, y2:Double, brush:SCIBrushStyle, pen:SCISolidPenStyle){
        
        let boxAnnotation = SCIBoxAnnotation()
        boxAnnotation.coordinateMode = .absolute;
        boxAnnotation.xAxisId = "xaxis"
        boxAnnotation.yAxisId = "yaxis"
        boxAnnotation.x1 = SCIGeneric(x1);
        boxAnnotation.y1 = SCIGeneric(y1);
        boxAnnotation.x2 = SCIGeneric(x2);
        boxAnnotation.y2 = SCIGeneric(y2);
        boxAnnotation.style.fillBrush = brush;
        boxAnnotation.style.borderPen = pen;
        boxAnnotation.isEditable = true
        surface.annotations.add(boxAnnotation);
    }
    
    private func buildAxisMarkerAnnotation(id :String,isXAxis:(Bool), axisValue:Double){
        let axisMarker = SCIAxisMarkerAnnotation ()
        axisMarker.coordinateMode = .absolute;
        axisMarker.position = SCIGeneric(axisValue);
        axisMarker.isEditable = true
        if(isXAxis){
            axisMarker.xAxisId = id;
            axisMarker.style.annotationSurface = .xAxis
        }else{
            axisMarker.yAxisId = id;
            axisMarker.style.annotationSurface = .yAxis
        }
        surface.annotations.add(axisMarker)
    }
}
