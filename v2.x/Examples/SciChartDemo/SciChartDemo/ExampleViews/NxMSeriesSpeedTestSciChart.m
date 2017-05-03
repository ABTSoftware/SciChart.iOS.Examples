//
//  NxMSeriesSpeedTestSciChart.m
//  ComparisonApp
//
//  Created by Yaroslav Pelyukh on 4/13/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "NxMSeriesSpeedTestSciChart.h"
#import <SciChart/SciChart.h>
#import "RandomWalkGenerator.h"

@implementation NxMSeriesSpeedTestSciChart{
    SCINumericAxis * _xAxis;
    SCINumericAxis * _yAxis;
    NSMutableArray * fpsData;
    NSTimer *timer;
    double deviation;
    double duration;
    double startTime;
    double timeUpdate;
    CFTimeInterval startTimeEvent;
    int frameCount;
    RandomWalkGenerator * randomWalkGenerator;
    int updateNumber;
    double rangeMin, rangeMax;
}

@synthesize sciChartSurfaceView;
@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        fpsData = [[NSMutableArray alloc]init];
        self.sciChartSurfaceView = [[SCIChartSurfaceView alloc]init];
        
        [self.sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:self.sciChartSurfaceView];
        
        NSDictionary *layout = @{@"Charts":self.sciChartSurfaceView};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Charts]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Charts]-(0)-|" options:0 metrics:0 views:layout]];
        
        self.chartProviderName = @"SciChart";
        [self initializeSurface];
    }
    
    return self;
}

-(void) initializeSurface {
    self.surface = [[SCIChartSurface alloc] initWithView: self.sciChartSurfaceView];
    
    [[self.surface style] setBackgroundBrush: [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
    [[self.surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e]];
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
    [_yAxis setAutoRange:SCIAutoRange_Once];
    [self.surface.yAxes add:_yAxis];
    self.surface.style.rightAxisAreaSize = 30;
    self.surface.style.leftAxisAreaSize = 5;
    self.surface.style.bottomAxisAreaSize = 30;
    self.surface.style.topAxisAreaSize = 5;
}

-(void) initializeSurfaceData:(TestParameters) testParameters {
    [self.surface.renderableSeries clear];
    updateNumber = 0;
    
    uint color = 0xFFff8a4c;

    //Getting Fourier dataSeries
    for(int series=0; series < testParameters.SeriesNumber; series++){
        
        SCIXyDataSeries * fourierDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
        NSMutableArray* randomWalkData = [randomWalkGenerator GetRandomWalkSeries:testParameters.PointCount min:-0.5 max:0.5 includePrior:YES];
        
        for(int i=0; i<testParameters.PointCount; i++){
            double x = [[[randomWalkData objectAtIndex:0] objectAtIndex:i] doubleValue];
            double y = [[[randomWalkData objectAtIndex:1] objectAtIndex:i] doubleValue];
            [fourierDataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
        };
        
        color = (color + 0x10f00F) | 0xFF000000;
        fourierDataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
        
        SCIFastLineRenderableSeries * fourierRenderableSeries = [SCIFastLineRenderableSeries new];
        fourierRenderableSeries.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:color withThickness:0.5];
        [fourierRenderableSeries setDataSeries:fourierDataSeries];
        
        fourierRenderableSeries.xAxisId = _xAxis.axisId;
        fourierRenderableSeries.yAxisId = _yAxis.axisId;
        [self.surface.renderableSeries add:fourierRenderableSeries];
        [self.surface invalidateElement];
    }
}

#pragma SpeedTest implementation
-(void)runTest:(TestParameters)testParameters{
    rangeMin = NAN;
    rangeMax = NAN;
    randomWalkGenerator = [[RandomWalkGenerator alloc]init];
    [self initializeSurfaceData:testParameters];
    updateNumber = 0;
}

-(void)updateChart{
    [self.delegate chartExampleStarted];
    if(isnan(rangeMin)){
        rangeMin = SCIGenericDouble([[_yAxis visibleRange] min]);
        rangeMax = SCIGenericDouble([[_yAxis visibleRange] max]);
    }
    
    double scaleFactor = fabs(sin(updateNumber * 0.1)) + 0.5;
    [_yAxis setVisibleRange:[[SCIDoubleRange alloc] initWithMin:(SCIGeneric(rangeMin * scaleFactor))
                                                            Max:(SCIGeneric(rangeMax * scaleFactor))]];
    [self.surface invalidateElement];
    updateNumber++;
}


-(void)stopTest{
    [self.delegate processCompleted];
}

@end
