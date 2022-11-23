//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AnnotationsAreEasyView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AnnotationsAreEasyView.h"

@implementation AnnotationsAreEasyView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample  {
    SCINumericAxis *xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:0.0 max:10.0];
    
    SCINumericAxis *yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:0.0 max:10.0];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        
        // Watermark
        SCITextAnnotation *watermark = [SCITextAnnotation new];
        watermark.x1 = @(0.5);
        watermark.y1 = @(0.5);
        watermark.coordinateMode = SCIAnnotationCoordinateMode_Relative;
        watermark.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
        watermark.verticalAnchorPoint = SCIVerticalAnchorPoint_Center;
        watermark.text = @"Create \nWatermarks";
        watermark.fontStyle = [[SCIFontStyle alloc] initWithFontSize:42 andTextColorCode:0x55FFFFFF];
        
        // Text annotations
        SCITextAnnotation *textAnnotation1 = [SCITextAnnotation new];
        textAnnotation1.x1 = @(0.3);
        textAnnotation1.y1 = @(9.7);
        textAnnotation1.text = @"Annotations are Easy!";
        textAnnotation1.fontStyle = [[SCIFontStyle alloc] initWithFontSize:22 andTextColor:SCIColor.whiteColor];
        
        SCITextAnnotation *textAnnotation2 = [SCITextAnnotation new];
        textAnnotation2.x1 = @(1.0);
        textAnnotation2.y1 = @(9.0);
        textAnnotation2.text = @"You can create text";
        textAnnotation2.fontStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColor:SCIColor.whiteColor];
        
        SCITextAnnotation *editableTextAnnotation = [SCITextAnnotation new];
        editableTextAnnotation.x1 = @(1.0);
        editableTextAnnotation.y1 = @(8.8);
        editableTextAnnotation.canEditText = YES;
        editableTextAnnotation.text = @"And even edit it ... (tap me)";
        editableTextAnnotation.fontStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColor:SCIColor.whiteColor];
        
        // Text with Anchor Points
        SCITextAnnotation *textAnnotation3 = [SCITextAnnotation new];
        textAnnotation3.x1 = @(5.0);
        textAnnotation3.y1 = @(8.0);
        textAnnotation3.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
        textAnnotation3.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
        textAnnotation3.text = @"Anchor Center (x1, y1)";
        
        SCITextAnnotation *textAnnotation4 = [SCITextAnnotation new];
        textAnnotation4.x1 = @(5.0);
        textAnnotation4.y1 = @(8.0);
        textAnnotation4.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Right;
        textAnnotation4.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
        textAnnotation4.text = @"Anchor Right";
        
        SCITextAnnotation *textAnnotation5 = [SCITextAnnotation new];
        textAnnotation5.x1 = @(5.0);
        textAnnotation5.y1 = @(8.0);
        textAnnotation5.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Left;
        textAnnotation5.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
        textAnnotation5.text = @"or Anchor Left";
        
        // Line and line arrow annotations
        SCITextAnnotation *textAnnotation6 = [SCITextAnnotation new];
        textAnnotation6.x1 = @(0.3);
        textAnnotation6.y1 = @(6.1);
        textAnnotation6.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
        textAnnotation6.text = @"Draw Lines with \nor without Arrows";
        textAnnotation6.fontStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColor:SCIColor.whiteColor];
        
        SCILineAnnotation *lineAnnotation = [SCILineAnnotation new];
        lineAnnotation.x1 = @(1.0);
        lineAnnotation.y1 = @(4.0);
        lineAnnotation.x2 = @(2.0);
        lineAnnotation.y2 = @(6.0);
        lineAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFF555555 thickness:2];
        
        SCILineArrowAnnotation *lineArrowAnnotation = [SCILineArrowAnnotation new];
        lineArrowAnnotation.x1 = @(1.2);
        lineArrowAnnotation.y1 = @(3.8);
        lineArrowAnnotation.x2 = @(2.5);
        lineArrowAnnotation.y2 = @(6.0);
        lineArrowAnnotation.headLength = 4;
        lineArrowAnnotation.headWidth = 8;
        lineArrowAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFF555555 thickness:2];
        
        // Box annotations
        SCITextAnnotation *textAnnotation7 = [SCITextAnnotation new];
        textAnnotation7.x1 = @(3.5);
        textAnnotation7.y1 = @(6.1);
        textAnnotation7.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
        textAnnotation7.text = @"Draw Boxes";
        textAnnotation7.fontStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColor:SCIColor.whiteColor];
        
        SCIBoxAnnotation *boxAnnotation1 = [SCIBoxAnnotation new];
        boxAnnotation1.x1 = @(3.5);
        boxAnnotation1.y1 = @(4.0);
        boxAnnotation1.x2 = @(5.0);
        boxAnnotation1.y2 = @(5.0);
        boxAnnotation1.fillBrush = [[SCILinearGradientBrushStyle alloc] initWithStart:CGPointZero end:CGPointMake(0, 1) startColorCode:0x55274b92 endColorCode:0x55e8c667];
        boxAnnotation1.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0x3368bcae thickness:1.0];
        
        SCIBoxAnnotation *boxAnnotation2 = [SCIBoxAnnotation new];
        boxAnnotation2.x1 = @(4.0);
        boxAnnotation2.y1 = @(4.5);
        boxAnnotation2.x2 = @(5.5);
        boxAnnotation2.y2 = @(5.5);
        boxAnnotation2.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x55ae418d];
        boxAnnotation2.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFae418d thickness:1.0];
        
        SCIBoxAnnotation *boxAnnotation3 = [SCIBoxAnnotation new];
        boxAnnotation3.x1 = @(4.5);
        boxAnnotation3.y1 = @(5.0);
        boxAnnotation3.x2 = @(6.0);
        boxAnnotation3.y2 = @(6.0);
        boxAnnotation3.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x5568bcae];
        boxAnnotation3.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:1.0];

        // Custom shapes
        SCITextAnnotation *textAnnotation8 = [SCITextAnnotation new];
        textAnnotation8.x1 = @(7.0);
        textAnnotation8.y1 = @(6.1);
        textAnnotation8.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
        textAnnotation8.text = @"Or Custom Shapes";
        textAnnotation8.fontStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColor:SCIColor.whiteColor];
        
        SCICustomAnnotation *customAnnotationGreen = [SCICustomAnnotation new];
        customAnnotationGreen.customView = [SCIImageView imageViewWithImage:[SCIImage imageNamed:@"image.arrow.green"]];
        customAnnotationGreen.x1 = @(8);
        customAnnotationGreen.y1 = @(5.5);
        
        SCICustomAnnotation *customAnnotationRed = [SCICustomAnnotation new];
        customAnnotationGreen.customView = [SCIImageView imageViewWithImage:[SCIImage imageNamed:@"image.arrow.red"]];
        customAnnotationRed.x1 = @(7.5);
        customAnnotationRed.y1 = @(5);
        
        // Horizontal Line Annotations
        SCIHorizontalLineAnnotation *horizontalLine = [SCIHorizontalLineAnnotation new];
        horizontalLine.x1 = @(5.0);
        horizontalLine.y1 = @(3.2);
        horizontalLine.horizontalAlignment = SCIAlignment_Right;
        horizontalLine.stroke = [[SCISolidPenStyle alloc] initWithColorCode: 0xFFe97064 thickness:2];
        [horizontalLine.annotationLabels add:[self createLabelWithText:@"Right Aligned, with text on left" alignment:SCILabelPlacement_TopLeft]];
        
        SCIHorizontalLineAnnotation *horizontalLine1 = [SCIHorizontalLineAnnotation new];
        horizontalLine1.y1 = @(7.5);
        horizontalLine1.y1 = @(2.8);
        horizontalLine1.stroke = [[SCISolidPenStyle alloc] initWithColorCode: 0xFFe97064 thickness:2];
        [horizontalLine1.annotationLabels add:[self createLabelWithText:nil alignment:SCILabelPlacement_Axis]];
        
        // Vertical Line annotations
        SCIVerticalLineAnnotation *verticalLine = [SCIVerticalLineAnnotation new];
        verticalLine.x1 = @(9.0);
        verticalLine.y1 = @(4.0);
        verticalLine.verticalAlignment = SCIAlignment_Bottom;
        verticalLine.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFFc43360 thickness:2];
        [verticalLine.annotationLabels add:[self createLabelWithText:nil alignment:SCILabelPlacement_Axis]];

        SCIVerticalLineAnnotation *verticalLine1 = [SCIVerticalLineAnnotation new];
        verticalLine1.x1 = @(9.5);
        verticalLine1.y1 = @(10.0);
        verticalLine1.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFFc43360 thickness:2];
        [verticalLine1.annotationLabels add:[self createLabelWithText:nil alignment:SCILabelPlacement_Axis]];
        SCIAnnotationLabel *label = [self createLabelWithText:@"Bottom-aligned" alignment:SCILabelPlacement_TopRight];
        label.rotationAngle = -90;
        [verticalLine1.annotationLabels add:label];

        self.surface.annotations = [[SCIAnnotationCollection alloc] initWithCollection: @[watermark, textAnnotation1, textAnnotation2, textAnnotation3, editableTextAnnotation, textAnnotation4, textAnnotation5, textAnnotation6, lineAnnotation, lineArrowAnnotation, textAnnotation7, boxAnnotation1, boxAnnotation2, boxAnnotation3, textAnnotation8, customAnnotationGreen, customAnnotationRed, horizontalLine, horizontalLine1, verticalLine, verticalLine1]];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
    }];
}

- (SCIAnnotationLabel *)createLabelWithText:(NSString *)text alignment:(SCILabelPlacement)labelPlacement {
    SCIAnnotationLabel *annotationLabel = [SCIAnnotationLabel new];
    if (text != nil) {
        annotationLabel.text = text;
    }
    annotationLabel.labelPlacement = labelPlacement;
    
    return annotationLabel;
}

@end
