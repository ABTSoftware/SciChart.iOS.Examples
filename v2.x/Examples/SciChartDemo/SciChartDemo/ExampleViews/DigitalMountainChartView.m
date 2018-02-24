//
//  DigitalMountainChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 3/14/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "DigitalMountainChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation DigitalMountainChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame{
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

-(void) initializeSurfaceData {
    id<SCIAxis2DProtocol> xAxis = [SCIDateTimeAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    PriceSeries * priceData = [DataManager getPriceDataIndu];
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
    [dataSeries appendRangeX:SCIGeneric(priceData.dateData) Y:SCIGeneric(priceData.closeData) Count:priceData.size];
    
    SCIFastMountainRenderableSeries * rSeries = [[SCIFastMountainRenderableSeries alloc] init];
    rSeries.dataSeries = dataSeries;
    rSeries.zeroLineY = 10000;
    rSeries.isDigitalLine = YES;
    rSeries.areaStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xAAFF8D42 finish:0x88090E11 direction:SCILinearGradientDirection_Vertical];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xAAFFC9A8 withThickness:1.0];
    
    SCIWaveRenderableSeriesAnimation *animation = [[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [rSeries addAnimation:animation];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCITooltipModifier new]]];
    }];
}

@end
