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
        chartSurface.invalidateElement()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxis() {
        chartSurface.xAxes.add(SCINumericAxis())
        chartSurface.yAxes.add(SCINumericAxis())
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
        
        let groupModifier = SCIModifierGroup(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, zoomPanModifier])
        
        chartSurface.chartModifier = groupModifier
    }
    
     fileprivate func setupAnnotations() {
        // Box bound to chart surface
        let boxBlue = SCIBoxAnnotation()
        boxBlue.coordinateMode = .absolute
        boxBlue.x1 = SCIGeneric(4)
        boxBlue.y1 = SCIGeneric(8)
        boxBlue.x2 = SCIGeneric(7)
        boxBlue.y2 = SCIGeneric(4)
        boxBlue.isEnabled = false
        boxBlue.style.fillBrush = SCISolidBrushStyle(colorCode: 0x300070FF)
        
        // Box bound to screen position
        let boxRed = SCIBoxAnnotation()
        boxRed.coordinateMode = .relative
        boxRed.x1 = SCIGeneric(0.25)
        boxRed.y1 = SCIGeneric(0.25)
        boxRed.x2 = SCIGeneric(0.5)
        boxRed.y2 = SCIGeneric(0.5)
        boxRed.isEnabled = false
        boxRed.style.fillBrush = SCISolidBrushStyle(colorCode: 0x30FF1010)
        boxRed.style.borderPen = SCISolidPenStyle(colorCode: 0xFF0000FF, withThickness:2)
        // line bound to position on screen
        let lineAnnotationRelative = SCILineAnnotation()
        lineAnnotationRelative.coordinateMode = .relative
        lineAnnotationRelative.x1 = SCIGeneric(0.1)
        lineAnnotationRelative.y1 = SCIGeneric(0.1)
        lineAnnotationRelative.x2 = SCIGeneric(0.9)
        lineAnnotationRelative.y2 = SCIGeneric(0.1)
        lineAnnotationRelative.style.linePen = SCISolidPenStyle(colorCode: 0xFFFF0000, withThickness: 2)
        
        // line bound to position on chart
        let lineAnnotationAbsolute = SCILineAnnotation()
        lineAnnotationAbsolute.coordinateMode = .absolute
        lineAnnotationAbsolute.x1 = SCIGeneric(2)
        lineAnnotationAbsolute.y1 = SCIGeneric(2)
        lineAnnotationAbsolute.x2 = SCIGeneric(5)
        lineAnnotationAbsolute.y2 = SCIGeneric(6)
        lineAnnotationAbsolute.style.linePen = SCISolidPenStyle(colorCode: 0xFF00FF00, withThickness: 2)
        
        // line with X position bound to chart and Y to screen
        let lineAnnotationAbsoluteX = SCILineAnnotation()
        lineAnnotationAbsoluteX.coordinateMode = .relativeY
        lineAnnotationAbsoluteX.x1 = SCIGeneric(1)
        lineAnnotationAbsoluteX.y1 = SCIGeneric(0.05)
        lineAnnotationAbsoluteX.x2 = SCIGeneric(1)
        lineAnnotationAbsoluteX.y2 = SCIGeneric(0.95)
        lineAnnotationAbsoluteX.style.linePen = SCISolidPenStyle(colorCode: 0xFFFF0000, withThickness: 2)
        
        // axis marker bound to chart surface
        let xMarker = SCIAxisMarkerAnnotation()
        xMarker.coordinateMode = .absolute
        xMarker.position = SCIGeneric(2.5)
        xMarker.style.markerLinePen = SCISolidPenStyle(colorCode: 0xAF00FFFF, withThickness: 1)
        xMarker.style.backgroundColor = UIColor.fromABGRColorCode(0xFF30CFCF)
        xMarker.style.textStyle.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI_2))
        
        // axis marker bound to screen
        let yMarker = SCIAxisMarkerAnnotation()
        yMarker.coordinateMode = .relative
        yMarker.position = SCIGeneric(0.5)
        yMarker.style.markerLinePen = SCISolidPenStyle(colorCode: 0xA0FF0000, withThickness: 1)
        yMarker.style.backgroundColor = UIColor.fromABGRColorCode(0xFFA00000)
        yMarker.style.textStyle.fontSize = 14
        yMarker.style.textStyle.fontName = "Helvetica-Bold"
        yMarker.style.textStyle.color = UIColor.white
        // axis marker annotation text is formated by axis as cursor text
        chartSurface.yAxes.item(at: 0).cursorTextFormatting = "%.2f"
        
        // text annotation
        let textAnnotation = SCITextAnnotation()
        textAnnotation.coordinateMode = .relative
        textAnnotation.x1 = SCIGeneric(0.7)
        textAnnotation.y1 = SCIGeneric(0.5)
        
        textAnnotation.text = "Red box: position bound to screen\n" +
            "Blue box: position bound to chart surface\n" +
            "Red line: bound to screen\n" +
            "Green line: bound to surface\n" +
            "Blue line: X bound to chart, Y bound to screen\n" +
        "All annotations but axis markers are interactive"
        textAnnotation.style.textStyle.fontSize = 18
        textAnnotation.style.textColor = UIColor.white
        textAnnotation.style.backgroundColor = UIColor.clear
        
        let annotationGroup = SCIAnnotationCollection(childAnnotations: [boxBlue, boxRed, lineAnnotationRelative, lineAnnotationAbsolute, lineAnnotationAbsoluteX, textAnnotation, xMarker, yMarker])
        
        chartSurface.annotation = annotationGroup
    }
    
    
}
