//
//  SCDSeriesAppendingTestSciChart.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 6/17/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "PerformanceDemoView.h"
#import <SciChart/SciChart.h>
#import "RandomUtil.h"
#import "MovingAverage.h"

static int const MaLow = 200;
static int const MaHigh = 1000;
static double const TimeInterval = 10.0;
static int const MaxPointCount = 1000000;
static int const AppendPointsCount = 100;

@implementation PerformanceDemoView {
    MovingAverage * _maLow;
    MovingAverage * _maHigh;
    
    NSTimer * _timer;
    BOOL _isRunning;

    UILabel *_generalCountOfPoints;
}

@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:surface];
        
        NSDictionary * layout = @{@"SciChart":self.surface};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        _generalCountOfPoints = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, .0, .0)];
        _generalCountOfPoints.font = [UIFont systemFontOfSize:14.f];
        _generalCountOfPoints.textColor = [UIColor whiteColor];
        
        [self addSubview:_generalCountOfPoints];
        
        [self initializeSurfaceData];
    }
    return self;
}

- (void)initializeSurfaceData {
    _maLow = [[MovingAverage alloc] initWithLength:MaLow];
    _maHigh = [[MovingAverage alloc] initWithLength:MaHigh];
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    
    SCIFastLineRenderableSeries * rs1 = [SCIFastLineRenderableSeries new];
    rs1.dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Float];
    rs1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF4083B7 withThickness:1];
    
    SCIFastLineRenderableSeries * rs2 = [SCIFastLineRenderableSeries new];
    rs2.dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Float];
    rs2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFFA500 withThickness:1];
    
    SCIFastLineRenderableSeries * rs3 = [SCIFastLineRenderableSeries new];
    rs3.dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Float];
    rs3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFE13219 withThickness:1];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rs1];
        [surface.renderableSeries add:rs2];
        [surface.renderableSeries add:rs3];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval / 1000.0 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
    _isRunning = YES;
}

- (void)updateData:(NSTimer *)timer {
    if (!_isRunning || [self getPointsCount] > MaxPointCount) {
        [self updateAutoRangeBehavior:NO];
        [self updateModifiers:YES];
        [_timer invalidate];
        _timer = nil;
        return;
    }
    int xValues[AppendPointsCount];
    float firstYValues[AppendPointsCount];
    float secondYValues[AppendPointsCount];
    float thirdYValues[AppendPointsCount];
    
    SCIXyDataSeries * mainSeries = (SCIXyDataSeries *)[surface.renderableSeries itemAt:0].dataSeries;
    SCIXyDataSeries * maLowSeries = (SCIXyDataSeries *)[surface.renderableSeries itemAt:1].dataSeries;
    SCIXyDataSeries * maHighSeries = (SCIXyDataSeries *)[surface.renderableSeries itemAt:2].dataSeries;
    
    int xValue = mainSeries.count > 0 ? SCIGenericInt([mainSeries.xValues valueAt:mainSeries.count - 1]) : 0;
    float yValue = mainSeries.count > 0 ? SCIGenericFloat([mainSeries.yValues valueAt:mainSeries.count - 1]) : 10;
    for (int i = 0; i < AppendPointsCount; i++) {
        xValue++;
        yValue = yValue + randf(0.0, 1.0) - 0.5;
        xValues[i] = xValue;
        firstYValues[i] = yValue;
        secondYValues[i] = [_maLow push:yValue].current;
        thirdYValues[i] = [_maHigh push:yValue].current;
    }
    
    [mainSeries appendRangeX:SCIGeneric((int *)xValues) Y:SCIGeneric((float *)firstYValues) Count:AppendPointsCount];
    [maLowSeries appendRangeX:SCIGeneric((int *)xValues) Y:SCIGeneric((float *)secondYValues) Count:AppendPointsCount];
    [maHighSeries appendRangeX:SCIGeneric((int *)xValues) Y:SCIGeneric((float *)thirdYValues) Count:AppendPointsCount];
    
    long count = mainSeries.count + maLowSeries.count + maHighSeries.count;
    _generalCountOfPoints.text = [NSString stringWithFormat:@"Amount of points: %li", count];
    [_generalCountOfPoints sizeToFit];
}

- (int)getPointsCount {
    SCIRenderableSeriesCollection * rsCollection = [surface renderableSeries];
    
    int result = 0;
    for (int i = 0; i < rsCollection.count; i++) {
        result += [rsCollection itemAt:i].dataSeries.count;
    }
    return result;
}

- (void)updateAutoRangeBehavior:(BOOL)isEnabled {
    id<SCIAxis2DProtocol> xAxis = [surface.xAxes itemAt:0];
    id<SCIAxis2DProtocol> yAxis = [surface.yAxes itemAt:0];

    SCIAutoRange autoRangeMode = isEnabled ? SCIAutoRange_Always : SCIAutoRange_Never;
    
    xAxis.autoRange = autoRangeMode;
    yAxis.autoRange = autoRangeMode;
}

- (void) updateModifiers:(BOOL)isEnabled {
    SCIChartModifierCollection * modifiers = surface.chartModifiers;
    for (int i = 0; i < modifiers.count; i++) {
        [modifiers itemAt:i].isEnabled = isEnabled;
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
