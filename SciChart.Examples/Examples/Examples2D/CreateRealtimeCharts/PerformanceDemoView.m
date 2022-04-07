//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
#import "SCDToolbarItem.h"
#import "SCDRandomUtil.h"
#import "SCDMovingAverage.h"
#import "SCDToolbarButtonsGroup.h"

static int const MaLow = 200;
static int const MaHigh = 1000;
static double const TimeInterval = 10.0;
static int const MaxPointCount = 1000000;

@implementation PerformanceDemoView {
    SCITextAnnotation *_annotation;
    SCDMovingAverage *_maLow;
    SCDMovingAverage *_maHigh;
    
    NSTimer *_timer;
    BOOL _isRunning;
}

- (void)commonInit {
    [super commonInit];
    
    _maLow = [[SCDMovingAverage alloc] initWithLength:MaLow];
    _maHigh = [[SCDMovingAverage alloc] initWithLength:MaHigh];
}

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    
    id<ISCIRenderableSeries> rSeries1 = [self createRenderableSeriesWithColorCode:0xFF4083B7];
    id<ISCIRenderableSeries> rSeries2 = [self createRenderableSeriesWithColorCode:0xFFFFA500];
    id<ISCIRenderableSeries> rSeries3 = [self createRenderableSeriesWithColorCode:0xFFE13219];
    
    _annotation = [SCITextAnnotation new];
    _annotation.x1 = @(0);
    _annotation.y1 = @(0);
    _annotation.padding = (SCIEdgeInsets){ .left = 5, .top = 5, .right = 0, .bottom = 0 };
    _annotation.coordinateMode = SCIAnnotationCoordinateMode_Relative;
    
    _annotation.fontStyle = [[SCIFontStyle alloc] initWithFontSize:14 andTextColor:SCIColor.whiteColor];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries1];
        [self.surface.renderableSeries add:rSeries2];
        [self.surface.renderableSeries add:rSeries3];
        [self.surface.annotations add:self->_annotation];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval / 1000.0 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
    _isRunning = YES;
}

- (void)updateData:(NSTimer *)timer {
    if (!_isRunning || [self getPointsCount] > MaxPointCount) return;
    
    SCIIntegerValues *xValues = [[SCIIntegerValues alloc] initWithCapacity:self.pointsCount];
    SCIFloatValues *firstYValues = [[SCIFloatValues alloc] initWithCapacity:self.pointsCount];
    SCIFloatValues *secondYValues = [[SCIFloatValues alloc] initWithCapacity:self.pointsCount];
    SCIFloatValues *thirdYValues = [[SCIFloatValues alloc] initWithCapacity:self.pointsCount];
    
    SCIXyDataSeries *mainSeries = (SCIXyDataSeries *)[self.surface.renderableSeries itemAt:0].dataSeries;
    SCIXyDataSeries *maLowSeries = (SCIXyDataSeries *)[self.surface.renderableSeries itemAt:1].dataSeries;
    SCIXyDataSeries *maHighSeries = (SCIXyDataSeries *)[self.surface.renderableSeries itemAt:2].dataSeries;
    
    id<ISCIMath> xMath = mainSeries.xMath;
    id<ISCIMath> yMath = mainSeries.yMath;
    int xValue = mainSeries.count > 0 ? [xMath toDouble:[mainSeries.xValues valueAt:mainSeries.count - 1]] : 0;
    float yValue = mainSeries.count > 0 ? [yMath toDouble:[mainSeries.yValues valueAt:mainSeries.count - 1]] : 10;
    for (int i = 0; i < self.pointsCount; i++) {
        xValue++;
        yValue = yValue + randf(0.0, 1.0) - 0.5;
        [xValues add:xValue];
        [firstYValues add:yValue];
        [secondYValues add:[_maLow push:yValue].current];
        [thirdYValues add:[_maHigh push:yValue].current];
    }
    
    [mainSeries appendValuesX:xValues y:firstYValues];
    [maLowSeries appendValuesX:xValues y:secondYValues];
    [maHighSeries appendValuesX:xValues y:thirdYValues];
    
    long count = mainSeries.count + maLowSeries.count + maHighSeries.count;
    _annotation.text = [NSString stringWithFormat:@"Amount of points: %li", count];
}

- (int)getPointsCount {
    int result = 0;
    SCIRenderableSeriesCollection *rsCollection = self.surface.renderableSeries;
    for (NSInteger i = 0, count = rsCollection.count; i < count; i++) {
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
    SCIChartModifierCollection *modifiers = self.surface.chartModifiers;
    for (int i = 0; i < modifiers.count; i++) {
        [modifiers itemAt:i].isEnabled = isEnabled;
    }
}

- (void)resetChart {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        for (int i = 0; i < self.surface.renderableSeries.count; i++) {
            [self.surface.renderableSeries[i].dataSeries clear];
        }
        self->_maLow = [[SCDMovingAverage alloc] initWithLength:MaLow];
        self->_maHigh = [[SCDMovingAverage alloc] initWithLength:MaHigh];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)onStartPress {
    [self updateIsRunningWith:YES];
}

- (void)onPausePress {
    [self updateIsRunningWith:NO];
}

- (void)onStopPress {
    [self updateIsRunningWith:NO];
    [self resetChart];
}

@end
