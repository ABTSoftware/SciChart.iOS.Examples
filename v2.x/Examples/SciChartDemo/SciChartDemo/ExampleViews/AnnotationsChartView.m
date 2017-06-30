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

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]init];
        surface = view;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData{
    
    SCITextFormattingStyle *textFormatting = [SCITextFormattingStyle new];
    
    SCINumericAxis *yAxis = [SCINumericAxis new];
    [yAxis.style setLabelStyle:textFormatting];
    [yAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [yAxis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.0) Max:SCIGeneric(10.0)]];
    [surface.yAxes add:yAxis];
    
    SCINumericAxis *xAxis = [SCINumericAxis new];
    [xAxis.style setLabelStyle:textFormatting];
    [xAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [xAxis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.0) Max:SCIGeneric(10.0)]];
    [surface.xAxes add:xAxis];
    
    SCIPinchZoomModifier *pzm = [SCIPinchZoomModifier new];
    SCIZoomExtentsModifier *zem = [SCIZoomExtentsModifier new];
    SCIZoomPanModifier *zpm = [SCIZoomPanModifier new];
    zpm.clipModeX = SCIClipMode_None;
    
    SCIChartModifierCollection *gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[pzm, zem, zpm]];
    [surface setChartModifiers: gm];
    
    [self setupAnnotations];
    
    [surface invalidateElement];
}

-(void) setupAnnotations {
    
    SCIAnnotationCollection *annotationCollection = [SCIAnnotationCollection new];
    
    // Watermark
    SCITextFormattingStyle *textStyle = [SCITextFormattingStyle new];
    [textStyle setFontSize:42];
    [self buildTextAnnotation:annotationCollection
                             :0.5 :0.5
                             :SCIHorizontalAnchorPoint_Center
                             :SCIVerticalAnchorPoint_Center
                             :textStyle
                             :SCIAnnotationCoordinate_Relative
                             :@"Create \n Watermarks" :0x22FFFFFF];
    
    // Text annotations
    textStyle = [SCITextFormattingStyle new];
    [textStyle setFontSize:24];
    [self buildTextAnnotation:annotationCollection
                             :0.3 :9.7
                             :SCIHorizontalAnchorPoint_Left
                             :SCIVerticalAnchorPoint_Top
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"Annotations are Easy!" :0xFFFFFFFF];
    
    textStyle = [SCITextFormattingStyle new];
    [textStyle setColor: [UIColor whiteColor]];
    [textStyle setFontSize:10];
    [self buildTextAnnotation:annotationCollection
                             :1.0 :9.0
                             :SCIHorizontalAnchorPoint_Left
                             :SCIVerticalAnchorPoint_Top
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"You can create text" :0xFFFFFFFF];
    
    [self buildTextAnnotation:annotationCollection
                             :5.0 :8.0
                             :SCIHorizontalAnchorPoint_Center
                             :SCIVerticalAnchorPoint_Bottom
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"Anchor Center" :0xFFFFFFFF];
    
    [self buildTextAnnotation:annotationCollection
                             :5.0 :8.0
                             :SCIHorizontalAnchorPoint_Right
                             :SCIVerticalAnchorPoint_Top
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"Anchor Right" :0xFFFFFFFF];
    
    [self buildTextAnnotation:annotationCollection
                             :5.0 :8.0
                             :SCIHorizontalAnchorPoint_Left
                             :SCIVerticalAnchorPoint_Top
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"or anchor Left" :0xFFFFFFFF];
    
    // Line and line arrow annotations
    textStyle = [SCITextFormattingStyle new];
    [textStyle setColor: [UIColor whiteColor]];
    [textStyle setFontSize:12];
    
    [self buildTextAnnotation:annotationCollection
                             :0.3 :6.1
                             :SCIHorizontalAnchorPoint_Left
                             :SCIVerticalAnchorPoint_Bottom
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"Draw Lines \nAnnotations" :0xFFFFFFFF];
    
    [self buildLineAnnotation:annotationCollection
                             :1.0 :4.0
                             :2.0 :6.0
                             :0xFF555555 :2.0];
    
    // Box annotations
    [self buildTextAnnotation:annotationCollection
                             :3.5 :6.1
                             :SCIHorizontalAnchorPoint_Left
                             :SCIVerticalAnchorPoint_Bottom
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"Draw Boxes" :0xFFFFFFFF];
    
    [self buildBoxAnnotation:annotationCollection
                            :3.5 :4.0 :5.0 :5.0
                            :[[SCILinearGradientBrushStyle alloc]initWithColorStart:[UIColor fromARGBColorCode:0x550000FF] finish:[UIColor fromARGBColorCode:0x55FFFF00] direction:SCILinearGradientDirection_Vertical]
                            :[[SCISolidPenStyle alloc]initWithColorCode:0xFF279B27 withThickness:1.0] ];
    
    [self buildBoxAnnotation:annotationCollection
                            :4.0 :4.5 :5.5 :5.5
                            :[[SCISolidBrushStyle alloc]initWithColorCode:0x55FF1919]
                            :[[SCISolidPenStyle alloc]initWithColorCode:0xFFFF1919 withThickness:1.0] ];
    
    [self buildBoxAnnotation:annotationCollection
                            :4.5 :5.0 :6.0 :6.0
                            :[[SCISolidBrushStyle alloc]initWithColorCode:0x55279B27]
                            :[[SCISolidPenStyle alloc]initWithColorCode:0xFF279B27 withThickness:1.0] ];
    
    // Custom shapes
    [self buildTextAnnotation:annotationCollection
                             :7.0 :6.1
                             :SCIHorizontalAnchorPoint_Left
                             :SCIVerticalAnchorPoint_Bottom
                             :textStyle
                             :SCIAnnotationCoordinate_Absolute
                             :@"Or Custom Shapes" :0xFFFFFFFF];
    
    
    SCICustomAnnotation * customAnnotationGreen = [[SCICustomAnnotation alloc]init];
    [customAnnotationGreen setCustomView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"GreenArrow"]]];
    [customAnnotationGreen setX1:SCIGeneric(8)];
    [customAnnotationGreen setY1:SCIGeneric(5.5)];
    [annotationCollection add:customAnnotationGreen];
    
    SCICustomAnnotation * customAnnotationRed = [[SCICustomAnnotation alloc]init];
    [customAnnotationRed setCustomView:[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"RedArrow"]]];
    [customAnnotationRed setX1:SCIGeneric(7.5)];
    [customAnnotationRed setY1:SCIGeneric(5)];
    [annotationCollection add:customAnnotationRed];
    
    
    // Horizontal Line Annotations
    SCIHorizontalLineAnnotation * horizontalLine = [[SCIHorizontalLineAnnotation alloc] init];
    horizontalLine.coordinateMode = SCIAnnotationCoordinate_Absolute;
    horizontalLine.x1 = SCIGeneric(5.0);
    horizontalLine.y1 = SCIGeneric(3.2);
    horizontalLine.horizontalAlignment = SCIHorizontalLineAnnotationAlignment_Right;
    horizontalLine.style.linePen = [[SCISolidPenStyle alloc] initWithColor: [UIColor orangeColor] withThickness:2];
    [horizontalLine addLabel: [self buildLineAnnotationLabelWithText:@"Right Aligned, with text on left" andAlignment:SCILabelPlacement_TopLeft andColor:[UIColor orangeColor] andBackColor:[UIColor clearColor]]];
    [annotationCollection add:horizontalLine];
    
    SCIHorizontalLineAnnotation * horizontalLine1 = [[SCIHorizontalLineAnnotation alloc] init];
    horizontalLine1.coordinateMode = SCIAnnotationCoordinate_Absolute;
    horizontalLine1.horizontalAlignment = SCIHorizontalLineAnnotationAlignment_Stretch;
    horizontalLine1.y1 = SCIGeneric(2.8);
    [horizontalLine1 addLabel: [self buildLineAnnotationLabelWithText:@"" andAlignment:SCILabelPlacement_Axis andColor:[UIColor blackColor] andBackColor:[UIColor orangeColor]]];
    horizontalLine1.style.linePen = [[SCISolidPenStyle alloc] initWithColor: [UIColor orangeColor] withThickness:2];
    [annotationCollection add:horizontalLine1];
    
    // Vertical Line annotations
    SCIVerticalLineAnnotation * verticalLine = [[SCIVerticalLineAnnotation alloc] init];
    verticalLine.coordinateMode = SCIAnnotationCoordinate_Absolute;
    verticalLine.x1 = SCIGeneric(9.0);
    verticalLine.y1 = SCIGeneric(4.0);
    verticalLine.verticalAlignment = SCIVerticalLineAnnotationAlignment_Bottom;
    verticalLine.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode: 0xFFA52A2A withThickness:2];
    [annotationCollection add:verticalLine];
    
    SCIVerticalLineAnnotation * verticalLine1 = [[SCIVerticalLineAnnotation alloc] init];
    verticalLine1.coordinateMode = SCIAnnotationCoordinate_Absolute;
    verticalLine1.x1 = SCIGeneric(9.5);
    verticalLine1.y1 = SCIGeneric(3.0);
    verticalLine1.verticalAlignment = SCIVerticalLineAnnotationAlignment_Bottom;
    verticalLine1.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode: 0xFFA52A2A withThickness:2];
    [annotationCollection add:verticalLine1];
    surface.annotations = annotationCollection;
}

-(SCILineAnnotationLabel *)buildLineAnnotationLabelWithText: (NSString*)text andAlignment:(SCILabelPlacement)labelPlacement andColor:(UIColor*)color andBackColor:(UIColor*)backColor{
    SCILineAnnotationLabel * lineAnnotationLabel = [SCILineAnnotationLabel new];
    lineAnnotationLabel.text = text;
    lineAnnotationLabel.style.backgroundColor = backColor;
    lineAnnotationLabel.style.labelPlacement = labelPlacement;
    lineAnnotationLabel.style.textStyle.color = color;
    return lineAnnotationLabel;
}

-(void)buildTextAnnotation:(SCIAnnotationCollection*)annotationCollection
                          :(double)x :(double)y
                          :(SCIHorizontalAnchorPoint)horizontalAnchorPoint
                          :(SCIVerticalAnchorPoint)verticalAnchorPoint
                          :(SCITextFormattingStyle*)textStyle
                          :(SCIAnnotationCoordinateMode)coordMode
                          :(NSString*)text :(uint)color{
    
    SCITextAnnotation * textAnnotation = [[SCITextAnnotation alloc] init];
    textAnnotation.coordinateMode = coordMode;
    textAnnotation.x1 = SCIGeneric(x);
    textAnnotation.y1 = SCIGeneric(y);
    textAnnotation.horizontalAnchorPoint = horizontalAnchorPoint;
    textAnnotation.verticalAnchorPoint = verticalAnchorPoint;
    textAnnotation.text = text;
    textAnnotation.style.textStyle = textStyle;
    textAnnotation.style.textColor = [UIColor fromARGBColorCode:color];
    textAnnotation.style.backgroundColor = [UIColor clearColor];
    [annotationCollection add:textAnnotation];
}

-(void)buildLineAnnotation:(SCIAnnotationCollection*)annotationCollection
                          :(double)x1 :(double)y1
                          :(double)x2 :(double)y2
                          :(uint)color :(double)strokeThickness{
    
    SCILineAnnotation * lineAnnotationRelative = [SCILineAnnotation new];
    lineAnnotationRelative.coordinateMode = SCIAnnotationCoordinate_Absolute;
    lineAnnotationRelative.x1 = SCIGeneric(x1);
    lineAnnotationRelative.y1 = SCIGeneric(y1);
    lineAnnotationRelative.x2 = SCIGeneric(x2);
    lineAnnotationRelative.y2 = SCIGeneric(y2);
    lineAnnotationRelative.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:strokeThickness];
    [annotationCollection add:lineAnnotationRelative];
}

-(void)buildBoxAnnotation:(SCIAnnotationCollection*)annotationCollection
                         :(double)x1 :(double)y1
                         :(double)x2 :(double)y2
                         :(SCIBrushStyle*)brush
                         :(SCISolidPenStyle*)pen{
    
    SCIBoxAnnotation * boxAnnotation = [[SCIBoxAnnotation alloc] init];
    boxAnnotation.coordinateMode = SCIAnnotationCoordinate_Absolute;
    boxAnnotation.x1 = SCIGeneric(x1);
    boxAnnotation.y1 = SCIGeneric(y1);
    boxAnnotation.x2 = SCIGeneric(x2);
    boxAnnotation.y2 = SCIGeneric(y2);
    boxAnnotation.style.fillBrush = brush;
    boxAnnotation.style.borderPen = pen;
    [annotationCollection add:boxAnnotation];
}

@end
