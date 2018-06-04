//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealTimeGhostTracesChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "RealTimeGhostTracesChartView.h"
#import "DataManager.h"
#import "RandomUtil.h"

@implementation RealTimeGhostTracesChartView {
    NSTimer * _timer;

    double _lastAmplitude;
    double _phase;
}

- (void)commonInit {
    __weak typeof(self) wSelf = self;
    self.speedChanged = ^(UISlider * sender) { [wSelf onSpeedChanged:sender]; };
}

- (void)initExample {
    _lastAmplitude = 1.0;
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Never;
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(-2.0) Max:SCIGeneric(2.0)];
    
    [self.surface.xAxes add:xAxis];
    [self.surface.yAxes add:yAxis];
    
    uint limeGreen = 0xFF32CD32;
    
    [self addLineRenderableSeries:limeGreen opacity:1.0];
    [self addLineRenderableSeries:limeGreen opacity:0.9];
    [self addLineRenderableSeries:limeGreen opacity:0.8];
    [self addLineRenderableSeries:limeGreen opacity:0.7];
    [self addLineRenderableSeries:limeGreen opacity:0.62];
    [self addLineRenderableSeries:limeGreen opacity:0.55];
    [self addLineRenderableSeries:limeGreen opacity:0.45];
    [self addLineRenderableSeries:limeGreen opacity:0.35];
    [self addLineRenderableSeries:limeGreen opacity:0.25];
    [self addLineRenderableSeries:limeGreen opacity:0.15];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow: newWindow];
    
    if (newWindow == nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)onSpeedChanged:(UISlider *) sender {
    if (sender.value > 0) {
        if (_timer != nil) {
            [_timer invalidate];
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:sender.value / 1000.0 target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
    }
}

- (void)updateData:(NSTimer *)timer {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];

        double randomAmplitude = _lastAmplitude + ([RandomUtil nextDouble] - 0.5);
        if (randomAmplitude < -2.0) {
            randomAmplitude = -2.0;
        } else if (randomAmplitude > 2.0) {
            randomAmplitude = 2.0;
        }
        
        DoubleSeries * noisySinewave = [DataManager getNoisySinewaveWithAmplitude:randomAmplitude Phase:_phase PointCount:1000 NoiseAmplitude:0.25];
        _lastAmplitude = randomAmplitude;
    
        [dataSeries appendRangeX:noisySinewave.xValues Y:noisySinewave.yValues Count:noisySinewave.size];
        
        [self reassignRenderSeriesWithDataSeries:dataSeries];
    }];
}

- (void)reassignRenderSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries {
    SCIRenderableSeriesCollection * rs = self.surface.renderableSeries;
    
    // shift old dataSeries
    [rs itemAt:9].dataSeries = [rs itemAt:8].dataSeries;
    [rs itemAt:8].dataSeries = [rs itemAt:7].dataSeries;
    [rs itemAt:7].dataSeries = [rs itemAt:6].dataSeries;
    [rs itemAt:6].dataSeries = [rs itemAt:5].dataSeries;
    [rs itemAt:5].dataSeries = [rs itemAt:4].dataSeries;
    [rs itemAt:4].dataSeries = [rs itemAt:3].dataSeries;
    [rs itemAt:3].dataSeries = [rs itemAt:2].dataSeries;
    [rs itemAt:2].dataSeries = [rs itemAt:1].dataSeries;
    [rs itemAt:1].dataSeries = [rs itemAt:0].dataSeries;
    
    // use new dataSeries to draw first renderableSeries
    [rs itemAt:0].dataSeries = dataSeries;
}

- (void)addLineRenderableSeries:(uint)color opacity:(float)opacity {
    SCIFastLineRenderableSeries * lineRenerableSeries = [SCIFastLineRenderableSeries new];
    lineRenerableSeries.opacity = opacity;
    lineRenerableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:1];
    
    [self.surface.renderableSeries add:lineRenerableSeries];
}

@end
