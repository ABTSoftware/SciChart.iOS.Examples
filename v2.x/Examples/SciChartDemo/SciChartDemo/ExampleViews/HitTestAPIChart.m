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
#import "ArrayUtil.h"

static int const Count = 10;

@implementation HitTestAPIChart {
    CGPoint _touchPoint;
    SCIHitTestInfo _hitTestInfo;
    UIAlertController * _alertPopup;
}

@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:surface];
        NSDictionary * layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
        
        UITapGestureRecognizer * singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [surface addGestureRecognizer:singleFingerTap];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.axisAlignment = SCIAxisAlignment_Left;
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)];
    
    double xData[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
    double yData[] = {0, 0.1, 0.3, 0.5, 0.4, 0.35, 0.3, 0.25, 0.2, 0.1, 0.05};
    
    SCIXyDataSeries * dataSeries0 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries0.seriesName = @"Line Series";
    [dataSeries0 appendRangeX:SCIGeneric((double *)xData) Y:SCIGeneric((double *)yData) Count:Count];
    
    double tempArray[Count];
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries1.seriesName = @"Mountain Series";
    [dataSeries1 appendRangeX:SCIGeneric((double *)xData) Y:SCIGeneric([ArrayUtil selectFrom:yData to:tempArray size:Count selector:^(double arg) {
        return arg * 0.7;
    }]) Count:Count];
    
    SCIXyDataSeries * dataSeries2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries2.seriesName = @"Column Series";
    [dataSeries2 appendRangeX:SCIGeneric((double *)xData) Y:SCIGeneric([ArrayUtil selectFrom:yData to:tempArray size:Count selector:^(double arg) {
        return arg * 0.5;
    }]) Count:Count];
    
    double highArray[Count];
    double lowArray[Count];
    double closeArray[Count];
    SCIOhlcDataSeries * dataSeries3 = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries3.seriesName = @"CandleStick Series";
    [dataSeries3 appendRangeX:SCIGeneric((double *)xData) Open:SCIGeneric([ArrayUtil selectFrom:yData to:tempArray size:Count selector:^(double arg) {
        return arg + 0.5;
    }]) High:SCIGeneric([ArrayUtil selectFrom:yData to:highArray size:Count selector:^(double arg) {
        return arg + 1;
    }]) Low:SCIGeneric([ArrayUtil selectFrom:yData to:lowArray size:Count selector:^(double arg) {
        return arg + 0.3;
    }]) Close:SCIGeneric([ArrayUtil selectFrom:yData to:closeArray size:Count selector:^(double arg) {
        return arg + 0.7;
    }]) Count:Count];
    
    SCIEllipsePointMarker * pointMarker = [SCIEllipsePointMarker new];
    pointMarker.width = 30;
    pointMarker.height = 30;
    pointMarker.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0xFF4682B4];
    pointMarker.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFFE6E6FA withThickness:2];
    
    SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = dataSeries0;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4682B4 withThickness:2];
    lineSeries.pointMarker = pointMarker;
    
    SCIFastMountainRenderableSeries * mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = dataSeries1;
    mountainSeries.areaStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0xFFB0C4DE];
    mountainSeries.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF4682B4 withThickness:2];
    
    SCIFastColumnRenderableSeries * columnSeries = [SCIFastColumnRenderableSeries new];
    columnSeries.dataSeries = dataSeries2;
    
    SCIFastCandlestickRenderableSeries * candlestickSeries = [SCIFastCandlestickRenderableSeries new];
    candlestickSeries.dataSeries = dataSeries3;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:lineSeries];
        [surface.renderableSeries add:mountainSeries];
        [surface.renderableSeries add:columnSeries];
        [surface.renderableSeries add:candlestickSeries];

        [lineSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [mountainSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [columnSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [candlestickSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:recognizer.view.superview];
    
    _touchPoint = [surface.renderSurface pointInChartFrame:location];
    NSMutableString * resultString = [NSMutableString stringWithFormat:@"Touch at: (%.0f, %.0f)",_touchPoint.x, _touchPoint.y];
    
    for (int i = 0; i < surface.renderableSeries.count; i++) {
        SCIRenderableSeriesBase * rSeries = (SCIRenderableSeriesBase *)[surface.renderableSeries itemAt:i];
        _hitTestInfo = [rSeries.hitTestProvider hitTestAtX:_touchPoint.x Y:_touchPoint.y Radius:30 onData:rSeries.currentRenderPassData];
        
        [resultString appendString:[NSString stringWithFormat:@"\n%@ - %@",rSeries.dataSeries.seriesName, _hitTestInfo.match ? @"YES" : @"NO"]];
    }
    
    _alertPopup = [UIAlertController alertControllerWithTitle:@"HitTestInfo" message:resultString preferredStyle:UIAlertControllerStyleAlert];
    [self.window.rootViewController presentViewController:_alertPopup animated:YES completion:nil];
   
    [self performSelector:@selector(dismissAlert) withObject:_alertPopup afterDelay:1];
}

- (void)dismissAlert {
    [_alertPopup dismissViewControllerAnimated:YES completion:nil];
}

@end
