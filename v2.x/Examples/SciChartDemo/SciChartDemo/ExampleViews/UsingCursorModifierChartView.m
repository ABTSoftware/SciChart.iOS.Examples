//
//  CursorCustomization.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 8/26/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "UsingCursorModifierChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation UsingCursorModifierChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

- (void)addModifiers{
    SCICursorModifier *toolTipModifier = [[SCICursorModifier alloc] init];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.maximumFractionDigits = 0;
    toolTipModifier.style.numberFormatter = numberFormatter;
    toolTipModifier.style.colorMode = SCITooltipColorMode_SeriesColorToDataView;
    self.surface.chartModifier = toolTipModifier;
}

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
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [[surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
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

- (void)initializeSurfaceRenderableSeries {
    
    SCIRenderableSeriesBase * green = [self rSeriesCreateWithColor:[UIColor greenColor]];
    green.dataSeries.seriesName = @"Green";
    [self generateSinewaveSeriesWithAmplitude:300.0
                                        phase:1.0
                                     dataCout:300
                               noiseAmplitude:.25
                               intoDataSeries:green.dataSeries];
    
    SCIRenderableSeriesBase * red = [self rSeriesCreateWithColor:[UIColor redColor]];
    red.dataSeries.seriesName = @"Red";
    [self generateSinewaveSeriesWithAmplitude:100.0
                                        phase:2.0
                                     dataCout:300
                               noiseAmplitude:0.0
                               intoDataSeries:red.dataSeries];
    
    SCIRenderableSeriesBase * gray = [self rSeriesCreateWithColor:[UIColor grayColor]];
    gray.dataSeries.seriesName = @"Gray";
    [self generateSinewaveSeriesWithAmplitude:200.0
                                        phase:1.5
                                     dataCout:300
                               noiseAmplitude:0.0
                               intoDataSeries:gray.dataSeries];
    
    [surface invalidateElement];
}

- (SCIRenderableSeriesBase*)rSeriesCreateWithColor:(UIColor*)color {
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    dataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    SCIFastLineRenderableSeries * rSeries = [[SCIFastLineRenderableSeries alloc] init];
    rSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColor:color
                                                         withThickness:0.5];
    [rSeries setXAxisId: @"xAxis"];
    [rSeries setYAxisId: @"yAxis"];
    rSeries.dataSeries = dataSeries;
    [surface.renderableSeries add:rSeries];
    return rSeries;
}

- (void)generateSinewaveSeriesWithAmplitude:(double)amplitude
                                      phase:(double)phase
                                   dataCout:(int)dataCount
                             noiseAmplitude:(double)noise
                             intoDataSeries:(id<SCIDataSeriesProtocol>)dataSeries {
    
    int freq = 10;
    
    for (int i = 0; i < dataCount; i++) {
        double x = 10 * i / (double)dataCount;
        double wn = 2 * M_PI / (dataCount / (double)freq);
        double y = amplitude * sin(i*wn+phase);
        if (noise > 0.f) {
            y = y + randf(-5, 5)*noise - noise*0.5;
        }
        [dataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    }
    
}

@end
