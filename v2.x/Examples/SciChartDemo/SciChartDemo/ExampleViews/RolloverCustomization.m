//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RolloverCustomization.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "RolloverCustomization.h"
#import <SciChart/SciChart.h>

@implementation RolloverCustomization

@synthesize sciChartSurfaceView;
@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
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

- (void)initializeSurfaceData {
    [self prepare];
    [self addAxes];
    [self addModifiers];
    [self initializeSurfaceRenderableSeries];
}

- (void)prepare {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCIBrushSolid alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCIBrushSolid alloc] initWithColorCode:0xFF1c1c1e]];
}

- (void)addAxes{
    SCIPenSolid * majorPen = [[SCIPenSolid alloc] initWithColorCode:0xFF323539 Width:0.5];
    SCIBrushSolid * gridBandPen = [[SCIBrushSolid alloc] initWithColorCode:0xE1202123];
    SCIPenSolid * minorPen = [[SCIPenSolid alloc] initWithColorCode:0xFF232426 Width:0.5];
    
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
    [surface attachAxis:axis IsXAxis:NO];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [surface attachAxis:axis IsXAxis:YES];
}

- (void)addModifiers{
    SCIRolloverModifier *rolloverModifier = [SCIRolloverModifier new];
    
    
    surface.chartModifier = rolloverModifier;
    
}

- (void)initializeSurfaceRenderableSeries{
    [self attachRenderebleSeriesWithYValue:1000 andColor:[UIColor yellowColor] seriesName:@"Curve A" isVisible:YES];
    [self attachRenderebleSeriesWithYValue:2000 andColor:[UIColor greenColor] seriesName:@"Curve B" isVisible:YES];
}

- (void)attachRenderebleSeriesWithYValue:(double)yValue
                                andColor:(UIColor*)color
                              seriesName:(NSString*)seriesName
                               isVisible:(BOOL)isVisible {
    int dataCount = 10;
    
    SCIXyDataSeries * dataSeries1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    
    double y = yValue;
    
    for (int i = 1; i <= dataCount; i++) {
        double x = i;
        y = yValue + y;
        [dataSeries1 appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    dataSeries1.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    dataSeries1.seriesName = seriesName;
    
    SCIFastLineRenderableSeries *renderableSeries1 = [SCIFastLineRenderableSeries new];
    [renderableSeries1.style setLinePen: [[SCIPenSolid alloc] initWithColor:color Width:0.7]];
    [renderableSeries1 setXAxisId: @"xAxis"];
    [renderableSeries1 setYAxisId: @"yAxis"];
    [renderableSeries1 setDataSeries:dataSeries1];
    renderableSeries1.isVisible = isVisible;
    
    [surface attachRenderableSeries:renderableSeries1];
    [surface invalidateElement];
}

@end
