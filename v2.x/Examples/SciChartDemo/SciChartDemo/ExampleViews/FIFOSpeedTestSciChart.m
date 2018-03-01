//
//  ECGChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 21.03.16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "FIFOSpeedTestSciChart.h"
#import <SciChart/SciChart.h>
#include <math.h>
#import "RandomWalkGenerator.h"

static int const PointsCount = 1000;

@implementation FIFOSpeedTestSciChart {
    NSTimer * _timer;

    SCIXyDataSeries * _dataSeries;
    RandomWalkGenerator * _randomWalk;
    int _xCount;
}

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

-(void) initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;

    _randomWalk = [RandomWalkGenerator new];
    DoubleSeries * doubleSeries = [_randomWalk getRandomWalkSeries:PointsCount];
    
    _dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    _dataSeries.fifoCapacity = PointsCount;
    [_dataSeries appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:PointsCount];
    _xCount += PointsCount;
    
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = _dataSeries;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.002 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
}

- (void)updateData:(NSTimer *)timer {
    [_dataSeries appendX:SCIGeneric(_xCount) Y:SCIGeneric([_randomWalk next])];
    _xCount++;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if (newWindow == nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
