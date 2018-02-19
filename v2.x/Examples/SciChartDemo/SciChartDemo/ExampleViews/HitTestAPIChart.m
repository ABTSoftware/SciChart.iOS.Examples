//
//  HitTestAPIChart.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/3/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "HitTestAPIChart.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation HitTestAPIChart{
    CGPoint touchPoint;
    SCIHitTestInfo hitTestInfo;
    UIAlertController * alertPopup;
}


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
        
        UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(handleSingleTap:)];
        [surface addGestureRecognizer:singleFingerTap];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    
    
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
}

-(void) addAxes{
    id<SCIAxis2DProtocol> axis = [SCINumericAxis new];
    axis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)];
    axis.axisAlignment = SCIAxisAlignment_Left;
    [surface.yAxes add:axis];
    
    [surface.xAxes add:[SCINumericAxis new]];
}

-(void) addModifiers{
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    [pzm setModifierName:@"PinchZoom Modifier"];
    
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    [zem setModifierName:@"ZoomExtents Modifier"];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[pzm, zem]];
    surface.chartModifiers = gm;
}

-(void) initializeSurfaceRenderableSeries{
    NSArray * xData = @[@0, @1,   @2,   @3,   @4,   @5,    @6,   @7,    @8,   @9];
    NSArray * yData = @[@0, @0.1, @0.3, @0.5, @0.4, @0.35, @0.3, @0.25, @0.2, @0.1];
    
    SCIXyDataSeries * dataSeries0 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [dataSeries0 setSeriesName:@"Line Series"];
    [dataSeries0 appendRangeX:xData Y:yData];
    [self addLineRenderSeries:dataSeries0];
    
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [dataSeries1 setSeriesName:@"Mountain Series"];
    NSMutableArray * yData1 = [NSMutableArray new];
    for (int i=0; i<yData.count; i++) {
        double value =[[yData objectAtIndex:i] doubleValue]*0.7;
        [yData1 addObject:[NSNumber numberWithFloat:value]];
    }
    [dataSeries1 appendRangeX:xData Y:yData1];
    [self addMountainRenderSeries:dataSeries1];
    
    SCIXyDataSeries * dataSeries2 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [dataSeries2 setSeriesName:@"Column Series"];
    NSMutableArray * yData2 = [NSMutableArray new];
    for (int i=0; i<yData.count; i++) {
        double value =[[yData objectAtIndex:i] doubleValue]*0.5;
        [yData2 addObject:[NSNumber numberWithFloat:value]];
    }
    [dataSeries2 appendRangeX:xData Y:yData2];
    [self addColumnRenderSeries:dataSeries2];
    
    
    SCIOhlcDataSeries * dataSeries3 = [[SCIOhlcDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [dataSeries3 setSeriesName:@"Candlestick Series"];
    
    NSMutableArray * open = [NSMutableArray new];
    for (int i=0; i<yData.count; i++) {
        double value =[[yData objectAtIndex:i] doubleValue] + 0.5;
        [open addObject:[NSNumber numberWithDouble:value]];
    }
    NSMutableArray * high = [NSMutableArray new];
    for (int i=0; i<yData.count; i++) {
        double value =[[yData objectAtIndex:i] doubleValue] + 1.0;
        [high addObject:[NSNumber numberWithDouble:value]];
    }
    NSMutableArray * low = [NSMutableArray new];
    for (int i=0; i<yData.count; i++) {
        double value =[[yData objectAtIndex:i] doubleValue] + 0.3;
        [low addObject:[NSNumber numberWithDouble:value]];
    }
    NSMutableArray * close = [NSMutableArray new];
    for (int i=0; i<yData.count; i++) {
        double value =[[yData objectAtIndex:i] doubleValue] + 0.7;
        [close addObject:[NSNumber numberWithDouble:value]];
    }
    [dataSeries3 appendRangeX:xData Open:open High:high Low:low Close:close];
    [self addCandleRenderSeries:dataSeries3];
    
}

-(void)addLineRenderSeries:(SCIXyDataSeries*)data{
    SCIFastLineRenderableSeries * lineRenderSeries = [SCIFastLineRenderableSeries new];
    lineRenderSeries.dataSeries = data;
    
    SCISweepRenderableSeriesAnimation *animation = [[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [lineRenderSeries addAnimation:animation];
    
    SCIEllipsePointMarker * ellipsePointMarker = [SCIEllipsePointMarker new];
    ellipsePointMarker.width = 30;
    ellipsePointMarker.height = 30;
    ellipsePointMarker.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0xFF4682B4];
    ellipsePointMarker.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFFE6E6FA withThickness:2];
    
    lineRenderSeries.pointMarker = ellipsePointMarker;
    
    [surface.renderableSeries add:lineRenderSeries];
}

-(void)addMountainRenderSeries:(SCIXyDataSeries*)data{
    SCIFastMountainRenderableSeries * mountainRenderSeries = [SCIFastMountainRenderableSeries new];
    mountainRenderSeries.dataSeries = data;
    mountainRenderSeries.areaStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0xFFB0C4DE];
    mountainRenderSeries.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF4682B4 withThickness:2];
    
    SCIScaleRenderableSeriesAnimation *animation = [[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [mountainRenderSeries addAnimation:animation];
    
    [surface.renderableSeries add:mountainRenderSeries];
}

-(void)addColumnRenderSeries:(SCIXyDataSeries*)data{
    SCIFastColumnRenderableSeries * columnRenderSeries = [SCIFastColumnRenderableSeries new];
    columnRenderSeries.dataSeries = data;
    
    SCIScaleRenderableSeriesAnimation *animation = [[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [columnRenderSeries addAnimation:animation];
    
    [surface.renderableSeries add:columnRenderSeries];
}

-(void)addCandleRenderSeries:(SCIOhlcDataSeries*)data{
    SCIFastCandlestickRenderableSeries * candleRenderSeries = [SCIFastCandlestickRenderableSeries new];
    candleRenderSeries.dataSeries = data;
    
    SCIScaleRenderableSeriesAnimation *animation = [[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [candleRenderSeries addAnimation:animation];
    
    [surface.renderableSeries add:candleRenderSeries];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    touchPoint = [surface.renderSurface pointInChartFrame:location];
    NSMutableString * resultString = [NSMutableString stringWithFormat:@"Touch at: (%.0f, %.0f)",touchPoint.x, touchPoint.y];
    
    for (unsigned int i = 0; i<surface.renderableSeries.count; i++) {
        SCIRenderableSeriesBase * renderSeries = (SCIRenderableSeriesBase*)[surface.renderableSeries itemAt:i];
        hitTestInfo = [[renderSeries hitTestProvider] hitTestAtX:touchPoint.x Y:touchPoint.y Radius:30 onData:renderSeries.currentRenderPassData];
        
        [resultString appendString: [NSString stringWithFormat:@"\n%@ - %@",renderSeries.dataSeries.seriesName, hitTestInfo.match ? @"YES" : @"NO"]];
    }
    
    alertPopup = [UIAlertController alertControllerWithTitle:@"HitTestInfo" message:resultString preferredStyle:UIAlertControllerStyleAlert];
    [self.window.rootViewController presentViewController:alertPopup animated:YES completion:nil];
    [self timedAlert];
}

- (void)timedAlert {
    [self performSelector:@selector(dismissAlert) withObject:alertPopup afterDelay:4];
}

- (void)dismissAlert {
    [alertPopup dismissViewControllerAnimated:YES completion:nil];
}

@end
