//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeWaterfall3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "RealtimeWaterfall3DChartView.h"
#import "SCDDataManager.h"

const int PointsPerSlice = 128;
const int SliceCount = 10;

@implementation RealtimeWaterfall3DChartView {
    int _tick;
    NSTimer *_timer;
    NSArray<SCIDoubleValues *> *_fftValues;
    SCIWaterfallDataSeries3D *_ds;
}

- (void)initExample {
    _tick = 0;
    
    _ds = [[SCIWaterfallDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:PointsPerSlice zSize:SliceCount];
    _ds.startX = @(10.0);
    _ds.stepX = @(1.0);
    _ds.startZ = @(25.0);
    _ds.startZ = @(10.0);
    
    _fftValues = [SCDDataManager loadFFT];
    [_ds pushValuesRow:_fftValues[0]];
    
    unsigned int fillColors[5] = {0xFFFF0000, 0xFFFFA500, 0xFFFFFF00, 0xFFADFF2F, 0xFF006400 };
    float fillStops[5] = { 0.0, 0.4, 0.5, 0.6, 1.0 };
    SCIGradientColorPalette *fillColorPalette = [[SCIGradientColorPalette alloc] initWithColors:fillColors stops:fillStops count:5];
    
    SCIWaterfallRenderableSeries3D *rs = [SCIWaterfallRenderableSeries3D new];
    rs.dataSeries = _ds;
    rs.strokeThickness = 1.0;
    rs.sliceThickness = 5.0;
    rs.yColorMapping = fillColorPalette;
    rs.yStrokeColorMapping = [[SCIBrushColorPalette alloc] initWithBrushStyle:[[SCISolidBrushStyle alloc] initWithColorCode:0]];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = [SCINumericAxis3D new];
        self.surface.yAxis = [SCINumericAxis3D new];
        self.surface.zAxis = [SCINumericAxis3D new];
        self.surface.zAxis.autoRange = SCIAutoRange_Always;

        [self.surface.renderableSeries add:rs];
        [self.surface.chartModifiers add:ExampleViewBase.createDefault3DModifiers];
        
        [self.surface.camera.position assignX:-115 y:250 z:-570];
        [self.surface.worldDimensions assignX:200 y:100 z:200];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
}

- (void)updateData {
    _tick += 1;
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        int index = _tick % _fftValues.count;
        [_ds pushValuesRow:_fftValues[index]];
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
