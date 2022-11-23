//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2021. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingSeriesValueModifierView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UsingSeriesValueModifierView.h"

static int const FifoCapacity = 100;
static double const TimeInterval = 0.05;

@implementation UsingSeriesValueModifierView {
    NSTimer *_timer;
    SCIXyDataSeries *_ds1;
    SCIXyDataSeries *_ds2;
    SCIXyDataSeries *_ds3;
    
    double _t;
}

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    xAxis.axisTitle = @"Time (Seconds)";
    xAxis.textFormatting = @"0.0";
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.axisTitle = @"Amplitude (Volts)";
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.textFormatting = @"0.00";
    yAxis.cursorTextFormatting = @"0.00";
    
    _ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    _ds1.fifoCapacity = FifoCapacity;
    _ds1.seriesName = @"Orange Series";
    _ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    _ds2.fifoCapacity = FifoCapacity;
    _ds2.seriesName = @"Blue Series";
    _ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    _ds3.fifoCapacity = FifoCapacity;
    _ds3.seriesName = @"Green Series";

    SCIFastLineRenderableSeries *rSeries1 = [SCIFastLineRenderableSeries new];
    rSeries1.dataSeries = _ds1;
    rSeries1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFe97064 thickness:2];
    
    SCIFastLineRenderableSeries *rSeries2 = [SCIFastLineRenderableSeries new];
    rSeries2.dataSeries = _ds2;
    rSeries2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF47bde6 thickness:2];
    
    SCIFastLineRenderableSeries *rSeries3 = [SCIFastLineRenderableSeries new];
    rSeries3.dataSeries = _ds3;
    rSeries3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:2];
    
    SCILegendModifier *legendModifier = [SCILegendModifier new];
    legendModifier.margins = (SCIEdgeInsets){.left = 16, .top = 16, .right = 16, .bottom = 16};
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries1];
        [self.surface.renderableSeries add:rSeries2];
        [self.surface.renderableSeries add:rSeries3];
        [self.surface.chartModifiers addAll:[SCISeriesValueModifier new], legendModifier, nil];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(updateData:) userInfo:nil repeats:YES];
}

- (void)updateData:(NSTimer *)timer {
    double y1 = 3.0 * sin(((2 * M_PI) * 1.4) * _t * 0.02);
    double y2 = 2.0 * cos(((2 * M_PI) * 0.8) * _t * 0.02);
    double y3 = 1.0 * sin(((2 * M_PI) * 2.2) * _t * 0.02);
    
    [_ds1 appendX:@(_t) y:@(y1)];
    [_ds2 appendX:@(_t) y:@(y2)];
    [_ds3 appendX:@(_t) y:@(y3)];
    
    _t += TimeInterval;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

@end
