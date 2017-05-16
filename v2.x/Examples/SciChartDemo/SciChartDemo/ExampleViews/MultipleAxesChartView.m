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

@implementation MultipleAxesChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        sciChartSurfaceView = [[SCIChartSurfaceView alloc]init];
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:sciChartSurfaceView];
        
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [self setupAxes];
    
    [self addRenderableSeriesWithFillData:@"xBottom" :@"yLeft" :0xFFFF1919];
    [self addRenderableSeriesWithFillData:@"xBottom" :@"yLeft" :0xFF279B27];
    [self addRenderableSeriesWithFillData:@"xTop" :@"yRight" :0xFFFC9C29];
    [self addRenderableSeriesWithFillData:@"xTop" :@"yRight" :0xFF4083B7];
    
    [self addModifiers];
    
    [surface invalidateElement];
}

-(void) setupAxes {
    id<SCIAxis2DProtocol> yAxisRight = [SCINumericAxis new];
    [yAxisRight setAxisId: @"yRight"];
    [yAxisRight setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [yAxisRight setAxisAlignment:SCIAxisAlignment_Right];
    yAxisRight.style.labelStyle.colorCode = 0xFF4083B7;
    [surface.yAxes add:yAxisRight];
    
    id<SCIAxis2DProtocol> yAxisLeft = [SCINumericAxis new];
    yAxisLeft.axisId = @"yLeft";
    [yAxisLeft setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [yAxisLeft setAxisAlignment:SCIAxisAlignment_Left];
    yAxisLeft.style.labelStyle.colorCode = 0xFFFC9C29;
    [surface.yAxes add:yAxisLeft];
    
    id<SCIAxis2DProtocol> xAxisBottom = [SCINumericAxis new];
    [xAxisBottom setAxisId: @"xBottom"];
    [xAxisBottom setAxisAlignment:SCIAxisAlignment_Bottom];
    xAxisBottom.style.labelStyle.colorCode = 0xFFFF1919;
    [surface.xAxes add:xAxisBottom];
    
    id<SCIAxis2DProtocol> xAxisTop = [SCINumericAxis new];
    xAxisTop.axisId = @"xTop";
    [xAxisTop setAxisAlignment:SCIAxisAlignment_Top];
    xAxisTop.style.labelStyle.colorCode = 0xFF279B27;
    [surface.xAxes add:xAxisTop];
}

-(void) addModifiers{
    SCIXAxisDragModifier * x1Drag = [SCIXAxisDragModifier new];
    x1Drag.axisId = @"xBottom";
    x1Drag.dragMode = SCIAxisDragMode_Scale;
    x1Drag.clipModeX = SCIClipMode_None;
    SCIXAxisDragModifier * x2Drag = [SCIXAxisDragModifier new];
    x2Drag.axisId = @"xTop";
    x2Drag.dragMode = SCIAxisDragMode_Scale;
    x2Drag.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * y1Drag = [SCIYAxisDragModifier new];
    y1Drag.axisId = @"yLeft";
    y1Drag.dragMode = SCIAxisDragMode_Pan;
    SCIYAxisDragModifier * y2Drag = [SCIYAxisDragModifier new];
    y2Drag.axisId = @"yRight";
    y2Drag.dragMode = SCIAxisDragMode_Pan;
    
    SCILegendCollectionModifier *legendModifier = [[SCILegendCollectionModifier alloc]init];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[ x1Drag, x2Drag, y1Drag, y2Drag, legendModifier ]];
    surface.chartModifiers = gm;
}

-(void) addRenderableSeriesWithFillData: (NSString*)xID :(NSString*)yID :(uint)colorCode{
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    
    double randomWalk = 10;
    for (int i = 0; i< 150; i++) {
        randomWalk += [RandomUtil nextDouble]  - 0.498;
        [dataSeries appendX:SCIGeneric(i) Y:SCIGeneric(randomWalk)];
    }
    
    SCIFastLineRenderableSeries * lineRenderableSeries = [SCIFastLineRenderableSeries new];
    [lineRenderableSeries setStrokeStyle: [[SCISolidPenStyle alloc] initWithColorCode:colorCode withThickness: 1.0]];
    [lineRenderableSeries setXAxisId: xID];
    [lineRenderableSeries setYAxisId: yID];
    [lineRenderableSeries setDataSeries: dataSeries];
    [surface.renderableSeries add:lineRenderableSeries];
}

@end
