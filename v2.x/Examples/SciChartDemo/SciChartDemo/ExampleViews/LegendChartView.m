//
//  LegendChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 8/3/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "LegendChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import <Accelerate/Accelerate.h>

@implementation LegendChartView


@synthesize surface;

- (void)addModifiers{
    SCILegendModifier *modifier = [[SCILegendModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop andOrientation:SCIOrientationVertical];
    [surface.chartModifiers add:modifier];
}

- (void)initializeSurfaceRenderableSeries{
    [self attachRenderebleSeriesWithYValue:1000 andColor:[UIColor yellowColor] seriesName:@"Curve A" isVisible:YES];
    [self attachRenderebleSeriesWithYValue:2000 andColor:[UIColor greenColor] seriesName:@"Curve B" isVisible:YES];
    [self attachRenderebleSeriesWithYValue:3000 andColor:[UIColor redColor] seriesName:@"Curve C" isVisible:YES];
    [self attachRenderebleSeriesWithYValue:4000 andColor:[UIColor blueColor] seriesName:@"Curve D" isVisible:NO];
}

- (void)attachRenderebleSeriesWithYValue:(double)yValue
                                andColor:(UIColor*)color
                              seriesName:(NSString*)seriesName
                               isVisible:(BOOL)isVisible {
    int dataCount = 10;
    
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    
    double y = yValue;
    
    for (int i = 0; i <= dataCount; i++) {
        double x = i*10;
        y = yValue + y;
        [dataSeries1 appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    dataSeries1.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    dataSeries1.seriesName = seriesName;
    
    SCIFastLineRenderableSeries *renderableSeries1 = [SCIFastLineRenderableSeries new];
    [renderableSeries1 setStrokeStyle: [[SCISolidPenStyle alloc] initWithColor:color withThickness:0.7]];
    [renderableSeries1 setXAxisId: @"xAxis"];
    [renderableSeries1 setYAxisId: @"yAxis"];
    [renderableSeries1 setDataSeries:dataSeries1];
    renderableSeries1.isVisible = isVisible;
    
    SCIDrawLineRenderableSeriesAnimation *animation = [[SCIDrawLineRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut];
    [animation startAfterDelay:0.3];
    [renderableSeries1 addAnimation:animation];
    
    [surface.renderableSeries add:renderableSeries1];
    [surface invalidateElement];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
        surface = view;
        
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
    
    self.surface.backgroundColor = [UIColor fromARGBColorCode:0xFF1c1c1e];
    self.surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e];
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
}

- (void)addAxes{
    SCISolidPenStyle * majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
    SCISolidBrushStyle * gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    SCISolidPenStyle * minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
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
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [surface.xAxes add:axis];
}

@end
