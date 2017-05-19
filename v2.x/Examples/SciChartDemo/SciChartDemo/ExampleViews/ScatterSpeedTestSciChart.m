//
//  ScatterSpeedTestSciChart.m
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/20/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <SciChart/SciChart.h>
#import "ScatterSpeedTestSciChart.h"
#import "BrownianMotionGenerator.h"
#import "RandomUtil.h"

@implementation ScatterSpeedTestSciChart{
    SCINumericAxis * _xAxis;
    SCINumericAxis * _yAxis;
    double deviation;
    SCIXyDataSeries * scatterDataSeries;
    BrownianMotionGenerator * randomWalkGenerator;
}

@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        randomWalkGenerator = [[BrownianMotionGenerator alloc]init];
        self.surface = [[SCIChartSurface alloc]init];
        
        [self.surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:self.surface];
        
        NSDictionary *layout = @{@"SciChart":self.surface};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        self.chartProviderName = @"SciChart";
    }
    
    return self;
}

-(double) randf:(double) min max:(double) max {
    return [RandomUtil nextDouble] * (max - min) + min;
}

-(void) initializeSurfaceData:(TestParameters) testParameters {
    
    self.surface.backgroundColor = [UIColor fromARGBColorCode:0xFF1c1c1e];
    self.surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e];
    [self.surface.renderSurface setReduceCPUFrames:NO];
    
    SCISolidPenStyle  *majorPen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF323539 withThickness:0.5];
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
    [axisStyle setDrawMinorGridLines:TRUE];
    [axisStyle setDrawMajorBands:TRUE];
    
    _xAxis = [[SCINumericAxis alloc] init];
    [_xAxis setAxisId: @"xAxis"];
    [_xAxis setStyle: axisStyle];
    //    [_xAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [_xAxis setAutoRange:SCIAutoRange_Once];
    [self.surface.xAxes add:_xAxis];
    
    _yAxis = [[SCINumericAxis alloc] init];
    [_yAxis setAxisId: @"yAxis"];
    [_yAxis setStyle: axisStyle];
    //    [_yAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    //    [_yAxis setAutoRange:SCIAutoRange_Always];
    [_yAxis setVisibleRange:[[SCIDoubleRange alloc] initWithMin:(SCIGeneric(-50)) Max:(SCIGeneric(50))]];
    [self.surface.yAxes add:_yAxis];
    
    //Getting Fourier dataSeries
    scatterDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    
    //Getting dataSeries
    NSMutableArray* randomWalkData = [randomWalkGenerator getXyData:testParameters.PointCount :-50 :50];
    
    for(int i=0; i<testParameters.PointCount; i++){
        double x = [[[randomWalkData objectAtIndex:0] objectAtIndex:i] doubleValue];
        double y = [[[randomWalkData objectAtIndex:1] objectAtIndex:i] doubleValue];
        [scatterDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    };
    
    SCIXyScatterRenderableSeries * xyScatterRenderableSeries = [[SCIXyScatterRenderableSeries alloc] init];
    
    scatterDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    scatterDataSeries.acceptUnsortedData = YES;
    SCICoreGraphicsPointMarker * marker = [[SCICoreGraphicsPointMarker alloc] init];
    marker.width = 6;
    marker.height = 6;
    xyScatterRenderableSeries.style.pointMarker = marker;
    xyScatterRenderableSeries.xAxisId = _xAxis.axisId;
    xyScatterRenderableSeries.yAxisId = _yAxis.axisId;
    xyScatterRenderableSeries.dataSeries = scatterDataSeries;
    
    xyScatterRenderableSeries.xAxisId = _xAxis.axisId;
    xyScatterRenderableSeries.yAxisId = _yAxis.axisId;
    [self.surface.renderableSeries add:xyScatterRenderableSeries];
    [self.surface invalidateElement];
}

static double randf(double min, double max) {
    return [RandomUtil nextDouble] * (max - min) + min;
}

#pragma SpeedTest implementation

-(void)runTest:(TestParameters)testParameters{
    if (!scatterDataSeries) {
        [self initializeSurfaceData:testParameters];
    }
}

-(void)updateChart{
    [self.testCase chartExampleStarted];
    
    for (int i=0; i<scatterDataSeries.count; i++){
        
        SCIGenericType x = [[scatterDataSeries xValues] valueAt:i];
        SCIGenericType y = [[scatterDataSeries yValues] valueAt:i];
        
        [scatterDataSeries updateAt:i X:SCIGeneric(SCIGenericDouble(x) + randf(-1.0, 1.0))
                                      Y:SCIGeneric(SCIGenericDouble(y) + randf(-0.5, 0.5))];
    }
    
    [self.surface invalidateElement];
}


-(void)stopTest{
    [self.testCase processCompleted];
}

@end
