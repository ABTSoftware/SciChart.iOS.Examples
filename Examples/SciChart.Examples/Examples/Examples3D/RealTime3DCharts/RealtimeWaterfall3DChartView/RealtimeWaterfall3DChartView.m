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

@interface RealtimeWaterfall3DChartView ()

@property (nonatomic) int tick;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray<SCIDoubleValues *> *fftValues;
@property (strong, nonatomic) SCIWaterfallDataSeries3D *dataSeries;

@end

@implementation RealtimeWaterfall3DChartView

- (void)initExample {
    _tick = 0;
    
    _dataSeries = [[SCIWaterfallDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double xSize:PointsPerSlice zSize:SliceCount];
    _dataSeries.startX = @(10.0);
    _dataSeries.stepX = @(1.0);
    _dataSeries.startZ = @(25.0);
    _dataSeries.startZ = @(10.0);
    
    _fftValues = [SCDDataManager loadFFT];
    [_dataSeries pushValuesRow:_fftValues[0]];
    
    self.rSeries = [SCIWaterfallRenderableSeries3D new];
    self.rSeries.dataSeries = _dataSeries;
    self.rSeries.strokeThickness = 1.0;
    [self setupColorPalettes];
    [self setupPointMarker];
    [self setupSliceThickness];

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = [SCINumericAxis3D new];
        self.surface.yAxis = [SCINumericAxis3D new];
        self.surface.zAxis = [SCINumericAxis3D new];
        self.surface.zAxis.autoRange = SCIAutoRange_Always;

        [self.surface.renderableSeries add:self.rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
        
        [self.surface.camera.position assignX:-115 y:250 z:-570];
        [self.surface.worldDimensions assignX:200 y:100 z:200];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
}

- (void)updateData {
    _tick += 1;
    
    __weak typeof(self) wSelf = self;
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        int index = wSelf.tick % wSelf.fftValues.count;
        [wSelf.dataSeries pushValuesRow:wSelf.fftValues[index]];
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

@end
