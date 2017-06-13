//
//  ToolTipCustomization.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 8/26/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "UsingTooltipModifierChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation UsingTooltipModifierChartView


@synthesize surface;

- (void)addModifiers{
    SCITooltipModifier *toolTipModifier = [[SCITooltipModifier alloc] init];
    toolTipModifier.style.colorMode = SCITooltipColorMode_SeriesColorToDataView;
    [self.surface.chartModifiers add:toolTipModifier];
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
    [axis setAutoRange:SCIAutoRange_Never];
    [axis setVisibleRange:[[SCIDoubleRange alloc]initWithMin:SCIGeneric(-1.5) Max:SCIGeneric(1.5)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    [axis setVisibleRange:[[SCIDoubleRange alloc]initWithMin:SCIGeneric(0) Max:SCIGeneric(10)]];
    [axis setAutoRange:SCIAutoRange_Never];
    [surface.xAxes add:axis];
    
}

- (void)initializeSurfaceRenderableSeries{
    [self attachLissajousCurveSeries];
    [self attachSinewaveSeries];
}

- (void)attachSinewaveSeries {
    
    int dataCount = 500;
    int freq = 10;
    double amplitude = 1.5f;
    double phase = 1.0f;
    
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    dataSeries.seriesName = @"Sinewave";
    
    for (int i = 0; i < dataCount; i++) {
        double x = 10 * i / (double)dataCount;
        double wn = 2 * M_PI / (dataCount / (double)freq);
        double y = amplitude * sin(i*wn+phase);
        [dataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
    SCIFastLineRenderableSeries * rSeries = [[SCIFastLineRenderableSeries alloc] init];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:255.f/255.f
                                                                               green:51.f/255.f
                                                                                blue:51.f/255.f
                                                                               alpha:1.f]
                                                         withThickness:0.5];
    [rSeries setXAxisId: @"xAxis"];
    [rSeries setYAxisId: @"yAxis"];
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setStrokeStyle:nil];
    [ellipsePointMarker setFillStyle:[[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:255.f/255.f
                                                                                          green:51.f/255.f
                                                                                           blue:51.f/255.f
                                                                                          alpha:1.f]]];
    [ellipsePointMarker setHeight:5];
    [ellipsePointMarker setWidth:5];
    rSeries.style.pointMarker = ellipsePointMarker;
    rSeries.dataSeries = dataSeries;
    
    [surface.renderableSeries add:rSeries];
    [surface invalidateElement];
}

- (void)attachLissajousCurveSeries {
    
    int dataCount = 500;
    float alpha = 0.8f;
    float beta = 0.2f;
    float delta = 0.43f;
    
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries.acceptUnsortedData = YES;
    SCIUserDefinedDistributionCalculator *distributionCalculator = [SCIUserDefinedDistributionCalculator new];
    dataSeries.dataDistributionCalculator = distributionCalculator;
    dataSeries.seriesName = @"Lissajou";
    
    for (int i = 0; i < dataCount; i++) {
        double x = sin(alpha*i*0.1 + delta);
        double y = sin(beta*i*0.1);
        [dataSeries appendX:SCIGeneric((x+1.f)*5.f) Y:SCIGeneric(y)];
    }
    
    SCIFastLineRenderableSeries * rSeries = [[SCIFastLineRenderableSeries alloc] init];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor colorWithRed:70.f/255.f
                                                                               green:130.f/255.f
                                                                                blue:180.f/255.f
                                                                               alpha:1.f]
                                                         withThickness:0.5];
    [rSeries setXAxisId: @"xAxis"];
    [rSeries setYAxisId: @"yAxis"];
    
    SCIEllipsePointMarker * ellipsePointMarker = [[SCIEllipsePointMarker alloc]init];
    [ellipsePointMarker setStrokeStyle:nil];
    [ellipsePointMarker setFillStyle:[[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:70.f/255.f
                                                                                          green:130.f/255.f
                                                                                           blue:180.f/255.f
                                                                                          alpha:1.f]]];
    [ellipsePointMarker setHeight:5];
    [ellipsePointMarker setWidth:5];
    rSeries.style.pointMarker = ellipsePointMarker;
    rSeries.dataSeries = dataSeries;
    
    [surface.renderableSeries add:rSeries];
    [surface invalidateElement];
    
}

@end
