//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AnnotationsChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class AnnotationsChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            
            // Watermark
            let watermark = SCITextAnnotation()
            watermark.coordinateMode = .relative
            watermark.x1 = SCIGeneric(0.5)
            watermark.y1 = SCIGeneric(0.5)
            watermark.text = "Create \n Watermarks"
            watermark.horizontalAnchorPoint = .center
            watermark.verticalAnchorPoint = .center
            watermark.style.textColor = UIColor.fromARGBColorCode(0x22FFFFFF)
            watermark.style.textStyle.fontSize = 42
            watermark.style.backgroundColor = UIColor.clear
            
            // Text annotations
            let textAnnotation1 = SCITextAnnotation()
            textAnnotation1.x1 = SCIGeneric(0.3)
            textAnnotation1.y1 = SCIGeneric(9.7)
            textAnnotation1.text = "Annotations are Easy!"
            textAnnotation1.style.textColor = UIColor.white
            textAnnotation1.style.textStyle.fontSize = 24
            textAnnotation1.style.backgroundColor = UIColor.clear
            
            let textAnnotation2 = SCITextAnnotation()
            textAnnotation2.x1 = SCIGeneric(1.0)
            textAnnotation2.y1 = SCIGeneric(9.0)
            textAnnotation2.text = "You can create text"
            textAnnotation2.style.textColor = UIColor.white
            textAnnotation2.style.textStyle.fontSize = 10
            textAnnotation2.style.backgroundColor = UIColor.clear
            
            // Text with Anchor Points
            let textAnnotation3 = SCITextAnnotation()
            textAnnotation3.x1 = SCIGeneric(5.0)
            textAnnotation3.y1 = SCIGeneric(8.0)
            textAnnotation3.text = "Anchor Center (x1, y1)"
            textAnnotation3.horizontalAnchorPoint = .center
            textAnnotation3.verticalAnchorPoint = .bottom
            textAnnotation3.style.textColor = UIColor.white
            textAnnotation3.style.textStyle.fontSize = 12
            
            let textAnnotation4 = SCITextAnnotation()
            textAnnotation4.x1 = SCIGeneric(5.0)
            textAnnotation4.y1 = SCIGeneric(8.0)
            textAnnotation4.text = "Anchor Right"
            textAnnotation4.horizontalAnchorPoint = .right
            textAnnotation4.verticalAnchorPoint = .top
            textAnnotation4.style.textColor = UIColor.white
            textAnnotation4.style.textStyle.fontSize = 12
            
            let textAnnotation5 = SCITextAnnotation()
            textAnnotation5.x1 = SCIGeneric(5.0)
            textAnnotation5.y1 = SCIGeneric(8.0)
            textAnnotation5.text = "or Anchor Left";
            textAnnotation5.horizontalAnchorPoint = .left
            textAnnotation5.verticalAnchorPoint = .top
            textAnnotation5.style.textColor = UIColor.white
            textAnnotation5.style.textStyle.fontSize = 12
            
            // Line and line arrow annotations
            let textAnnotation6 = SCITextAnnotation()
            textAnnotation6.x1 = SCIGeneric(0.3)
            textAnnotation6.y1 = SCIGeneric(6.1)
            textAnnotation6.text = "Draw Lines with \nor without Arrows"
            textAnnotation6.verticalAnchorPoint = .bottom
            textAnnotation6.style.textColor = UIColor.white
            textAnnotation6.style.textStyle.fontSize = 12
            
            let lineAnnotation = SCILineAnnotation()
            lineAnnotation.x1 = SCIGeneric(1.0)
            lineAnnotation.y1 = SCIGeneric(4.0)
            lineAnnotation.x2 = SCIGeneric(2.0)
            lineAnnotation.y2 = SCIGeneric(6.0)
            lineAnnotation.style.linePen = SCISolidPenStyle(colorCode: 0xFF555555, withThickness: 2)
            
            // Should be line annotation with arrow here
            
            // Box annotations
            let textAnnotation7 = SCITextAnnotation()
            textAnnotation7.x1 = SCIGeneric(3.5)
            textAnnotation7.y1 = SCIGeneric(6.1)
            textAnnotation7.text = "Draw Boxes"
            textAnnotation7.verticalAnchorPoint = .bottom
            textAnnotation7.style.textColor = UIColor.white
            textAnnotation7.style.textStyle.fontSize = 12
            
            let boxAnnotation1 = SCIBoxAnnotation()
            boxAnnotation1.x1 = SCIGeneric(3.5)
            boxAnnotation1.y1 = SCIGeneric(4.0)
            boxAnnotation1.x2 = SCIGeneric(5.0)
            boxAnnotation1.y2 = SCIGeneric(5.0)
            boxAnnotation1.style.fillBrush = SCILinearGradientBrushStyle(colorCodeStart: 0x550000FF, finish: 0x55FFFF00, direction: .vertical)
            boxAnnotation1.style.borderPen = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
            
            let boxAnnotation2 = SCIBoxAnnotation()
            boxAnnotation2.x1 = SCIGeneric(4.0)
            boxAnnotation2.y1 = SCIGeneric(4.5)
            boxAnnotation2.x2 = SCIGeneric(5.5)
            boxAnnotation2.y2 = SCIGeneric(5.5)
            boxAnnotation2.style.fillBrush = SCISolidBrushStyle(colorCode: 0x55FF1919)
            boxAnnotation2.style.borderPen = SCISolidPenStyle(colorCode: 0xFFFF1919, withThickness: 1.0)
            
            let boxAnnotation3 = SCIBoxAnnotation()
            boxAnnotation3.x1 = SCIGeneric(4.5)
            boxAnnotation3.y1 = SCIGeneric(5.0)
            boxAnnotation3.x2 = SCIGeneric(6.0)
            boxAnnotation3.y2 = SCIGeneric(6.0)
            boxAnnotation3.style.fillBrush = SCISolidBrushStyle(colorCode: 0x55279B27)
            boxAnnotation3.style.borderPen = SCISolidPenStyle(colorCode: 0xFF279B27, withThickness: 1.0)
            
            // Custom shapes
            let textAnnotation8 = SCITextAnnotation()
            textAnnotation8.x1 = SCIGeneric(7.0)
            textAnnotation8.y1 = SCIGeneric(6.1)
            textAnnotation8.text = "Or Custom Shapes"
            textAnnotation8.verticalAnchorPoint = .bottom
            textAnnotation8.style.textColor = UIColor.white
            textAnnotation8.style.textStyle.fontSize = 12
            
            let customAnnotationGreen = SCICustomAnnotation()
            customAnnotationGreen.customView = UIImageView(image: UIImage(named: "GreenArrow"))
            customAnnotationGreen.x1 = SCIGeneric(8)
            customAnnotationGreen.y1 = SCIGeneric(5.5)
            
            let customAnnotationRed = SCICustomAnnotation()
            customAnnotationRed.customView = UIImageView(image: UIImage(named: "RedArrow"))
            customAnnotationRed.x1 = SCIGeneric(7.5)
            customAnnotationRed.y1 = SCIGeneric(5)
            
            // Horizontal Line Annotations
            let horizontalLine = SCIHorizontalLineAnnotation()
            horizontalLine.x1 = SCIGeneric(5.0)
            horizontalLine.y1 = SCIGeneric(3.2)
            horizontalLine.horizontalAlignment = .right
            horizontalLine.style.linePen = SCISolidPenStyle(color: UIColor.orange, withThickness: 2)
            horizontalLine.add(self.createLabelWith(text: "Right Aligned, with text on left", labelPlacement: .topLeft, color: UIColor.orange, backColor: UIColor.clear))
            
            let horizontalLine1 = SCIHorizontalLineAnnotation()
            horizontalLine1.y1 = SCIGeneric(7.5)
            horizontalLine1.y1 = SCIGeneric(2.8)
            horizontalLine1.style.linePen = SCISolidPenStyle(color: UIColor.orange, withThickness: 2)
            horizontalLine1.add(self.createLabelWith(text: "", labelPlacement: .axis, color: UIColor.black, backColor: UIColor.orange))
            
            // Vertical Line annotations
            let verticalLine = SCIVerticalLineAnnotation()
            verticalLine.x1 = SCIGeneric(9.0)
            verticalLine.y1 = SCIGeneric(4.0)
            verticalLine.verticalAlignment = .bottom;
            verticalLine.style.linePen = SCISolidPenStyle(colorCode: 0xFFA52A2A, withThickness: 2)
            verticalLine.add(self.createLabelWith(text: "", labelPlacement: .axis, color: UIColor.black, backColor: UIColor.fromARGBColorCode(0xFFA52A2A)))
            
            let verticalLine1 = SCIVerticalLineAnnotation()
            verticalLine1.x1 = SCIGeneric(9.5)
            verticalLine1.y1 = SCIGeneric(10.0)
            verticalLine1.style.linePen = SCISolidPenStyle(colorCode: 0xFFA52A2A, withThickness: 2)
            verticalLine.add(self.createLabelWith(text: "", labelPlacement: .axis, color: UIColor.black, backColor: UIColor.fromARGBColorCode(0xFFA52A2A)))
            verticalLine.add(self.createLabelWith(text: "Bottom-aligned", labelPlacement: .topRight, color: UIColor.fromARGBColorCode(0xFFA52A2A), backColor: UIColor.clear))
            
            self.surface.annotations = SCIAnnotationCollection(childAnnotations: [watermark, textAnnotation1, textAnnotation2,
                                                                                  textAnnotation3, textAnnotation4, textAnnotation5,
                                                                                  textAnnotation6, lineAnnotation,
                                                                                  textAnnotation7, boxAnnotation1, boxAnnotation2, boxAnnotation3,
                                                                                  textAnnotation8, customAnnotationGreen, customAnnotationRed,
                                                                                  horizontalLine, horizontalLine1, verticalLine, verticalLine1])
            
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
        }
    }
    
    fileprivate func createLabelWith(text: String, labelPlacement: SCILabelPlacement, color: UIColor, backColor: UIColor) -> SCILineAnnotationLabel {
        let lineAnnotationLabel = SCILineAnnotationLabel()
        lineAnnotationLabel.text = text
        lineAnnotationLabel.style.backgroundColor = backColor
        lineAnnotationLabel.style.labelPlacement = labelPlacement
        lineAnnotationLabel.style.textStyle.color = color
        
        return lineAnnotationLabel
    }
}
