//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// HeatmapChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <SciChart/SciChart.h>
#import "HeatmapChartView.h"
#import "DataManager.h"

const int HEIGHT = 200;
const int WIDTH = 300;
const int SERIES_PER_PERIOD = 30;
const float TIME_INTERVAL = 0.04;

@implementation HeatmapChartView {
    SCIUniformHeatmapDataSeries * _dataSeries;
    int _timerIndex;
    NSTimer * timer;
    BOOL _running;
    SCIGenericType * data;
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow: newWindow];
    if(timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval:TIME_INTERVAL target:self selector:@selector(updateHeatmapData:) userInfo:nil repeats:YES];
    } else {
        [timer invalidate];
        timer = nil;
    }
}

- (void)initExample {
    self.surface.leftAxisAreaForcedSize = 0.0;
    self.surface.topAxisAreaForcedSize = 0.0;
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    
    _dataSeries = [[SCIUniformHeatmapDataSeries alloc] initWithTypeX:SCIDataType_Int32 Y:SCIDataType_Int32 Z:SCIDataType_Double SizeX:WIDTH Y:HEIGHT StartX:SCIGeneric(0.0) StepX:SCIGeneric(1.0) StartY:SCIGeneric(0.0) StepY:SCIGeneric(1.0)];
    
    NSArray<NSNumber *> *stops = @[@(0.0), @(0.2), @(0.4), @(0.6), @(0.8), @(1.0)];
    NSArray<UIColor *> *colors = @[[UIColor fromARGBColorCode:0xFF00008B], [UIColor fromARGBColorCode:0xFF6495ED], [UIColor fromARGBColorCode:0xFF006400], [UIColor fromARGBColorCode:0xFF7FFF00], [UIColor fromARGBColorCode:0xFFFFFF00], [UIColor fromARGBColorCode:0xFFFF0000]];
    
    SCIFastUniformHeatmapRenderableSeries * heatmapRenderableSeries = [SCIFastUniformHeatmapRenderableSeries new];
    heatmapRenderableSeries.minimum = 0;
    heatmapRenderableSeries.maximum = 200;
    heatmapRenderableSeries.colorMap = [[SCIColorMap alloc] initWithColors:colors andStops:stops];
    heatmapRenderableSeries.dataSeries = _dataSeries;
    
    [self createData];
    
    self.heatmapColourMap.minimum = heatmapRenderableSeries.minimum;
    self.heatmapColourMap.maximum = heatmapRenderableSeries.maximum;
    self.heatmapColourMap.colourMap = heatmapRenderableSeries.colorMap;
    
    [self.surface.xAxes add:xAxis];
    [self.surface.yAxes add:yAxis];
    [self.surface.renderableSeries add:heatmapRenderableSeries];
    self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCICursorModifier new]]];
}

- (void)createData {
    data = malloc(sizeof(SCIGenericType) * 60);
    
    for (int i = 0; i < SERIES_PER_PERIOD ; i++) {
        double angle = M_PI * 2.0 * i / SERIES_PER_PERIOD;
        double * zValues = malloc(sizeof(double) * WIDTH * HEIGHT);
        double cx = 150;
        double cy = 100;
        
        for (int x = 0; x < WIDTH; x++) {
            for (int y = 0; y < HEIGHT; y++) {
                double v = (1 + sin(x * 0.04 + angle)) * 50 + (1 + sin(y * 0.1 + angle)) * 50 * (1 + sin(angle * 2));
                double r = sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy));
                double exp = MAX(0, 1 - r * 0.008);
                
                zValues[x * HEIGHT + y] = v * exp + arc4random_uniform(50);
            }
        }
        data[i] = SCIGeneric(zValues);
    }
    [_dataSeries updateZValues:data[0] Size:WIDTH*HEIGHT];
}

- (void)updateHeatmapData:(NSTimer *)timer {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [_dataSeries updateZValues:data[_timerIndex % SERIES_PER_PERIOD] Size:WIDTH * HEIGHT];
        
        _timerIndex++;
    }];
}

- (void)dealloc {
    for (int i = 0, count = 60; i < count; i++) {
        double *zValues = SCIGenericDoublePtr(data[i]);
        free(zValues);
    }
    
    free(data);
}

@end
