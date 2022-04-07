//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimePointCloud3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "RealtimePointCloud3DChartView.h"
#import "SCDRandomUtil.h"
#import "SCDDataManager.h"

@implementation RealtimePointCloud3DChartView {
    NSTimer *_timer;
    SCIXyzDataSeries3D *_dataSeries;
    SCIDoubleValues *_xData;
    SCIDoubleValues *_yData;
    SCIDoubleValues *_zData;
}

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    _xData = [SCIDoubleValues new];
    _yData = [SCIDoubleValues new];
    _zData = [SCIDoubleValues new];
    
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.autoRange = SCIAutoRange_Once;
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.autoRange = SCIAutoRange_Once;
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    zAxis.autoRange = SCIAutoRange_Once;
    
    SCIEllipsePointMarker3D *pointMarker = [SCIEllipsePointMarker3D new];
    pointMarker.fillColor = 0x77ADFF2F;
    pointMarker.size = 3.f;

    for (int i = 0; i < 1000; ++i) {
        double x = [SCDDataManager getGaussianRandomNumber:5 stdDev:1.5];
        double y = [SCDDataManager getGaussianRandomNumber:5 stdDev:1.5];
        double z = [SCDDataManager getGaussianRandomNumber:5 stdDev:1.5];
        
        [_xData add:x];
        [_yData add:y];
        [_zData add:z];
    }
    
    _dataSeries = [[SCIXyzDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double];
    [_dataSeries appendXValues:_xData yValues:_yData zValues:_zData];
    
    SCIScatterRenderableSeries3D *rSeries = [SCIScatterRenderableSeries3D new];
    rSeries.dataSeries = _dataSeries;
    rSeries.pointMarker = pointMarker;

    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
    }];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateData) userInfo:nil repeats:YES];
}

- (void)updateData {
    double *xItems = _xData.itemsArray;
    double *yItems = _yData.itemsArray;
    double *zItems = _zData.itemsArray;
    
    for (int i = 0; i < _dataSeries.count; i++) {
        xItems[i] += SCDRandomUtil.nextDouble - 0.5;
        yItems[i] += SCDRandomUtil.nextDouble - 0.5;
        zItems[i] += SCDRandomUtil.nextDouble - 0.5;
    }
    [_dataSeries updateXValues:_xData yValues:_yData zValues:_zData at:0];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [_timer invalidate];
    _timer = nil;
}

@end
