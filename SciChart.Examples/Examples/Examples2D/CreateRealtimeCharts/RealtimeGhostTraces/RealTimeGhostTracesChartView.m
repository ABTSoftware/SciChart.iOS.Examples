//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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
#import "SCDRealTimeGhostTracesToolbarItem.h"
#import "SCDDataManager.h"
#import "SCDRandomUtil.h"

@interface RealTimeGhostTracesChartView ()
@property (nonatomic, strong) SCDRealTimeGhostTracesToolbarItem *actionItem;
@property (nonatomic) NSTimer *timer;
@end

@implementation RealTimeGhostTracesChartView {
    double _lastAmplitude;
    double _phase;
}

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

#if TARGET_OS_OSX
- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    return @[self.actionItem];
}
#elif TARGET_OS_IOS
- (SCIView *)providePanel {
    return [self.actionItem createView];
}
#endif

- (SCDRealTimeGhostTracesToolbarItem *)actionItem {
    if (!_actionItem) {
        __weak typeof(self) wSelf = self;
        _actionItem = [[SCDRealTimeGhostTracesToolbarItem alloc] initWithAction:^(double doubleValue) {
            if (doubleValue > 0) {
                if (wSelf.timer != nil) {
                    [wSelf.timer invalidate];
                }
                [wSelf p_SCD_startTimerWithValue:doubleValue];
            }
        }];
    }
    return _actionItem;
}

- (void)initExample {
    _lastAmplitude = 1.0;
    
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Never;
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:-2.0 max:2.0];
    
    [self.surface.xAxes add:xAxis];
    [self.surface.yAxes add:yAxis];
    
    uint limeGreen = 0xFF68bcae;
    
    [self p_SCD_addLineRenderableSeries:limeGreen opacity:1.0];
    [self p_SCD_addLineRenderableSeries:limeGreen opacity:0.9];
    [self p_SCD_addLineRenderableSeries:limeGreen opacity:0.8];
    [self p_SCD_addLineRenderableSeries:limeGreen opacity:0.7];
    [self p_SCD_addLineRenderableSeries:limeGreen opacity:0.62];
    [self p_SCD_addLineRenderableSeries:limeGreen opacity:0.55];
    [self p_SCD_addLineRenderableSeries:limeGreen opacity:0.45];
    [self p_SCD_addLineRenderableSeries:limeGreen opacity:0.35];
    [self p_SCD_addLineRenderableSeries:limeGreen opacity:0.25];
    [self p_SCD_addLineRenderableSeries:limeGreen opacity:0.15];
    
    [self p_SCD_startTimerWithValue:_actionItem.sliderValue];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)p_SCD_startTimerWithValue:(double)value {
    _timer = [NSTimer scheduledTimerWithTimeInterval:value / 1000.0 target:self selector:@selector(p_SCD_updateData:) userInfo:nil repeats:YES];
}

- (void)p_SCD_updateData:(NSTimer *)timer {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];

        double randomAmplitude = self->_lastAmplitude + ([SCDRandomUtil nextDouble] - 0.5);
        if (randomAmplitude < -2.0) {
            randomAmplitude = -2.0;
        } else if (randomAmplitude > 2.0) {
            randomAmplitude = 2.0;
        }
        
        SCDDoubleSeries *noisySinewave = [SCDDataManager getNoisySinewaveWithAmplitude:randomAmplitude Phase:self->_phase PointCount:1000 NoiseAmplitude:0.25];
        self->_lastAmplitude = randomAmplitude;
    
        [dataSeries appendValuesX:noisySinewave.xValues y:noisySinewave.yValues];
        
        [self p_SCD_reassignRenderSeriesWithDataSeries:dataSeries];
    }];
}

- (void)p_SCD_reassignRenderSeriesWithDataSeries:(SCIXyDataSeries *)dataSeries {
    SCIRenderableSeriesCollection *rSeries = self.surface.renderableSeries;
    
    // shift old dataSeries
    [rSeries itemAt:9].dataSeries = [rSeries itemAt:8].dataSeries;
    [rSeries itemAt:8].dataSeries = [rSeries itemAt:7].dataSeries;
    [rSeries itemAt:7].dataSeries = [rSeries itemAt:6].dataSeries;
    [rSeries itemAt:6].dataSeries = [rSeries itemAt:5].dataSeries;
    [rSeries itemAt:5].dataSeries = [rSeries itemAt:4].dataSeries;
    [rSeries itemAt:4].dataSeries = [rSeries itemAt:3].dataSeries;
    [rSeries itemAt:3].dataSeries = [rSeries itemAt:2].dataSeries;
    [rSeries itemAt:2].dataSeries = [rSeries itemAt:1].dataSeries;
    [rSeries itemAt:1].dataSeries = [rSeries itemAt:0].dataSeries;
    
    // use new dataSeries to draw first renderableSeries
    [rSeries itemAt:0].dataSeries = dataSeries;
}

- (void)p_SCD_addLineRenderableSeries:(uint)color opacity:(float)opacity {
    SCIFastLineRenderableSeries *lineRenerableSeries = [SCIFastLineRenderableSeries new];
    lineRenerableSeries.opacity = opacity;
    lineRenerableSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color thickness:1];
    
    [self.surface.renderableSeries add:lineRenerableSeries];
}

@end
