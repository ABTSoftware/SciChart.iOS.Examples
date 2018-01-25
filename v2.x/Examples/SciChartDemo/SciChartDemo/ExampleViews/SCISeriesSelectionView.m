//
//  LineChartViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 1/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "SCISeriesSelectionView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

const double SeriesPointCount = 50;
const double SeriesCount = 80;

@implementation SeriesSelectionView{
    UIColor *initialColor;
}


@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
        surface = view;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        initialColor = [UIColor blueColor];
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
}

-(void) addAxes{
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setAxisId: @"yLeftAxis"];
    [axis setAxisAlignment:SCIAxisAlignment_Left];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setAxisId: @"yRightAxis"];
    [axis setAxisAlignment:SCIAxisAlignment_Right];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setAutoRange:SCIAutoRange_Always];
    [surface.xAxes add:axis];
}

-(void) addModifiers{
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    [xDragModifier setModifierName:@"XAxis DragModifier"];
    
    SCIYAxisDragModifier * yDragModifierLeft = [SCIYAxisDragModifier new];
    yDragModifierLeft.axisId = @"yLeftAxis";
    yDragModifierLeft.dragMode = SCIAxisDragMode_Pan;
    [yDragModifierLeft setModifierName:@"YAxis DragModifier"];
    
    SCIYAxisDragModifier * yDragModifierRight = [SCIYAxisDragModifier new];
    yDragModifierRight.axisId = @"yRightAxis";
    yDragModifierRight.dragMode = SCIAxisDragMode_Pan;
    [yDragModifierRight setModifierName:@"YAxis DragModifier"];
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    rollover.style.tooltipSize = CGSizeMake(200, NAN);
    [rollover setModifierName:@"Rollover Modifier"];
    
    SCISeriesSelectionModifier * selectionModifier = [[SCISeriesSelectionModifier alloc] init];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifierLeft, yDragModifierRight, pzm, zem, rollover, selectionModifier]];
    surface.chartModifiers = gm;
}

-(void) initializeSurfaceRenderableSeries{
    for (int i=0; i<SeriesCount;i++) {
        SCIAxisAlignment axisAlign = i%2 == 0 ? SCIAxisAlignment_Left: SCIAxisAlignment_Right;
        
        [self generateDataSeries:axisAlign andIndex:i];
        
        CGFloat red;
        CGFloat green;
        CGFloat blue;
        CGFloat alpha;
        
        [initialColor getRed:&red green:&green blue:&blue alpha:&alpha];
        
        CGFloat newR = red == 1.0 ? 1.0 : red + 0.0125;
        CGFloat newB = blue == 0.0 ? 0.0 : blue - 0.0125;
        
        initialColor = [[UIColor alloc]initWithRed:newR green:green blue:newB alpha:alpha];
    }
    
    [surface invalidateElement];
}

-(void) generateDataSeries:(SCIAxisAlignment)axisAlignment andIndex:(int)index{
    SCIXyDataSeries * lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [lineDataSeries setSeriesName: [[NSString alloc]initWithFormat:@"Series %i", index]];
    
    double gradient = axisAlignment == SCIAxisAlignment_Right ? index: -index;
    double start = axisAlignment == SCIAxisAlignment_Right ? 0.0 : 14000;
 
    [DataManager getStraightLines:lineDataSeries :gradient :start :SeriesPointCount];
    SCIFastLineRenderableSeries *lineRenderableSeries = [[SCIFastLineRenderableSeries alloc]init];
    [lineRenderableSeries setDataSeries:lineDataSeries];
    [lineRenderableSeries setYAxisId:axisAlignment == SCIAxisAlignment_Left ? @"yLeftAxis" : @"yRightAxis" ];
    [lineRenderableSeries setXAxisId:@"xAxis"];
    [lineRenderableSeries setStrokeStyle: [[SCISolidPenStyle alloc]initWithColor:initialColor withThickness:1.0]];
    
    SCIDrawLineRenderableSeriesAnimation *animation = [[SCIDrawLineRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [lineRenderableSeries addAnimation:animation];
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setFillStyle:[[SCISolidBrushStyle alloc] initWithColorCode:0xFFFF00DC]];
    [ellipsePointMarker setStrokeStyle:[[SCISolidPenStyle alloc] initWithColor: [UIColor whiteColor] withThickness:1.0]];
    [ellipsePointMarker setHeight:10];
    [ellipsePointMarker setWidth:10];
    
    lineRenderableSeries.selectedStyle = lineRenderableSeries.style;
    [lineRenderableSeries.selectedStyle setPointMarker: ellipsePointMarker];
    [lineRenderableSeries.hitTestProvider setHitTestMode:SCIHitTest_Interpolate];
    
    [surface.renderableSeries add:lineRenderableSeries];
    [surface invalidateElement];
}

@end
