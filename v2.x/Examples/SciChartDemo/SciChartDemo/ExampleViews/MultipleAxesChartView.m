//
//  MultipleAxesView.m
//  SciChartDemo
//
//  Created by Admin on 13.04.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "MultipleAxesChartView.h"
#import "RandomUtil.h"
#import <SciChart/SciChart.h>

static NSString * const TopAxisId = @"xTopAxis";
static NSString * const BottomAxisId = @"xBottomAxis";
static NSString * const LeftAxisId = @"yLeftAxis";
static NSString * const RightAxisId = @"yRightAxis";

@implementation MultipleAxesChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:surface];
        
        NSDictionary * layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    id<SCIAxis2DProtocol> xTopAxis = [SCINumericAxis new];
    xTopAxis.axisId = TopAxisId;
    xTopAxis.axisAlignment = SCIAxisAlignment_Top;
    xTopAxis.style.labelStyle.colorCode = 0xFF279B27;
    
    id<SCIAxis2DProtocol> xBottomAxis = [SCINumericAxis new];
    xBottomAxis.axisId = BottomAxisId;
    xBottomAxis.axisAlignment = SCIAxisAlignment_Bottom;
    xBottomAxis.style.labelStyle.colorCode = 0xFFFF1919;
    
    id<SCIAxis2DProtocol> yLeftAxis = [SCINumericAxis new];
    yLeftAxis.axisId = LeftAxisId;
    yLeftAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.style.labelStyle.colorCode = 0xFFFC9C29;
    
    id<SCIAxis2DProtocol> yRightAxis = [SCINumericAxis new];
    yRightAxis.axisId = RightAxisId;
    yRightAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yRightAxis.axisAlignment = SCIAxisAlignment_Right;
    yRightAxis.style.labelStyle.colorCode = 0xFF4083B7;

    SCIXAxisDragModifier * topAxisDrag = [SCIXAxisDragModifier new];
    topAxisDrag.axisId = TopAxisId;
    SCIXAxisDragModifier * bottomAxisDrag = [SCIXAxisDragModifier new];
    bottomAxisDrag.axisId = BottomAxisId;
    
    SCIYAxisDragModifier * leftAxisDrag = [SCIYAxisDragModifier new];
    leftAxisDrag.axisId = LeftAxisId;
    SCIYAxisDragModifier * rightAxisDrag = [SCIYAxisDragModifier new];
    rightAxisDrag.axisId = RightAxisId;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xTopAxis];
        [surface.xAxes add:xBottomAxis];
        [surface.yAxes add:yLeftAxis];
        [surface.yAxes add:yRightAxis];
        
        [surface.renderableSeries add:[self getRenderableSeriesWithXAxisId:BottomAxisId yAxisId:LeftAxisId seriesName:@"Red line" color:0xFFFF1919]];
        [surface.renderableSeries add:[self getRenderableSeriesWithXAxisId:BottomAxisId yAxisId:LeftAxisId seriesName:@"Green line" color:0xFF279B27]];
        [surface.renderableSeries add:[self getRenderableSeriesWithXAxisId:TopAxisId yAxisId:RightAxisId seriesName:@"Orange line" color:0xFFFC9C29]];
        [surface.renderableSeries add:[self getRenderableSeriesWithXAxisId:TopAxisId yAxisId:RightAxisId seriesName:@"Blue line" color:0xFF4083B7]];
        
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new], topAxisDrag, bottomAxisDrag, leftAxisDrag, rightAxisDrag, [SCILegendModifier new]]];
    }];
}

- (SCIFastLineRenderableSeries *)getRenderableSeriesWithXAxisId:(NSString*)xAxisId yAxisId:(NSString*)yAxisId seriesName:(NSString *)seriesName color:(uint)color {
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries.seriesName = seriesName;
    
    double randomWalk = 10;
    for (int i = 0; i < 150; i++) {
        randomWalk += [RandomUtil nextDouble] - 0.498;
        [dataSeries appendX:SCIGeneric(i) Y:SCIGeneric(randomWalk)];
    }
    
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness: 1.0];
    rSeries.xAxisId = xAxisId;
    rSeries.yAxisId = yAxisId;
    rSeries.dataSeries = dataSeries;

    [rSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    
    return rSeries;
}

@end
