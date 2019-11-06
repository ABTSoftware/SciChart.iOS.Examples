//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

#import "HeatmapChartView.h"
#import "SCDDataManager.h"

const int HEIGHT = 200;
const int WIDTH = 300;
const int SERIES_PER_PERIOD = 30;
const float TIME_INTERVAL = 0.04;

@implementation HeatmapChartView {
    SCIUniformHeatmapDataSeries *_dataSeries;
    int _timerIndex;
    NSTimer * timer;
    BOOL _running;
    NSMutableArray<SCIDoubleValues *> *_valuesArray;
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
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    
    _dataSeries = [[SCIUniformHeatmapDataSeries alloc] initWithXType:SCIDataType_Int yType:SCIDataType_Int zType:SCIDataType_Double xSize:WIDTH ySize:HEIGHT];
    
    NSArray<UIColor *> *colors = @[[UIColor fromARGBColorCode:0xFF00008B], [UIColor fromARGBColorCode:0xFF6495ED], [UIColor fromARGBColorCode:0xFF006400], [UIColor fromARGBColorCode:0xFF7FFF00], UIColor.yellowColor, UIColor.redColor];
    
    SCIFastUniformHeatmapRenderableSeries *heatmapRenderableSeries = [SCIFastUniformHeatmapRenderableSeries new];
    heatmapRenderableSeries.dataSeries = _dataSeries;
    heatmapRenderableSeries.minimum = 0;
    heatmapRenderableSeries.maximum = 200;
    heatmapRenderableSeries.colorMap = [[SCIColorMap alloc] initWithColors:colors andStops:@[@0.0, @0.2, @0.4, @0.6, @0.8, @1.0]];
    
    _valuesArray = [NSMutableArray<SCIDoubleValues *> new];
    for (int i = 0; i < SERIES_PER_PERIOD; i++) {
        [_valuesArray addObject:[self createValues:i]];
    }
    
    self.heatmapColourMap.minimum = heatmapRenderableSeries.minimum;
    self.heatmapColourMap.maximum = heatmapRenderableSeries.maximum;
    self.heatmapColourMap.colourMap = heatmapRenderableSeries.colorMap;
    
    [self.surface.xAxes add:xAxis];
    [self.surface.yAxes add:yAxis];
    [self.surface.renderableSeries add:heatmapRenderableSeries];
    [self.surface.chartModifiers add:ExampleViewBase.createDefaultModifiers];
    [self.surface.chartModifiers add:[SCICursorModifier new]];
}

- (SCIDoubleValues *)createValues:(int)index {
    SCIDoubleValues *values = [[SCIDoubleValues alloc] initWithCapacity:WIDTH * HEIGHT];
    
    double angle = M_PI * 2.0 * index / SERIES_PER_PERIOD;
    double cx = 150;
    double cy = 100;
    for (int x = 0; x < WIDTH; x++) {
        for (int y = 0; y < HEIGHT; y++) {
            double v = (1 + sin(x * 0.04 + angle)) * 50 + (1 + sin(y * 0.1 + angle)) * 50 * (1 + sin(angle * 2));
            double r = sqrt((x - cx) * (x - cx) + (y - cy) * (y - cy));
            double exp = MAX(0, 1 - r * 0.008);
            
            [values add:v * exp + arc4random_uniform(50)];
        }
    }
    
    return values;
}

- (void)updateHeatmapData:(NSTimer *)timer {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        SCIDoubleValues *values = _valuesArray[_timerIndex % SERIES_PER_PERIOD];
        [_dataSeries updateZValues:values];
        
        _timerIndex++;
    }];
}

@end
