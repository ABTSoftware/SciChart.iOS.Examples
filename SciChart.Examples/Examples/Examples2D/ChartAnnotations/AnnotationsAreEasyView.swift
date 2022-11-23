//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AnnotationsAreEasyView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class AnnotationsAreEasyView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            
            // Watermark
            let watermark = SCITextAnnotation()
            watermark.set(x1: 0.5)
            watermark.set(y1: 0.5)
            watermark.coordinateMode = .relative
            watermark.horizontalAnchorPoint = .center
            watermark.verticalAnchorPoint = .center
            watermark.text = "Create \nWatermarks"
            watermark.fontStyle = SCIFontStyle(fontSize: 42, andTextColorCode:0x55FFFFFF)
            
            // Text annotations
            let textAnnotation1 = SCITextAnnotation()
            textAnnotation1.set(x1: 0.3)
            textAnnotation1.set(y1: 9.7)
            textAnnotation1.text = "Annotations are Easy!"
            textAnnotation1.fontStyle = SCIFontStyle(fontSize: 22, andTextColor: .white)
            
            let textAnnotation2 = SCITextAnnotation()
            textAnnotation2.set(x1: 1.0)
            textAnnotation2.set(y1: 9.0)
            textAnnotation2.text = "You can create text"
            textAnnotation2.fontStyle = SCIFontStyle(fontSize: 12, andTextColor: .white)
            
            let editableTextAnnotation = SCITextAnnotation()
            editableTextAnnotation.set(x1: 1.0)
            editableTextAnnotation.set(y1: 8.8)
            editableTextAnnotation.canEditText = true
            editableTextAnnotation.text = "And even edit it ... (tap me)"
            editableTextAnnotation.fontStyle = SCIFontStyle(fontSize: 12, andTextColor: .white)
            
            // Text with Anchor Points
            let textAnnotation3 = SCITextAnnotation()
            textAnnotation3.set(x1: 5.0)
            textAnnotation3.set(y1: 8.0)
            textAnnotation3.horizontalAnchorPoint = .center
            textAnnotation3.verticalAnchorPoint = .bottom
            textAnnotation3.text = "Anchor Center (x1, y1)"
            
            let textAnnotation4 = SCITextAnnotation()
            textAnnotation4.set(x1: 5.0)
            textAnnotation4.set(y1: 8.0)
            textAnnotation4.horizontalAnchorPoint = .right
            textAnnotation4.verticalAnchorPoint = .top
            textAnnotation4.text = "Anchor Right"
            
            let textAnnotation5 = SCITextAnnotation()
            textAnnotation5.set(x1: 5.0)
            textAnnotation5.set(y1: 8.0)
            textAnnotation5.horizontalAnchorPoint = .left
            textAnnotation5.verticalAnchorPoint = .top
            textAnnotation5.text = "or Anchor Left"
            
            // Line and line arrow annotations
            let textAnnotation6 = SCITextAnnotation()
            textAnnotation6.set(x1: 0.3)
            textAnnotation6.set(y1: 6.1)
            textAnnotation6.verticalAnchorPoint = .bottom
            textAnnotation6.text = "Draw Lines with \nor without Arrows"
            textAnnotation6.fontStyle = SCIFontStyle(fontSize: 12, andTextColor: .white)
            
            let lineAnnotation = SCILineAnnotation()
            lineAnnotation.set(x1: 1.0)
            lineAnnotation.set(y1: 4.0)
            lineAnnotation.set(x2: 2.0)
            lineAnnotation.set(y2: 6.0)
            lineAnnotation.stroke = SCISolidPenStyle(color: 0xFF555555, thickness: 2)
   
            let lineArrowAnnotation = SCILineArrowAnnotation()
            lineArrowAnnotation.set(x1: 1.2)
            lineArrowAnnotation.set(y1: 3.8)
            lineArrowAnnotation.set(x2: 2.5)
            lineArrowAnnotation.set(y2: 6.0)
            lineArrowAnnotation.headLength = 4
            lineArrowAnnotation.headWidth = 8
            lineArrowAnnotation.stroke = SCISolidPenStyle(color: 0xFF555555, thickness: 2)
            
            // Box annotations
            let textAnnotation7 = SCITextAnnotation()
            textAnnotation7.set(x1: 3.5)
            textAnnotation7.set(y1: 6.1)
            textAnnotation7.text = "Draw Boxes"
            textAnnotation7.verticalAnchorPoint = .bottom
            textAnnotation7.fontStyle = SCIFontStyle(fontSize: 12, andTextColor: .white)
            
            let boxAnnotation1 = SCIBoxAnnotation()
            boxAnnotation1.set(x1: 3.5)
            boxAnnotation1.set(y1: 4.0)
            boxAnnotation1.set(x2: 5.0)
            boxAnnotation1.set(y2: 5.0)
            boxAnnotation1.fillBrush = SCILinearGradientBrushStyle(start: CGPoint(x: 0.0, y: 0.5), end: CGPoint(x: 1.0, y: 0.5), startColor: 0x55274b92, endColor: 0x55e8c667)
            boxAnnotation1.borderPen = SCISolidPenStyle(color: 0x3368bcae, thickness: 1.0)
            
            let boxAnnotation2 = SCIBoxAnnotation()
            boxAnnotation2.set(x1: 4.0)
            boxAnnotation2.set(y1: 4.5)
            boxAnnotation2.set(x2: 5.5)
            boxAnnotation2.set(y2: 5.5)
            boxAnnotation2.fillBrush = SCISolidBrushStyle(color: 0x55ae418d)
            boxAnnotation2.borderPen = SCISolidPenStyle(color: 0xFFae418d, thickness: 1.0)
            
            let boxAnnotation3 = SCIBoxAnnotation()
            boxAnnotation3.set(x1: 4.5)
            boxAnnotation3.set(y1: 5.0)
            boxAnnotation3.set(x2: 6.0)
            boxAnnotation3.set(y2: 6.0)
            boxAnnotation3.fillBrush = SCISolidBrushStyle(color: 0x5568bcae)
            boxAnnotation3.borderPen = SCISolidPenStyle(color: 0xFF68bcae, thickness: 1.0)
            
            // Custom shapes
            let textAnnotation8 = SCITextAnnotation()
            textAnnotation8.set(x1: 7.0)
            textAnnotation8.set(y1: 6.1)
            textAnnotation8.verticalAnchorPoint = .bottom
            textAnnotation8.text = "Or Custom Shapes"
            textAnnotation8.fontStyle = SCIFontStyle(fontSize: 12, andTextColor: .white)
            
            let customAnnotationGreen = SCICustomAnnotation()
            customAnnotationGreen.customView = SCIImageView.init(image: #imageLiteral(resourceName: "image.arrow.green"))
            customAnnotationGreen.set(x1: 8)
            customAnnotationGreen.set(y1: 5.5)
            
            let customAnnotationRed = SCICustomAnnotation()
            customAnnotationRed.customView = SCIImageView.init(image: #imageLiteral(resourceName: "image.arrow.red"))
            customAnnotationRed.set(x1: 7.5)
            customAnnotationRed.set(y1: 5)
            
            // Horizontal Line Annotations
            let horizontalLine = SCIHorizontalLineAnnotation()
            horizontalLine.set(x1: 5.0)
            horizontalLine.set(y1: 3.2)
            horizontalLine.horizontalAlignment = .right
            horizontalLine.stroke = SCISolidPenStyle(color: 0xFFe97064, thickness: 2)
            horizontalLine.annotationLabels.add(self.createLabelWith(text: "Right Aligned, with text on left", labelPlacement: .topLeft))
            
            let horizontalLine1 = SCIHorizontalLineAnnotation()
            horizontalLine1.set(y1: 7.5)
            horizontalLine1.set(y1: 2.8)
            horizontalLine1.stroke = SCISolidPenStyle(color: 0xFFe97064, thickness: 2)
            horizontalLine1.annotationLabels.add(self.createLabelWith(text: nil, labelPlacement: .axis))
            
            // Vertical Line annotations
            let verticalLine = SCIVerticalLineAnnotation()
            verticalLine.set(x1: 9.0)
            verticalLine.set(y1: 4.0)
            verticalLine.verticalAlignment = .bottom;
            verticalLine.stroke = SCISolidPenStyle(color: 0xFFc43360, thickness: 2)
            verticalLine.annotationLabels.add(self.createLabelWith(text: nil, labelPlacement: .axis))
            
            let verticalLine1 = SCIVerticalLineAnnotation()
            verticalLine1.set(x1: 9.5)
            verticalLine1.set(y1: 10.0)
            verticalLine1.stroke = SCISolidPenStyle(color: 0xFFc43360, thickness: 2)
            verticalLine1.annotationLabels.add(self.createLabelWith(text: nil, labelPlacement: .axis))
            let label = self.createLabelWith(text: "Bottom-aligned", labelPlacement: .topRight)
            label.rotationAngle = -90
            verticalLine1.annotationLabels.add(label)
            
            self.surface.annotations = SCIAnnotationCollection(collection: [watermark, textAnnotation1, textAnnotation2, textAnnotation3, editableTextAnnotation, textAnnotation4, textAnnotation5, textAnnotation6, lineAnnotation, lineArrowAnnotation, textAnnotation7, boxAnnotation1, boxAnnotation2, boxAnnotation3, textAnnotation8, customAnnotationGreen, customAnnotationRed, horizontalLine, horizontalLine1, verticalLine, verticalLine1])
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
        }
    }
    
    fileprivate func createLabelWith(text: String?, labelPlacement: SCILabelPlacement) -> SCIAnnotationLabel {
        let annotationLabel = SCIAnnotationLabel()
        if (text != nil) {
            annotationLabel.text = text!
        }
        annotationLabel.labelPlacement = labelPlacement
        
        return annotationLabel
    }
}
