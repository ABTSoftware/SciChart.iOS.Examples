//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ErrorBarsChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ErrorBarsChartView.h"
#import "SCDDataManager.h"

@implementation ErrorBarsChartView

- (void)initExample {
    SCIHlDataSeries *dataSeries0 = [[SCIHlDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIHlDataSeries *dataSeries1 = [[SCIHlDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    
    SCDDoubleSeries *data = [SCDDataManager getFourierSeriesWithAmplitude:1.0 phaseShift:0.1 xStart:5.0 xEnd:5.15 count:5000];
    
    [self fillSeries:dataSeries0 sourceData:data scale:1.0];
    [self fillSeries:dataSeries1 sourceData:data scale:1.3];

    uint color = 0xFFC6E6FF;
    
    SCIEllipsePointMarker *pMarker = [SCIEllipsePointMarker new];
    pMarker.size = CGSizeMake(5, 5);
    pMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:color];
    
    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = dataSeries0;
    lineSeries.pointMarker = pMarker;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color thickness:1.f];
    
    self.errorBars0 = [SCIFastErrorBarsRenderableSeries new];
    self.errorBars0.dataSeries = dataSeries0;
    self.errorBars0.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color thickness:self.strokeThickness];
    self.errorBars0.errorDirection = SCIErrorDirection_Vertical;
    self.errorBars0.errorType = SCIErrorType_Absolute;
    self.errorBars0.dataPointWidth = self.dataPointWidth;
    
    self.errorBars1 = [SCIFastErrorBarsRenderableSeries new];
    self.errorBars1.dataSeries = dataSeries1;
    self.errorBars1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color thickness:self.strokeThickness];
    self.errorBars1.errorDirection = SCIErrorDirection_Vertical;
    self.errorBars1.errorType = SCIErrorType_Absolute;
    self.errorBars1.dataPointWidth = self.dataPointWidth;
    
    SCIEllipsePointMarker *sMarker = [SCIEllipsePointMarker new];
    sMarker.size = CGSizeMake(7, 7);
    sMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x00FFFFFF];
    sMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color thickness:1];
    
    SCIXyScatterRenderableSeries *scatterSeries = [SCIXyScatterRenderableSeries new];
    scatterSeries.dataSeries = dataSeries1;
    scatterSeries.pointMarker = sMarker;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:[SCINumericAxis new]];
        [self.surface.yAxes add:[SCINumericAxis new]];
        [self.surface.renderableSeries addAll:lineSeries, scatterSeries, self.errorBars0, self.errorBars1, nil];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        
        [SCIAnimations scaleSeries:lineSeries duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:scatterSeries duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:self.errorBars0 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:self.errorBars1 duration:3.0 andEasingFunction:[SCIElasticEase new]];
    }];
}

- (void)fillSeries:(id<ISCIHlDataSeries>)dataSeries sourceData:(SCDDoubleSeries *)sourceData scale:(double)scale {
    SCIDoubleValues *xValues = sourceData.xValues;
    SCIDoubleValues *yValues = sourceData.yValues;
    
    SCIDoubleValues *highValues = [SCIDoubleValues new];
    SCIDoubleValues *lowValues = [SCIDoubleValues new];
    for (int i = 0 ; i < yValues.count; i++) {
        [yValues set:[yValues getValueAt:i] * scale at:i];
        [highValues add:randf(0.0, 1.0) * 0.2];
        [lowValues add:randf(0.0, 1.0) * 0.2];
    }
    [dataSeries appendValuesX:xValues y:yValues high:highValues low:lowValues];
}

@end
