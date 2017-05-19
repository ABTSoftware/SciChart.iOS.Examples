//
//  SCSAnnotationsView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSAnnotationsChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        setupAnnotations()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        xAxes.add(SCINumericAxis())
        yAxes.add(SCINumericAxis())
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
        
        chartModifiers = groupModifier
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
        buildTextAnnotation(annotations: annotationGroup,x: 5.0,y: 8.0,horizontalAnchorPoint: .right,verticalAnchorPoint: .top,textStyle: textStyle,coordMode: .absolute,text: "Anchor Right",color: 0xFFFFFFFF)
        buildTextAnnotation(annotations: annotationGroup,x: 5.0,y: 8.0,horizontalAnchorPoint: .left,verticalAnchorPoint: .top,textStyle: textStyle,coordMode: .absolute,text: "or anchor Left",color: 0xFFFFFFFF)
        
        // Line and line arrow annotations
        
        textStyle = SCITextFormattingStyle()
        textStyle.fontSize=12
        buildTextAnnotation(annotations: annotationGroup,x: 0.3,y: 6.1,horizontalAnchorPoint: .left,verticalAnchorPoint: .bottom,textStyle: textStyle,coordMode: .absolute,text: "Draw Lines \nAnnotations",color: 0xFFFFFFFF)
        buildLineAnnotation(annotations: annotationGroup, x1: 1.0, y1: 4.0, x2: 2.0, y2: 6.0, color: 0xFF555555, strokeThickness: 2.0)
        
        // Box annotations
        buildTextAnnotation(annotations: annotationGroup,x: 3.5,y: 6.1, horizontalAnchorPoint: .left,verticalAnchorPoint: .bottom,textStyle: textStyle,coordMode: .absolute,text: "Draw Boxes",color: 0xFFFFFFFF)

        buildBoxAnnotation(annotations: annotationGroup, x1: 3.5, y1: 4.0, x2: 5.0, y2: 5.0, brush: SCILinearGradientBrushStyle.init(colorStart: UIColor.fromARGBColorCode(0x550000FF), finish: UIColor.fromARGBColorCode(0x55FFFF00), direction: .vertical), pen: SCISolidPenStyle.init(color: UIColor.fromARGBColorCode(0xFF279B27), withThickness: 1.0))
        
        buildBoxAnnotation(annotations: annotationGroup, x1: 4.0, y1: 4.5, x2: 5.5, y2: 5.5, brush: SCISolidBrushStyle.init(color: UIColor.fromARGBColorCode(0x55FF1919)), pen: SCISolidPenStyle.init(color: UIColor.fromARGBColorCode(0xFFFF1919), withThickness: 1.0))
        
        buildBoxAnnotation(annotations: annotationGroup, x1: 4.5, y1: 5.0, x2: 6.0, y2: 6.0, brush: SCISolidBrushStyle.init(color: UIColor.fromARGBColorCode(0x55279B27)), pen: SCISolidPenStyle.init(color:
            UIColor.fromARGBColorCode(0xFF279B27), withThickness: 1.0))
        
        // Custom shapes
        buildTextAnnotation(annotations: annotationGroup,x: 7.0,y: 6.1, horizontalAnchorPoint: .left,verticalAnchorPoint: .bottom,textStyle: textStyle,coordMode: .absolute,text: "Or Custom Shapes",color: 0xFFFFFFFF)
        
        let customAnnotationGreen = SCICustomAnnotation()
        customAnnotationGreen.contentView = UIImageView.init(image: UIImage.init(named: "GreenArrow"))
        customAnnotationGreen.x1=SCIGeneric(8)
        customAnnotationGreen.y1=SCIGeneric(5.5)
        
        let customAnnotationRed = SCICustomAnnotation()
        customAnnotationRed.contentView = UIImageView.init(image: UIImage.init(named: "RedArrow"))
        customAnnotationRed.x1=SCIGeneric(7.5)
        customAnnotationRed.y1=SCIGeneric(5.0)
        
        annotationGroup.add(customAnnotationGreen)
        annotationGroup.add(customAnnotationRed)
        
        
        // Horizontal Line Annotations
        let horizontalLine = SCIHorizontalLineAnnotation()
        horizontalLine.coordinateMode = .absolute;
        horizontalLine.x1 = SCIGeneric(5.0);
        horizontalLine.y1 = SCIGeneric(3.2);
        horizontalLine.style.horizontalAlignment = .right
        horizontalLine.style.linePen = SCISolidPenStyle.init(color: UIColor.orange, withThickness:2)
        
        let lineText = SCILineAnnotationLabel()
        lineText.textAlignment = .right;
        lineText.text = "Right Aligned, with text on left"
        lineText.style.labelPlacement = .topRight
        horizontalLine.add(lineText)
        annotationGroup.add(horizontalLine)
        
        let horizontalLine1 = SCIHorizontalLineAnnotation()
        horizontalLine1.coordinateMode = .absolute;
        horizontalLine1.x1 = SCIGeneric(7.0);
        horizontalLine1.y1 = SCIGeneric(2.8);
        horizontalLine1.style.linePen = SCISolidPenStyle.init(color: UIColor.orange, withThickness:2)
        annotationGroup.add(horizontalLine1)
        
        // Vertical Line annotations
        let verticalLine = SCIVerticalLineAnnotation()
        verticalLine.coordinateMode = .absolute;
        verticalLine.x1 = SCIGeneric(9.0);
        verticalLine.y1 = SCIGeneric(4.0);
        verticalLine.style.verticalAlignment = .bottom
        verticalLine.style.linePen = SCISolidPenStyle.init(colorCode: 0xFFA52A2A, withThickness:2)
        annotationGroup.add(verticalLine)
        
        let verticalLine1 = SCIVerticalLineAnnotation()
        verticalLine1.coordinateMode = .absolute;
        verticalLine1.x1 = SCIGeneric(9.5);
        verticalLine1.y1 = SCIGeneric(3.0);
        verticalLine1.style.linePen = SCISolidPenStyle.init(colorCode: 0xFFA52A2A, withThickness:2)
        annotationGroup.add(verticalLine1)

        annotations = annotationGroup
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
