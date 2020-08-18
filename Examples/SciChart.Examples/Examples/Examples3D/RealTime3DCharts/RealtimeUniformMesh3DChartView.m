//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeUniformMesh3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "RealtimeUniformMesh3DChartView.h"

@interface RealtimeUniformMesh3DChartView ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) SCIUniformGridDataSeries3D *dataSeries;
@property (strong, nonatomic) SCIDoubleValues *buffer;
@property (nonatomic) int w;
@property (nonatomic) int h;
@property (nonatomic) int frames;

@end

@implementation RealtimeUniformMesh3DChartView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    _buffer = [SCIDoubleValues new];
    _w = 50;
    _h = 50;
    _frames = 0;
    
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.autoRange = SCIAutoRange_Always;
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:0.0 max:1.0];
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    zAxis.autoRange = SCIAutoRange_Always;
    
    _dataSeries = [[SCIUniformGridDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:_w zSize:_h];

    unsigned int colors[7] = { 0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000 };
    float stops[7] = { 0, 0.1, 0.3, 0.5, 0.7, 0.9, 1 };
    SCIGradientColorPalette *palette = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:7];
    
    SCISurfaceMeshRenderableSeries3D *rSeries = [SCISurfaceMeshRenderableSeries3D new];
    rSeries.dataSeries = _dataSeries;
    rSeries.stroke = 0x7FFFFFFF;
    rSeries.strokeThickness = 2.0;
    rSeries.drawSkirt = NO;
    rSeries.minimum = 0;
    rSeries.maximum = 0.5;
    rSeries.shininess = 64;
    rSeries.meshColorPalette = palette;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
    }];
    
     _timer = [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
}

- (void)updateData {
    __weak typeof(self) wSelf = self;
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        wSelf.frames += 1;
        
        double wc = wSelf.w * 0.5;
        double hc = wSelf.h * 0.5;
        double freq = sin(wSelf.frames * 0.1) * 0.1 + 0.1;
        
        SCIIndexCalculator *indexCalculator = wSelf.dataSeries.indexCalculator;
        
        wSelf.buffer.count = indexCalculator.size;
        
        double *bufferItems = wSelf.buffer.itemsArray;
        for (int i = 0; i < wSelf.h; ++i) {
            for (int j = 0; j < wSelf.w; ++j) {
                double x = (wc - i) * (wc - i) + (hc - j) * (hc - j);
                double radius = sqrt(x);
                double d = M_PI * radius * freq;
                double value = sin(d) / d;
                
                NSInteger index = [indexCalculator getIndexAtUIndex:i andVIndex:j];
                bufferItems[index] = isnan(value) ? 1 : value;
            }
        }
        [wSelf.dataSeries copyFromValues:wSelf.buffer];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

@end
