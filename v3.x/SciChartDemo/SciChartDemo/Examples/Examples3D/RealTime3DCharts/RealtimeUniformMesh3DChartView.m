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

@implementation RealtimeUniformMesh3DChartView {
    int _w;
    int _h;
    NSTimer *_timer;
    
    int _frames;
    SCIUniformGridDataSeries3D *_ds;
}

- (void)initExample {
    _w = 50;
    _h = 50;
    _frames = 0;
    
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];;
    xAxis.autoRange = SCIAutoRange_Always;
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:0.0 max:1.0];
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    zAxis.autoRange = SCIAutoRange_Always;
    
    _ds = [[SCIUniformGridDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:_w zSize:_h];

    unsigned int colors[7] = { 0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000 };
    float stops[7] = { 0, 0.1, 0.3, 0.5, 0.7, 0.9, 1 };
    SCIGradientColorPalette *palette = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:7];
    
    SCISurfaceMeshRenderableSeries3D *rs = [SCISurfaceMeshRenderableSeries3D new];
    rs.dataSeries = _ds;
    rs.stroke = 0x7FFFFFFF;
    rs.strokeThickness = 2.0;
    rs.drawSkirt = NO;
    rs.minimum = 0;
    rs.maximum = 0.5;
    rs.shininess = 64;
    rs.meshColorPalette = palette;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rs];
        [self.surface.chartModifiers add:ExampleViewBase.createDefault3DModifiers];
    }];
    
     _timer = [NSTimer scheduledTimerWithTimeInterval:0.033 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
}

- (void)updateData {
    SCIDoubleValues *buffer = [SCIDoubleValues new];
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        _frames += 1;
        
        double wc = _w * 0.5;
        double hc = _h * 0.5;
        double freq = sin(_frames * 0.1) * 0.1 + 0.1;
        
        SCIIndexCalculator *indexCalculator = _ds.indexCalculator;
        
        buffer.count = indexCalculator.size;
        
        double *items = buffer.itemsArray;
        for (int i = 0; i < _h; ++i) {
            for (int j = 0; j < _w; ++j) {
                double x = (wc - i) * (wc - i) + (hc - j) * (hc - j);
                double radius = sqrt(x);
                double d = M_PI * radius * freq;
                double value = sin(d) / d;
                
                int index = [indexCalculator getIndexAtUIndex:i andVIndex:j];
                items[index] = isnan(value) ? 1 : value;
            }
        }
        [_ds copyFromValues:buffer];
    }];
}

- (void)willMoveToWindow:(UIWindow *)newWindow {
    [super willMoveToWindow:newWindow];
    if (newWindow == nil) {
        [_timer invalidate];
        _timer = nil;
    }
}

@end
