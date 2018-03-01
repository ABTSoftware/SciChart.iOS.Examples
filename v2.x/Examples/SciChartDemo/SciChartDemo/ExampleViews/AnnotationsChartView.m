//
//  AnnotationsView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 3/29/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "AnnotationsChartView.h"
#import <SciChart/SciChart.h>

@implementation AnnotationsChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:surface];
        NSDictionary * layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    SCINumericAxis * xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.0) Max:SCIGeneric(10.0)];
    
    SCINumericAxis * yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.0) Max:SCIGeneric(10.0)];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        
        // Watermark
        SCITextAnnotation * watermark = [SCITextAnnotation new];
        watermark.coordinateMode = SCIAnnotationCoordinate_Relative;
        watermark.x1 = SCIGeneric(0.5);
        watermark.y1 = SCIGeneric(0.5);
        watermark.text = @"Create \n Watermarks";
        watermark.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
        watermark.verticalAnchorPoint = SCIHorizontalAnchorPoint_Center;
        watermark.style.textColor = [UIColor fromARGBColorCode:0x22FFFFFF];
        watermark.style.textStyle.fontSize = 42;
        watermark.style.backgroundColor = UIColor.clearColor;
        
        // Text annotations
        SCITextAnnotation * textAnnotation1 = [SCITextAnnotation new];
        textAnnotation1.x1 = SCIGeneric(0.3);
        textAnnotation1.y1 = SCIGeneric(9.7);
        textAnnotation1.text = @"Annotations are Easy!";
        textAnnotation1.style.textColor = UIColor.whiteColor;
        textAnnotation1.style.textStyle.fontSize = 24;
        textAnnotation1.style.backgroundColor = UIColor.clearColor;
        
        SCITextAnnotation * textAnnotation2 = [SCITextAnnotation new];
        textAnnotation2.x1 = SCIGeneric(1.0);
        textAnnotation2.y1 = SCIGeneric(9.0);
        textAnnotation2.text = @"You can create text";
        textAnnotation2.style.textColor = UIColor.whiteColor;
        textAnnotation2.style.textStyle.fontSize = 10;
        textAnnotation2.style.backgroundColor = UIColor.clearColor;
        
        // Text with Anchor Points
        SCITextAnnotation * textAnnotation3 = [SCITextAnnotation new];
        textAnnotation3.x1 = SCIGeneric(5.0);
        textAnnotation3.y1 = SCIGeneric(8.0);
        textAnnotation3.text = @"Anchor Center (x1, y1)";
        textAnnotation3.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
        textAnnotation3.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
        textAnnotation3.style.textColor = UIColor.whiteColor;
        textAnnotation3.style.textStyle.fontSize = 12;
        
        SCITextAnnotation * textAnnotation4 = [SCITextAnnotation new];
        textAnnotation4.x1 = SCIGeneric(5.0);
        textAnnotation4.y1 = SCIGeneric(8.0);
        textAnnotation4.text = @"Anchor Right";
        textAnnotation4.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Right;
        textAnnotation4.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
        textAnnotation4.style.textColor = UIColor.whiteColor;
        textAnnotation4.style.textStyle.fontSize = 12;
        
        SCITextAnnotation * textAnnotation5 = [SCITextAnnotation new];
        textAnnotation5.x1 = SCIGeneric(5.0);
        textAnnotation5.y1 = SCIGeneric(8.0);
        textAnnotation5.text = @"or Anchor Left";
        textAnnotation5.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Left;
        textAnnotation5.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
        textAnnotation5.style.textColor = UIColor.whiteColor;
        textAnnotation5.style.textStyle.fontSize = 12;
        
        // Line and line arrow annotations
        SCITextAnnotation * textAnnotation6 = [SCITextAnnotation new];
        textAnnotation6.x1 = SCIGeneric(0.3);
        textAnnotation6.y1 = SCIGeneric(6.1);
        textAnnotation6.text = @"Draw Lines with \nor without Arrows";
        textAnnotation6.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
        textAnnotation6.style.textColor = UIColor.whiteColor;
        textAnnotation6.style.textStyle.fontSize = 12;
        
        SCILineAnnotation * lineAnnotation = [SCILineAnnotation new];
        lineAnnotation.x1 = SCIGeneric(1.0);
        lineAnnotation.y1 = SCIGeneric(4.0);
        lineAnnotation.x2 = SCIGeneric(2.0);
        lineAnnotation.y2 = SCIGeneric(6.0);
        lineAnnotation.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF555555 withThickness:2];
        
        // Should be line annotation with arrow here
        
        // Box annotations
        SCITextAnnotation * textAnnotation7 = [SCITextAnnotation new];
        textAnnotation7.x1 = SCIGeneric(3.5);
        textAnnotation7.y1 = SCIGeneric(6.1);
        textAnnotation7.text = @"Draw Boxes";
        textAnnotation7.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
        textAnnotation7.style.textColor = UIColor.whiteColor;
        textAnnotation7.style.textStyle.fontSize = 12;
        
        SCIBoxAnnotation * boxAnnotation1 = [SCIBoxAnnotation new];
        boxAnnotation1.x1 = SCIGeneric(3.5);
        boxAnnotation1.y1 = SCIGeneric(4.0);
        boxAnnotation1.x2 = SCIGeneric(5.0);
        boxAnnotation1.y2 = SCIGeneric(5.0);
        boxAnnotation1.style.fillBrush = [[SCILinearGradientBrushStyle alloc] initWithColorStart:[UIColor fromARGBColorCode:0x550000FF] finish:[UIColor fromARGBColorCode:0x55FFFF00] direction:SCILinearGradientDirection_Vertical];
        boxAnnotation1.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:1.0];
        
        SCIBoxAnnotation * boxAnnotation2 = [SCIBoxAnnotation new];
        boxAnnotation2.x1 = SCIGeneric(4.0);
        boxAnnotation2.y1 = SCIGeneric(4.5);
        boxAnnotation2.x2 = SCIGeneric(5.5);
        boxAnnotation2.y2 = SCIGeneric(5.5);
        boxAnnotation2.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x55FF1919];
        boxAnnotation2.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF1919 withThickness:1.0];
        
        SCIBoxAnnotation * boxAnnotation3 = [SCIBoxAnnotation new];
        boxAnnotation3.x1 = SCIGeneric(4.5);
        boxAnnotation3.y1 = SCIGeneric(5.0);
        boxAnnotation3.x2 = SCIGeneric(6.0);
        boxAnnotation3.y2 = SCIGeneric(6.0);
        boxAnnotation3.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x55279B27];
        boxAnnotation3.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:1.0];

        // Custom shapes
        SCITextAnnotation * textAnnotation8 = [SCITextAnnotation new];
        textAnnotation8.x1 = SCIGeneric(7.0);
        textAnnotation8.y1 = SCIGeneric(6.1);
        textAnnotation8.text = @"Or Custom Shapes";
        textAnnotation8.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
        textAnnotation8.style.textColor = UIColor.whiteColor;
        textAnnotation8.style.textStyle.fontSize = 12;
        
        SCICustomAnnotation * customAnnotationGreen = [SCICustomAnnotation new];
        customAnnotationGreen.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GreenArrow"]];
        customAnnotationGreen.x1 = SCIGeneric(8);
        customAnnotationGreen.y1 = SCIGeneric(5.5);
        
        SCICustomAnnotation * customAnnotationRed = [SCICustomAnnotation new];
        customAnnotationRed.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RedArrow"]];
        customAnnotationRed.x1 = SCIGeneric(7.5);
        customAnnotationRed.y1 = SCIGeneric(5);
        
        // Horizontal Line Annotations
        SCIHorizontalLineAnnotation * horizontalLine = [SCIHorizontalLineAnnotation new];
        horizontalLine.x1 = SCIGeneric(5.0);
        horizontalLine.y1 = SCIGeneric(3.2);
        horizontalLine.horizontalAlignment = SCIHorizontalLineAnnotationAlignment_Right;
        horizontalLine.style.linePen = [[SCISolidPenStyle alloc] initWithColor:UIColor.orangeColor withThickness:2];
        [horizontalLine addLabel:[self createLabelWithText:@"Right Aligned, with text on left" alignment:SCILabelPlacement_TopLeft color:UIColor.orangeColor backColor:UIColor.clearColor]];
        
        SCIHorizontalLineAnnotation * horizontalLine1 = [SCIHorizontalLineAnnotation new];
        horizontalLine1.y1 = SCIGeneric(7.5);
        horizontalLine1.y1 = SCIGeneric(2.8);
        horizontalLine1.style.linePen = [[SCISolidPenStyle alloc] initWithColor:UIColor.orangeColor withThickness:2];
        [horizontalLine1 addLabel:[self createLabelWithText:@"" alignment:SCILabelPlacement_Axis color:UIColor.blackColor backColor:UIColor.orangeColor]];
        
        // Vertical Line annotations
        SCIVerticalLineAnnotation * verticalLine = [SCIVerticalLineAnnotation new];
        verticalLine.x1 = SCIGeneric(9.0);
        verticalLine.y1 = SCIGeneric(4.0);
        verticalLine.verticalAlignment = SCIVerticalLineAnnotationAlignment_Bottom;
        verticalLine.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFA52A2A withThickness:2];
        [verticalLine addLabel:[self createLabelWithText:@"" alignment:SCILabelPlacement_Axis color:UIColor.blackColor backColor:[UIColor fromARGBColorCode:0xFFA52A2A]]];

        SCIVerticalLineAnnotation * verticalLine1 = [SCIVerticalLineAnnotation new];
        verticalLine1.x1 = SCIGeneric(9.5);
        verticalLine1.y1 = SCIGeneric(10.0);
        verticalLine1.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFA52A2A withThickness:2];
        [verticalLine1 addLabel:[self createLabelWithText:@"" alignment:SCILabelPlacement_Axis color:UIColor.blackColor backColor:[UIColor fromARGBColorCode:0xFFA52A2A]]];
        [verticalLine1 addLabel:[self createLabelWithText:@"Bottom-aligned" alignment:SCILabelPlacement_TopRight color:[UIColor fromARGBColorCode:0xFFA52A2A] backColor:UIColor.clearColor]];

        surface.annotations = [[SCIAnnotationCollection alloc] initWithChildAnnotations:@[watermark, textAnnotation1, textAnnotation2,
                                                                                          textAnnotation3, textAnnotation4, textAnnotation5,
                                                                                          textAnnotation6, lineAnnotation,
                                                                                          textAnnotation7, boxAnnotation1, boxAnnotation2, boxAnnotation3,
                                                                                          textAnnotation8, customAnnotationGreen, customAnnotationRed,
                                                                                          horizontalLine, horizontalLine1, verticalLine, verticalLine1]];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIZoomPanModifier new]]];
    }];
}

- (SCILineAnnotationLabel *)createLabelWithText:(NSString *)text alignment:(SCILabelPlacement)labelPlacement color:(UIColor*)color backColor:(UIColor*)backColor {
    SCILineAnnotationLabel * lineAnnotationLabel = [SCILineAnnotationLabel new];
    lineAnnotationLabel.text = text;
    lineAnnotationLabel.style.backgroundColor = backColor;
    lineAnnotationLabel.style.labelPlacement = labelPlacement;
    lineAnnotationLabel.style.textStyle.color = color;
    
    return lineAnnotationLabel;
}

@end
