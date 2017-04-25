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

@synthesize sciChartSurfaceView;
@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData{
    [surface free];
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
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
    zpm.clipModeX = SCIZoomPanClipMode_None;
    
    SCIModifierGroup *gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[pzm, zem, zpm]];
    [surface setChartModifier: gm];
    
    [self setupAnnotations];
    
    [surface invalidateElement];
}

-(void) setupAnnotations {
    
    SCIAnnotationCollection *annotationCollection = [SCIAnnotationCollection new];
    
    // Watermark
    SCITextFormattingStyle *textStyle = [SCITextFormattingStyle new];
    [textStyle setFontSize:42];
    [self buildTextAnnotation:annotationCollection :0.5 :0.5 :SCIHorizontalAnchorPoint_Center :SCIVerticalAnchorPoint_Center :textStyle :SCIAnnotationCoordinate_Relative :@"Create \n Watermarks" :0x22FFFFFF];
    
    // Text annotations
    textStyle = [SCITextFormattingStyle new];
    [textStyle setFontSize:24];
    [self buildTextAnnotation:annotationCollection :0.3 :9.7 :SCIHorizontalAnchorPoint_Left :SCIVerticalAnchorPoint_Top  :textStyle :SCIAnnotationCoordinate_Absolute :@"Annotations are Easy!" :0xFFFFFFFF];
    
    textStyle = [SCITextFormattingStyle new];
    [textStyle setColor: [UIColor whiteColor]];
    [textStyle setFontSize:10];
    [self buildTextAnnotation:annotationCollection :1.0 :9.0 :SCIHorizontalAnchorPoint_Right :SCIVerticalAnchorPoint_Center  :textStyle :SCIAnnotationCoordinate_Absolute :@"You can create text" :0xFFFFFFFF];
    
    [self buildTextAnnotation:annotationCollection :5.0 :8.0 :SCIHorizontalAnchorPoint_Left :SCIVerticalAnchorPoint_Top  :textStyle :SCIAnnotationCoordinate_Absolute :@"Anchor left" :0xFFFFFFFF];
    [self buildTextAnnotation:annotationCollection :5.0 :8.0 :SCIHorizontalAnchorPoint_Right :SCIVerticalAnchorPoint_Top  :textStyle :SCIAnnotationCoordinate_Absolute :@"or anchor right" :0xFFFFFFFF];
    
    // Line and line arrow annotations
    textStyle = [SCITextFormattingStyle new];
    [textStyle setColor: [UIColor whiteColor]];
    [textStyle setFontSize:12];
    [self buildTextAnnotation:annotationCollection :0.3 :6.1 :SCIHorizontalAnchorPoint_Left :SCIVerticalAnchorPoint_Top  :textStyle :SCIAnnotationCoordinate_Absolute :@"Draw Lines \nAnnotations" :0xFFFFFFFF];
    [self buildLineAnnotation:annotationCollection :1.0 :4.0 :2.0 :6.0 :0xFF555555 :2.0];
    
    // Box annotations
    [self buildTextAnnotation:annotationCollection :3.5 :6.1 :SCIHorizontalAnchorPoint_Right :SCIVerticalAnchorPoint_Top  :textStyle :SCIAnnotationCoordinate_Absolute :@"Draw Boxes" :0xFFFFFFFF];
    
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
    
    // Box bound to screen position
    SCIBoxAnnotation * boxRed = [[SCIBoxAnnotation alloc] init];
    boxRed.xAxisId = @"xAxis";
    boxRed.yAxisId = @"yAxis";
    boxRed.coordinateMode = SCIAnnotationCoordinate_Relative;
    boxRed.x1 = SCIGeneric(0.25);
    boxRed.y1 = SCIGeneric(0.25);
    boxRed.x2 = SCIGeneric(0.5);
    boxRed.y2 = SCIGeneric(0.5);
    boxRed.isEditable = NO;
    boxRed.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x30FF1010];
    
    // line bound to position on chart
    SCILineAnnotation * lineAnnotationAbsolute = [[SCILineAnnotation alloc] init];
    lineAnnotationAbsolute.xAxisId = @"xAxis";
    lineAnnotationAbsolute.yAxisId = @"yAxis";
    lineAnnotationAbsolute.coordinateMode = SCIAnnotationCoordinate_Absolute;
    lineAnnotationAbsolute.x1 = SCIGeneric(2);
    lineAnnotationAbsolute.y1 = SCIGeneric(2);
    lineAnnotationAbsolute.x2 = SCIGeneric(5);
    lineAnnotationAbsolute.y2 = SCIGeneric(6);
    lineAnnotationAbsolute.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00FF00 withThickness:2];
    
    // line with X position bound to chart and Y to screen
    SCILineAnnotation * lineAnnotationAbsoluteX = [[SCILineAnnotation alloc] init];
    lineAnnotationAbsoluteX.xAxisId = @"xAxis";
    lineAnnotationAbsoluteX.yAxisId = @"yAxis";
    lineAnnotationAbsoluteX.coordinateMode = SCIAnnotationCoordinate_RelativeY;
    lineAnnotationAbsoluteX.x1 = SCIGeneric(1);
    lineAnnotationAbsoluteX.y1 = SCIGeneric(0.05);
    lineAnnotationAbsoluteX.x2 = SCIGeneric(1);
    lineAnnotationAbsoluteX.y2 = SCIGeneric(0.95);
    lineAnnotationAbsoluteX.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF0000 withThickness:2];
    
    // axis marker bound to chart surface
    SCIVerticalLineAnnotation * xMarker = [[SCIVerticalLineAnnotation alloc] init];
    xMarker.coordinateMode = SCIAnnotationCoordinate_Absolute;
    xMarker.xAxisId = @"xAxis";
    xMarker.yAxisId = @"yAxis";
    xMarker.x1 = SCIGeneric(2.5);
    xMarker.y1 = SCIGeneric(5.0);
    xMarker.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xAF00FFFF withThickness:1];
    //    xMarker.style. = [UIColor fromABGRColorCode:0xFF30CFCF];
    //    xMarker.style.textStyle.transform = CGAffineTransformMakeRotation(M_PI_2);
    
    // axis marker bound to screen
    SCIHorizontalLineAnnotation * yMarker = [[SCIHorizontalLineAnnotation alloc] init];
    yMarker.coordinateMode = SCIAnnotationCoordinate_Relative;
    yMarker.xAxisId = @"xAxis";
    yMarker.yAxisId = @"yAxis";
    yMarker.x1 = SCIGeneric(0.5);
    yMarker.y1 = SCIGeneric(0.5);
    yMarker.coordinateMode = SCIAnnotationCoordinate_Absolute;
    yMarker.x1 = SCIGeneric(2.5);
    yMarker.y1 = SCIGeneric(3.0);
    yMarker.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xA0FF0000 withThickness:1];
    //    yMarker.style.backgroundColor = [UIColor fromABGRColorCode:0xFFA00000];
    //    yMarker.style.textStyle.fontSize = 14;
    //    yMarker.style.textStyle.fontName = @"Helvetica-Bold";
    //    yMarker.style.textStyle.color = [UIColor whiteColor];
    // axis marker annotation text is formated by axis as cursor text
    [surface.yAxes getAxisById:@"yAxis"].cursorTextFormatting = @"%.2f";
    
    [surface setAnnotation: annotationCollection];
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
    
    [annotationCollection addItem:textAnnotation];
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
    
    [annotationCollection addItem:lineAnnotationRelative];
}

-(void)buildBoxAnnotation:(SCIAnnotationCollection*)annotationCollection
                         :(double)x1 :(double)y1
                         :(double)x2 :(double)y2
                         :(id<SCIBrush2DProtocol>)brush
                         :(SCISolidPenStyle*)pen{
    
    SCIBoxAnnotation * boxAnnotation = [[SCIBoxAnnotation alloc] init];
    boxAnnotation.coordinateMode = SCIAnnotationCoordinate_Absolute;
    boxAnnotation.x1 = SCIGeneric(x1);
    boxAnnotation.y1 = SCIGeneric(y1);
    boxAnnotation.x2 = SCIGeneric(x2);
    boxAnnotation.y2 = SCIGeneric(y2);
    boxAnnotation.style.fillBrush = brush;
    boxAnnotation.style.borderPen = pen;
    
    [annotationCollection addItem:boxAnnotation];
}

@end
