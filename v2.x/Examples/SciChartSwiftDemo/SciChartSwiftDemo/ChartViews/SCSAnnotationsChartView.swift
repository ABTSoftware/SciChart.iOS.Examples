//
//  SCSAnnotationsView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSAnnotationsChartView: UIView {
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
        setupAnnotations()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        surface.xAxes.add(SCINumericAxis())
        surface.yAxes.add(SCINumericAxis())
    }
    
    func addDefaultModifiers() {
        
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
        
        surface.chartModifiers = groupModifier
    }
    
    fileprivate func setupAnnotations() {
        let annotationGroup = SCIAnnotationCollection()
        
        // Watermark
        var textStyle = SCITextFormattingStyle()
        textStyle.fontSize=42
        buildTextAnnotation(annotations: annotationGroup,x: 0.5,y: 0.5,horizontalAnchorPoint: .center,verticalAnchorPoint: .center,textStyle: textStyle,coordMode: .relative,text: "Create \n Watermarks",color: 0x22FFFFFF)
        
        // Text annotations
        textStyle = SCITextFormattingStyle()
        textStyle.fontSize=24
        buildTextAnnotation(annotations: annotationGroup,x: 0.3,y: 9.7,horizontalAnchorPoint: .left,verticalAnchorPoint: .top,textStyle: textStyle,coordMode: .absolute,text: "Annotations are Easy!",color: 0xFFFFFFFF)
        
        textStyle = SCITextFormattingStyle()
        textStyle.fontSize=10
        buildTextAnnotation(annotations: annotationGroup,x: 1.0,y: 9.0,horizontalAnchorPoint: .left,verticalAnchorPoint: .top,textStyle: textStyle,coordMode: .absolute,text: "You can create text",color: 0xFFFFFFFF)
        
        buildTextAnnotation(annotations: annotationGroup,x: 5.0,y: 8.0,horizontalAnchorPoint: .center,verticalAnchorPoint: .bottom,textStyle: textStyle,coordMode: .absolute,text: "Anchor Center",color: 0xFFFFFFFF)
        buildTextAnnotation(annotations: annotationGroup,x: 5.0,y: 8.0,horizontalAnchorPoint: .right,verticalAnchorPoint: .top,textStyle: textStyle,coordMode: .absolute,text: "Anchor Left",color: 0xFFFFFFFF)
        buildTextAnnotation(annotations: annotationGroup,x: 5.0,y: 8.0,horizontalAnchorPoint: .left,verticalAnchorPoint: .top,textStyle: textStyle,coordMode: .absolute,text: "or anchor Right",color: 0xFFFFFFFF)
        
        // Line and line arrow annotations
        
        textStyle = SCITextFormattingStyle()
        textStyle.fontSize=12
        buildTextAnnotation(annotations: annotationGroup,
                            x: 0.3, y: 6.1,
                            horizontalAnchorPoint: .left,
                            verticalAnchorPoint: .bottom,
                            textStyle: textStyle,
                            coordMode: .absolute,
                            text: "Draw Lines \nAnnotations",
                            color: 0xFFFFFFFF)
        
        buildLineAnnotation(annotations: annotationGroup,
                            x1: 1.0, y1: 4.0,
                            x2: 2.0, y2: 6.0,
                            color: 0xFF555555,
                            strokeThickness: 2.0)
        
        // Box annotations
        buildTextAnnotation(annotations: annotationGroup,
                            x: 3.5,y: 6.1,
                            horizontalAnchorPoint: .left,
                            verticalAnchorPoint: .bottom,
                            textStyle: textStyle,
                            coordMode: .absolute,
                            text: "Draw Boxes", color: 0xFFFFFFFF)
        
        buildBoxAnnotation(annotations: annotationGroup,
                           x1: 3.5, y1: 4.0,
                           x2: 5.0, y2: 5.0,
                           brush: SCILinearGradientBrushStyle.init(colorStart: UIColor.fromARGBColorCode(0x550000FF), finish: UIColor.fromARGBColorCode(0x55FFFF00), direction: .vertical),
                           pen: SCISolidPenStyle.init(color: UIColor.fromARGBColorCode(0xFF279B27), withThickness: 1.0))
        
        buildBoxAnnotation(annotations: annotationGroup,
                           x1: 4.0, y1: 4.5,
                           x2: 5.5, y2: 5.5,
                           brush: SCISolidBrushStyle.init(color: UIColor.fromARGBColorCode(0x55FF1919)),
                           pen: SCISolidPenStyle.init(color: UIColor.fromARGBColorCode(0xFFFF1919), withThickness: 1.0))
        
        buildBoxAnnotation(annotations: annotationGroup,
                           x1: 4.5, y1: 5.0,
                           x2: 6.0, y2: 6.0,
                           brush: SCISolidBrushStyle.init(color: UIColor.fromARGBColorCode(0x55279B27)),
                           pen: SCISolidPenStyle.init(color: UIColor.fromARGBColorCode(0xFF279B27), withThickness: 1.0))
        
        // Custom shapes
        buildTextAnnotation(annotations: annotationGroup,
                            x: 7.0,y: 6.1,
                            horizontalAnchorPoint: .left,
                            verticalAnchorPoint: .bottom,
                            textStyle: textStyle, coordMode: .absolute,
                            text: "Or Custom Shapes",color: 0xFFFFFFFF)
        
        let customAnnotationGreen = SCICustomAnnotation()
        customAnnotationGreen.customView = UIImageView.init(image: UIImage.init(named: "GreenArrow"))
        customAnnotationGreen.x1=SCIGeneric(8)
        customAnnotationGreen.y1=SCIGeneric(5.5)
        annotationGroup.add(customAnnotationGreen)
        
        let customAnnotationRed = SCICustomAnnotation()
        customAnnotationRed.customView = UIImageView.init(image: UIImage.init(named: "RedArrow"))
        customAnnotationRed.x1=SCIGeneric(7.5)
        customAnnotationRed.y1=SCIGeneric(5.0)
        annotationGroup.add(customAnnotationRed)
        
        // Horizontal Line Annotations
        let horizontalLine = SCIHorizontalLineAnnotation()
        horizontalLine.coordinateMode = .absolute;
        horizontalLine.x1 = SCIGeneric(5.0);
        horizontalLine.y1 = SCIGeneric(3.2);
        horizontalLine.horizontalAlignment = .right
        horizontalLine.style.linePen = SCISolidPenStyle.init(color: UIColor.orange, withThickness:2)
        horizontalLine.add(self.buildLineTextLabel("Right Aligned, with text on left", alignment: .topLeft, backColor: UIColor.clear, textColor: UIColor.orange))
        annotationGroup.add(horizontalLine)
        
        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.coordinateMode = .absolute;
        horizontalLine1.y1 = SCIGeneric(2.8);
        horizontalLine1.horizontalAlignment = .stretch
        horizontalLine1.add(self.buildLineTextLabel("", alignment: .axis, backColor: UIColor.orange, textColor: UIColor.white))
        horizontalLine1.style.linePen = SCISolidPenStyle.init(color: UIColor.orange, withThickness:2)
        annotationGroup.add(horizontalLine1)
        
        // Vertical Line annotations
        let verticalLine = SCIVerticalLineAnnotation()
        verticalLine.coordinateMode = .absolute;
        verticalLine.x1 = SCIGeneric(9.0);
        verticalLine.y1 = SCIGeneric(4.0);
        verticalLine.verticalAlignment = .bottom
        verticalLine.add(self.buildLineTextLabel("", alignment: .axis, backColor: UIColor.fromARGBColorCode(0xFFA52A2A), textColor: UIColor.white))
        verticalLine.style.linePen = SCISolidPenStyle.init(colorCode: 0xFFA52A2A, withThickness:2)
        annotationGroup.add(verticalLine)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now()+5.0) {
            let verticalLine1 = SCIVerticalLineAnnotation()
            verticalLine1.coordinateMode = .absolute;
            verticalLine1.x1 = SCIGeneric(9.5);
            verticalLine1.y1 = SCIGeneric(3.0);
            verticalLine.verticalAlignment = .bottom
            //        verticalLine1.style.linePen = SCISolidPenStyle.init(colorCode: 0xFFA52A2A, withThickness:2)
            verticalLine1.style.linePen = SCISolidPenStyle.init(colorCode: 0xFFA52A2A, withThickness: 2, andStrokeDash: [20, 10])
            verticalLine1.add(self.buildLineTextLabel("", alignment: .axis, backColor: UIColor.fromARGBColorCode(0xFFA52A2A), textColor: UIColor.white))
            annotationGroup.add(verticalLine1)
        }

        
        surface.annotations = annotationGroup
    }
    
    private func buildLineTextLabel(_ text: String, alignment: SCILabelPlacement, backColor: UIColor, textColor: UIColor) -> SCILineAnnotationLabel {
        let lineText = SCILineAnnotationLabel()
        lineText.text = text
        lineText.style.labelPlacement = alignment
        lineText.style.backgroundColor = backColor
        lineText.style.textStyle.color = textColor
        return lineText
    }
    
    private func buildTextAnnotation(annotations:SCIAnnotationCollection, x:Double, y:Double, horizontalAnchorPoint:SCIHorizontalAnchorPoint, verticalAnchorPoint:SCIVerticalAnchorPoint, textStyle:SCITextFormattingStyle, coordMode:SCIAnnotationCoordinateMode, text:String, color:uint){
        
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
        
        annotations.add(textAnnotation);
    }
    
    private func buildLineAnnotation(annotations:SCIAnnotationCollection, x1:(Double), y1:(Double), x2:(Double), y2:(Double), color:(uint), strokeThickness:Double){
        
        let lineAnnotationRelative = SCILineAnnotation();
        lineAnnotationRelative.coordinateMode = .absolute;
        lineAnnotationRelative.x1 = SCIGeneric(x1);
        lineAnnotationRelative.y1 = SCIGeneric(y1);
        lineAnnotationRelative.x2 = SCIGeneric(x2);
        lineAnnotationRelative.y2 = SCIGeneric(y2);
        lineAnnotationRelative.style.linePen = SCISolidPenStyle.init(colorCode:color, withThickness:Float(strokeThickness));
        
        annotations.add(lineAnnotationRelative);
    }
    
    private func buildBoxAnnotation(annotations:SCIAnnotationCollection, x1:Double, y1:Double, x2:Double, y2:Double, brush:SCIBrushStyle, pen:SCISolidPenStyle){
        
        let boxAnnotation = SCIBoxAnnotation()
        boxAnnotation.coordinateMode = .absolute;
        boxAnnotation.x1 = SCIGeneric(x1);
        boxAnnotation.y1 = SCIGeneric(y1);
        boxAnnotation.x2 = SCIGeneric(x2);
        boxAnnotation.y2 = SCIGeneric(y2);
        boxAnnotation.style.fillBrush = brush;
        boxAnnotation.style.borderPen = pen;
        
        annotations.add(boxAnnotation);
    }
    
}
