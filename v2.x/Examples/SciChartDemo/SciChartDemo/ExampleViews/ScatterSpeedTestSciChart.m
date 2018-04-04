//
//  ScatterSpeedTestSciChart.m
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/20/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <SciChart/SciChart.h>
#import "ScatterSpeedTestSciChart.h"
#import "BrownianMotionGenerator.h"
#import "RandomUtil.h"

static int const PointsCount = 20000;

@implementation ScatterSpeedTestSciChart{
    NSTimer * _timer;
    SCIXyDataSeries * _scatterDataSeries;
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
    }
    
    return self;
}

- (void)initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    
    DoubleSeries * doubleSeries = [BrownianMotionGenerator getRandomDataWithMin:-50 max:50 count:PointsCount];
    _scatterDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _scatterDataSeries.acceptUnsortedData = YES;
    [_scatterDataSeries appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];

    SCICoreGraphicsPointMarker * marker = [SCICoreGraphicsPointMarker new];
    marker.width = 6;
    marker.height = 6;
    
    SCIXyScatterRenderableSeries * rSeries = [SCIXyScatterRenderableSeries new];
    rSeries.dataSeries = _scatterDataSeries;
    rSeries.style.pointMarker = marker;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.002 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
}

- (void)updateData:(NSTimer *)timer {
    for (int i = 0; i < _scatterDataSeries.count; i++){
        SCIGenericType x = [[_scatterDataSeries xValues] valueAt:i];
        SCIGenericType y = [[_scatterDataSeries yValues] valueAt:i];
        
        [_scatterDataSeries updateAt:i X:SCIGeneric(SCIGenericDouble(x) + randf(-1.0, 1.0)) Y:SCIGeneric(SCIGenericDouble(y) + randf(-0.5, 0.5))];
    }
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if (newWindow == nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
