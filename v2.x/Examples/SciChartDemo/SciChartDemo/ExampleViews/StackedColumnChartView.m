//
//  StackedColumnChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 9/24/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "StackedColumnChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation StackedColumnChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) prepare {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
}

-(void) initializeSurfaceData {
    [self prepare];
    
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.6];
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:16];
    [textFormatting setFontName:@"Helvetica"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting ];
    [axisStyle setDrawMinorGridLines:YES];
    [axisStyle setDrawMajorBands:YES];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    axis.axisId = @"yAxis";
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setAxisAlignment:SCIAxisAlignment_Bottom];
    [axis setFlipCoordinates:YES];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [axis setAxisAlignment:SCIAxisAlignment_Right];
    [surface.xAxes add:axis];
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.axisId = @"xAxis";
    xDragModifier.dragMode = SCIAxisDragMode_Scale;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.axisId = @"yAxis";
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    
    
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIRolloverModifier * rollover = [[SCIRolloverModifier alloc] init];
    
    [rollover setModifierName:@"Rollover Modifier"];
    [zem setModifierName:@"ZoomExtents Modifier"];
    [pzm setModifierName:@"PinchZoom Modifier"];
    [yDragModifier setModifierName:@"Y Axis Drag Modifier"];
    [xDragModifier setModifierName:@"X Axis Drag Modifier"];
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[xDragModifier, yDragModifier, pzm, zem, rollover]];
    surface.chartModifier = gm;
    
    [self attachStackedMountainRenderableSeries];
    
    [surface invalidateElement];
}

-(void) attachStackedMountainRenderableSeries {
    
    SCIVerticallyStackedColumnsCollection *stackedGroup = [SCIVerticallyStackedColumnsCollection new];
    [stackedGroup add:[self p_getRenderableSeries:0 andFillColorStart:0xff3D5568 andfinish:0xff567893]];
    [stackedGroup add:[self p_getRenderableSeries:1 andFillColorStart:0xff439aaf andfinish:0xffACBCCA]];
    [stackedGroup add:[self p_getRenderableSeries:2 andFillColorStart:0xffb6c1c3 andfinish:0xffdbe0e1]];
    [stackedGroup setXAxisId: @"xAxis"];
    [stackedGroup setYAxisId: @"yAxis"];
    
    [self.surface.renderableSeries add:stackedGroup];

}

- (SCIStackedColumnRenderableSeries*)p_getRenderableSeries:(int)index
                                         andFillColorStart:(uint)fillColor
                                                 andfinish:(uint)finishColor {
    
    SCIStackedColumnRenderableSeries *renderableSeries = [SCIStackedColumnRenderableSeries new];
    renderableSeries.style.fillBrush = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:fillColor finish:finishColor direction:SCILinearGradientDirection_Horizontal];
    renderableSeries.style.borderPen = [[SCISolidPenStyle alloc] initWithColor:[UIColor blackColor] withThickness:0.5];
    renderableSeries.style.drawBorders = YES;
    renderableSeries.dataSeries = [DataManager stackedBarChartSeries][index];
    renderableSeries.xAxisId = @"xAxis";
    renderableSeries.yAxisId = @"yAxis";
    
    return renderableSeries;
}


@end
