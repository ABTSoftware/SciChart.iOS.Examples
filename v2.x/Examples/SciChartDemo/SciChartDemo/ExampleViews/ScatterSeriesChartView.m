//
//  ScatterSeriesViewController.m
//  SciChartDemo
//
//  Created by Admin on 27.01.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ScatterSeriesChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation ScatterSeriesChartView

@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [[SCIChartSurface alloc]initWithFrame:frame];
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIRenderableSeriesProtocol> rSeries1 = [self getScatterRenderableSeriesWithDetalization:3 Color:0xFFffeb01 Negative:NO];
    id<SCIRenderableSeriesProtocol> rSeries2 = [self getScatterRenderableSeriesWithDetalization:6 Color:0xFFffa300 Negative:NO];
    id<SCIRenderableSeriesProtocol> rSeries3 = [self getScatterRenderableSeriesWithDetalization:3 Color:0xFFff6501 Negative:YES];
    id<SCIRenderableSeriesProtocol> rSeries4 = [self getScatterRenderableSeriesWithDetalization:6 Color:0xFFffa300 Negative:YES];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    SCICursorModifier * cursorModifier = [[SCICursorModifier alloc] init];
    cursorModifier.style.hitTestMode = SCIHitTest_Point;
    cursorModifier.style.colorMode = SCITooltipColorMode_SeriesColorToDataView;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries1];
        [surface.renderableSeries add:rSeries2];
        [surface.renderableSeries add:rSeries3];
        [surface.renderableSeries add:rSeries4];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], cursorModifier]];
    }];
}

- (id<SCIRenderableSeriesProtocol>) getScatterRenderableSeriesWithDetalization:(int)pointMarkerDetalization Color:(unsigned int) color Negative:(BOOL) negative {
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Double];
    dataSeries.seriesName = (pointMarkerDetalization == 6)
        ? negative ? @"Negative Hex" : @"Positive Hex"
        : negative ? @"Negative" : @"Positive";
    
    for (int i = 0; i < 200; i++) {
        double time = i < 100 ? arc4random_uniform((double)i + 10) : arc4random_uniform(200 - (double)i + 10);
        double y = negative ? -time * time * time : time * time * time ;
        
        [dataSeries appendX:SCIGeneric(i) Y:SCIGeneric(y)];
    }
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:color];
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFFFFF withThickness:0.1];
    ellipsePointMarker.detalization = pointMarkerDetalization;
    ellipsePointMarker.height = 6;
    ellipsePointMarker.width = 6;
    
    SCIXyScatterRenderableSeries * rSeries = [SCIXyScatterRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.pointMarker = ellipsePointMarker;
    
    SCIWaveRenderableSeriesAnimation * animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [rSeries addAnimation:animation];
    
    return rSeries;
}

@end
