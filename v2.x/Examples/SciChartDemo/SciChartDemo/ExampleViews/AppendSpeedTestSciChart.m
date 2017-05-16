//
//  AppendSpeedTestSciChart.m
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 21.04.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "AppendSpeedTestSciChart.h"
#import <SciChart/SciChart.h>
#include <math.h>
#import "RandomWalkGenerator.h"
#import "DigitalLineChartView.h"

@implementation AppendSpeedTestSciChart {
    SCIXyDataSeries * dataSeries;
    
    TestParameters TestParameters;
    RandomWalkGenerator* randomWalkGenerator;
    int appendCount;
    int xCount;
}

@synthesize sciChartSurfaceView;
@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        
        xCount = 0;
        
        randomWalkGenerator = [[RandomWalkGenerator alloc]init];
        
        self.sciChartSurfaceView = [[SCIChartSurfaceView alloc]init];
        [self.sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.sciChartSurfaceView];
                
        NSDictionary *layout = @{@"SciChart":self.sciChartSurfaceView};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        self.chartProviderName = @"SciChart";
        [self initializeSurface];
    }
    return self;
}

-(void) prepare {
    self.surface = [[SCIChartSurface alloc] initWithView: self.sciChartSurfaceView];
    [self.surface.renderSurface setReduceGPUFrames:YES]; // set NO for Debug
    
    [[self.surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[self.surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
}

-(void) initializeSurface {
    [self prepare];
    
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.6];
    
    SCISolidBrushStyle  *gridBandPen = [[SCISolidBrushStyle alloc] initWithColorCode:0xE1202123];
    
    SCISolidPenStyle  *minorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232426 withThickness:0.5];
    
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize:10];
    [textFormatting setFontName:@"Arial"];
    [textFormatting setColorCode:0xFFb6b3af];
    
    SCIAxisStyle * axisStyle = [[SCIAxisStyle alloc]init];
    [axisStyle setMajorTickBrush:majorPen];
    [axisStyle setGridBandBrush: gridBandPen];
    [axisStyle setMajorGridLineBrush:majorPen];
    [axisStyle setMinorTickBrush:minorPen];
    [axisStyle setMinorGridLineBrush:minorPen];
    [axisStyle setLabelStyle:textFormatting ];
    [axisStyle setDrawMinorGridLines:TRUE];
    [axisStyle setDrawMajorBands:TRUE];
    
    float updateTime = 1.0f / 30.0f;
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setStyle: axisStyle];
    [axis setAutoRange:SCIAutoRange_Always];
    axis.animatedChangeDuration = updateTime*2;
    axis.animateVisibleRangeChanges = YES;
    
    axis.axisId = @"yAxis";
//    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [self.surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setAutoRange:SCIAutoRange_Always];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    axis.animatedChangeDuration = updateTime*2;
    axis.animateVisibleRangeChanges = YES;
//    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [self.surface.xAxes add:axis];

}

-(void) initializeSurfaceData {
    [self.surface.renderableSeries clear];
    xCount = 0;
    id<SCIRenderableSeriesProtocol> rSeries = [self getECGRenderableSeries];
    rSeries.xAxisId = @"xAxis";
    rSeries.yAxisId = @"yAxis";
    [self.surface.renderableSeries add:rSeries];
    [self.surface invalidateElement];
}

-(SCIFastLineRenderableSeries*) getECGRenderableSeries{
    
    dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    
    NSMutableArray* randomWalkData = [randomWalkGenerator GetRandomWalkSeries:self->TestParameters.PointCount min:-0.5 max:0.5 includePrior:YES];
    
    for(int i=0; i<self->TestParameters.PointCount; i++){
        double x = [[[randomWalkData objectAtIndex:0] objectAtIndex:i] doubleValue];
        double y = [[[randomWalkData objectAtIndex:1] objectAtIndex:i] doubleValue];
        [dataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
        xCount++;
    };
    
    dataSeries.seriesName = @"ECG";
    dataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastLineRenderableSeries * ecgRenderableSeries = [[SCIFastLineRenderableSeries alloc] init];
    
    [ecgRenderableSeries setStrokeStyle:[[SCISolidPenStyle alloc] initWithColorCode:0xFFffffff withThickness:self->TestParameters.StrokeThikness]];
    [ecgRenderableSeries setXAxisId: @"xAxis"];
    [ecgRenderableSeries setYAxisId: @"yAxis"];
    [ecgRenderableSeries setDataSeries:dataSeries];
    
    return ecgRenderableSeries;
}

#pragma SpeedTest implementation

-(void)runTest:(TestParameters)testParameters{
    self->TestParameters = testParameters;
    appendCount = testParameters.AppendPoints;
    [self initializeSurfaceData];
}

-(void)updateChart{
    [self.testCase chartExampleStarted];
    
    for (int i = 0; i < appendCount; i++){
        [dataSeries appendX:SCIGeneric(xCount) Y:SCIGeneric([randomWalkGenerator next:-0.5 :0.5 :YES])];
        xCount++;
    }
    
    [self.surface invalidateElement];
}


-(void)stopTest{
    [self.testCase processCompleted];
}

@end
