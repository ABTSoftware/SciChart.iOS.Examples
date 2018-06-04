//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PerformanceDemoView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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

    // needed to update Y position of annotation;
    double _maxYValue;
    SCITextAnnotation * _annotation;
}

- (void)commonInit {
    _maLow = [[MovingAverage alloc] initWithLength:MaLow];
    _maHigh = [[MovingAverage alloc] initWithLength:MaHigh];
    
    __weak typeof(self) wSelf = self;
    self.playCallback = ^() {
        [wSelf updateIsRunningWith:YES];
    };
    self.pauseCallback = ^() {
        [wSelf updateIsRunningWith:NO];
    };
    self.stopCallback = ^() {
        [wSelf updateIsRunningWith:NO];
        [wSelf resetChart];
    };
}

- (void)initExample {
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
    
    _annotation = [SCITextAnnotation new];
    _annotation.x1 = SCIGeneric(0);
    _annotation.style.textColor = UIColor.whiteColor;
    _annotation.style.textStyle.fontSize = 14;
    _annotation.style.backgroundColor = UIColor.clearColor;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rs1];
        [self.surface.renderableSeries add:rs2];
        [self.surface.renderableSeries add:rs3];
        [self.surface.annotations add:_annotation];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval / 1000.0 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
    _isRunning = YES;
}

- (void)updateData:(NSTimer *)timer {
    if (!_isRunning || [self getPointsCount] > MaxPointCount) {
        return;
    }
    int xValues[AppendPointsCount];
    float firstYValues[AppendPointsCount];
    float secondYValues[AppendPointsCount];
    float thirdYValues[AppendPointsCount];
    
    SCIXyDataSeries * mainSeries = (SCIXyDataSeries *)[self.surface.renderableSeries itemAt:0].dataSeries;
    SCIXyDataSeries * maLowSeries = (SCIXyDataSeries *)[self.surface.renderableSeries itemAt:1].dataSeries;
    SCIXyDataSeries * maHighSeries = (SCIXyDataSeries *)[self.surface.renderableSeries itemAt:2].dataSeries;
    
    int xValue = mainSeries.count > 0 ? SCIGenericInt([mainSeries.xValues valueAt:mainSeries.count - 1]) : 0;
    float yValue = mainSeries.count > 0 ? SCIGenericFloat([mainSeries.yValues valueAt:mainSeries.count - 1]) : 10;
    for (int i = 0; i < AppendPointsCount; i++) {
        xValue++;
        yValue = yValue + randf(0.0, 1.0) - 0.5;
        xValues[i] = xValue;
        firstYValues[i] = yValue;
        secondYValues[i] = [_maLow push:yValue].current;
        thirdYValues[i] = [_maHigh push:yValue].current;
        if (yValue > _maxYValue) {
            _maxYValue = yValue;
        }
    }
    
    [mainSeries appendRangeX:SCIGeneric((int *)xValues) Y:SCIGeneric((float *)firstYValues) Count:AppendPointsCount];
    [maLowSeries appendRangeX:SCIGeneric((int *)xValues) Y:SCIGeneric((float *)secondYValues) Count:AppendPointsCount];
    [maHighSeries appendRangeX:SCIGeneric((int *)xValues) Y:SCIGeneric((float *)thirdYValues) Count:AppendPointsCount];
    
    long count = mainSeries.count + maLowSeries.count + maHighSeries.count;
    _annotation.text = [NSString stringWithFormat:@"Amount of points: %li", count];
    _annotation.y1 = SCIGeneric(_maxYValue);
}

- (int)getPointsCount {
    SCIRenderableSeriesCollection * rsCollection = [self.surface renderableSeries];
    
    int result = 0;
    for (int i = 0; i < rsCollection.count; i++) {
        result += [rsCollection itemAt:i].dataSeries.count;
    }
    return result;
}

- (void)updateIsRunningWith:(BOOL)isRunning {
    _isRunning = isRunning;
    [self updateAutoRangeBehavior:_isRunning];
    [self updateModifiers:!_isRunning];
}

- (void)updateAutoRangeBehavior:(BOOL)isEnabled {
    SCIAutoRange autoRangeMode = isEnabled ? SCIAutoRange_Always : SCIAutoRange_Never;
    
    [self.surface.xAxes itemAt:0].autoRange = autoRangeMode;
    [self.surface.yAxes itemAt:0].autoRange = autoRangeMode;
}

- (void)updateModifiers:(BOOL)isEnabled {
    SCIChartModifierCollection * modifiers = self.surface.chartModifiers;
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

- (void)resetChart {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        for (int i = 0; i < self.surface.renderableSeries.count; i++) {
            [self.surface.renderableSeries[i].dataSeries clear];
        }
        _maLow = [[MovingAverage alloc] initWithLength:MaLow];
        _maHigh = [[MovingAverage alloc] initWithLength:MaHigh];
    }];
}

@end
