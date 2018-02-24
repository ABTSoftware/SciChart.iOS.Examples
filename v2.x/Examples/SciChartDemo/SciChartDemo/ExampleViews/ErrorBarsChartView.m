//
//  ErrorBarsChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 9/17/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ErrorBarsChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation ErrorBarsChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [[SCIChartSurface alloc]initWithFrame:frame];
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    return self;
}

- (void)initializeSurfaceData {
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
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:lineSeries];
        [surface.renderableSeries add:scatterSeries];
        [surface.renderableSeries add:errorBars0];
        [surface.renderableSeries add:errorBars1];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
        
        [errorBars0 addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [lineSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [errorBars1 addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [scatterSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
    }];
}

- (void)fillSeries:(id<SCIHlDataSeriesProtocol>)dataSeries sourceData:(DoubleSeries *)sourceData scale:(double)scale {
    SCIArrayController * xValues = [sourceData getXArray];
    SCIArrayController * yValues = [sourceData getYArray];
    
    for (int i =0 ; i< xValues.count; i++){
        double y = SCIGenericDouble([yValues valueAt:i]) * scale;
        [dataSeries appendX: [xValues valueAt:i] Y:SCIGeneric(y) High:SCIGeneric(randf(0.0, 1.0) * 0.2) Low:SCIGeneric(randf(0.0, 1.0) * 0.2)];
    }
}

@end
