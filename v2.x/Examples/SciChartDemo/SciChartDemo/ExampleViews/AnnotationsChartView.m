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

-(void) setupAnnotations {
    // Box bound to chart surface
    SCIBoxAnnotation * boxBlue = [[SCIBoxAnnotation alloc] init];
    boxBlue.xAxisId = @"xAxis";
    boxBlue.yAxisId = @"yAxis";
    boxBlue.coordinateMode = SCIAnnotationCoordinate_Absolute;
    boxBlue.x1 = SCIGeneric(4);
    boxBlue.y1 = SCIGeneric(8);
    boxBlue.x2 = SCIGeneric(7);
    boxBlue.y2 = SCIGeneric(4);
    boxBlue.isEnabled = NO;
    boxBlue.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x300070FF];
    
    // Box bound to screen position
    SCIBoxAnnotation * boxRed = [[SCIBoxAnnotation alloc] init];
    boxRed.xAxisId = @"xAxis";
    boxRed.yAxisId = @"yAxis";
    boxRed.coordinateMode = SCIAnnotationCoordinate_Relative;
    boxRed.x1 = SCIGeneric(0.25);
    boxRed.y1 = SCIGeneric(0.25);
    boxRed.x2 = SCIGeneric(0.5);
    boxRed.y2 = SCIGeneric(0.5);
    boxRed.isEnabled = NO;
    boxRed.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x30FF1010];
    
    // line bound to position on screen
    SCILineAnnotation * lineAnnotationRelative = [[SCILineAnnotation alloc] init];
    lineAnnotationRelative.xAxisId = @"xAxis";
    lineAnnotationRelative.yAxisId = @"yAxis";
    lineAnnotationRelative.coordinateMode = SCIAnnotationCoordinate_Relative;
    lineAnnotationRelative.x1 = SCIGeneric(0.1);
    lineAnnotationRelative.y1 = SCIGeneric(0.1);
    lineAnnotationRelative.x2 = SCIGeneric(0.9);
    lineAnnotationRelative.y2 = SCIGeneric(0.1);
    lineAnnotationRelative.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF0000FF withThickness:2];
    
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
    
    SCITextAnnotation * textAnnotation = [[SCITextAnnotation alloc] init];
    textAnnotation.xAxisId = @"xAxis";
    textAnnotation.yAxisId = @"yAxis";
    textAnnotation.coordinateMode = SCIAnnotationCoordinate_Relative;
    textAnnotation.x1 = SCIGeneric(0.7);
    textAnnotation.y1 = SCIGeneric(0.5);
    textAnnotation.text = @"Red box: position bound to screen\n"
    "Blue box: position bound to chart surface\n"
    "Red line: bound to screen\n"
    "Green line: bound to surface\n"
    "Blue line: X bound to chart, Y bound to screen\n"
    "All annotations but axis markers are interactive";
    textAnnotation.style.textStyle.fontSize = 18;
    textAnnotation.style.textColor = [UIColor whiteColor];
    textAnnotation.style.backgroundColor = [UIColor clearColor];
    
    UILabel* customAnnotationContent = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 20)];
    customAnnotationContent.backgroundColor = [UIColor brownColor];
    customAnnotationContent.text = @"Custom Annotation";
    
    SCICustomAnnotation* customAnnotation = [[SCICustomAnnotation alloc]init];
    customAnnotation.coordinateMode = SCIAnnotationCoordinate_Relative;
    customAnnotation.xAxisId = @"xAxis";
    customAnnotation.yAxisId = @"yAxis";
    customAnnotation.x1 = SCIGeneric(0.1);
    customAnnotation.y1 = SCIGeneric(0.5);
    customAnnotation.x2 = SCIGeneric(0.5);
    customAnnotation.y2 = SCIGeneric(0.7);
    customAnnotation.contentView = customAnnotationContent;

    
    SCIAnnotationCollection * annotationGroup = [[SCIAnnotationCollection alloc]initWithChildAnnotations:@[
                                                                                                 lineAnnotationRelative, lineAnnotationAbsolute, lineAnnotationAbsoluteX,
                                                                                                 
                                                                                                 xMarker, yMarker, customAnnotation]];
    [surface setAnnotation:annotationGroup];
}

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
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setAxisId: @"yAxis"];
    [axis setAxisAlignment:SCIAxisAlignment_Left];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setAxisId: @"xAxis"];
    [axis setAxisAlignment:SCIAxisAlignment_Top];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    [xDragModifier setAxisId: @"xAxis"];
    [xDragModifier setDragMode: SCIAxisDragMode_Scale];
    [xDragModifier setClipModeX: SCIZoomPanClipMode_None];
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    [yDragModifier setAxisId: @"yAxis"];
    [yDragModifier setDragMode: SCIAxisDragMode_Pan];
    
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    zpm.clipModeX = SCIZoomPanClipMode_None;
    
    [zpm setModifierName:@"PanZoom Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [yDragModifier setModifierName:@"YAxis Drag Modifier"];
    [xDragModifier setModifierName:@"XAxis Drag Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, zpm]];
    [surface setChartModifier: gm];
    
    [self setupAnnotations];
    
    [surface invalidateElement];
}
@end
