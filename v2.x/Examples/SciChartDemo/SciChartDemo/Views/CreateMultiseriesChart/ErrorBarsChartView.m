//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import "DataManager.h"

@implementation ErrorBarsChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    
    SCIHlDataSeries * dataSeries0 = [[SCIHlDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    SCIHlDataSeries * dataSeries1 = [[SCIHlDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    
    DoubleSeries * data = [DataManager getFourierSeriesWithAmplitude:1.0 phaseShift:0.1 xStart:5.0 xEnd:5.15 count:5000];
    
    [self fillSeries:dataSeries0 sourceData:data scale:1.0];
    [self fillSeries:dataSeries1 sourceData:data scale:1.3];

    uint color = 0xFFC6E6FF;
    SCIFastErrorBarsRenderableSeries * errorBars0 = [SCIFastErrorBarsRenderableSeries new];
    errorBars0.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:1.f];
    errorBars0.dataSeries = dataSeries0;
    
    SCIEllipsePointMarker * pMarker = [SCIEllipsePointMarker new];
    pMarker.width = 5;
    pMarker.height = 5;
    pMarker.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:color];
    
    SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:1.f];
    lineSeries.dataSeries = dataSeries0;
    lineSeries.pointMarker = pMarker;
    
    SCIFastErrorBarsRenderableSeries * errorBars1 = [SCIFastErrorBarsRenderableSeries new];
    errorBars1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:1.f];
    errorBars1.dataSeries = dataSeries1;
    [errorBars1 setDataPointWidth:0.7];
    
    SCIEllipsePointMarker * sMarker = [[SCIEllipsePointMarker alloc]init];
    sMarker.width = 7;
    sMarker.height = 7;
    sMarker.fillStyle = [[SCISolidBrushStyle alloc]initWithColorCode:0x00FFFFFF];
    
    SCIXyScatterRenderableSeries * scatterSeries = [SCIXyScatterRenderableSeries new];
    scatterSeries.dataSeries = dataSeries1;
    scatterSeries.pointMarker = sMarker;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.renderableSeries add:scatterSeries];
        [self.surface.renderableSeries add:errorBars0];
        [self.surface.renderableSeries add:errorBars1];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [errorBars0 addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [lineSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [errorBars1 addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [scatterSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
    }];
}

- (void)fillSeries:(id<SCIHlDataSeriesProtocol>)dataSeries sourceData:(DoubleSeries *)sourceData scale:(double)scale {
    SCIArrayController * xValues = [sourceData getXArray];
    SCIArrayController * yValues = [sourceData getYArray];
    
    for (int i = 0 ; i < xValues.count; i++) {
        double y = SCIGenericDouble([yValues valueAt:i]) * scale;
        [dataSeries appendX:[xValues valueAt:i] Y:SCIGeneric(y) High:SCIGeneric(randf(0.0, 1.0) * 0.2) Low:SCIGeneric(randf(0.0, 1.0) * 0.2)];
    }
}

@end
