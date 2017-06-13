//
//  SCDSeriesAppendingTestSciChart.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 6/17/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "SCDSeriesAppendingTestSciChart.h"
#import <SciChart/SciChart.h>
#include <math.h>
#import "RandomWalkGenerator.h"

@implementation SCDSeriesAppendingTestSciChart {
    NSMutableArray <SCIXyDataSeries*> * _dataSeries;
    
    TestParameters TestParameters;
    RandomWalkGenerator* randomWalkGenerator;
    int appendCount;
    int xCount;
    int _seriesNumber;
    
    NSArray <UIColor *> *_paliteColors;
    UILabel *_generalCountOfPoints;
}


@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    if ((self = [super initWithFrame:frame])) {
        
        xCount = 0;
        
        randomWalkGenerator = [[RandomWalkGenerator alloc]init];
        
        self.surface = [[SCIChartSurface alloc]init];
        [self.surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:self.surface];
        
        NSDictionary *layout = @{@"SciChart":self.surface};
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        _generalCountOfPoints = [[UILabel alloc] initWithFrame:CGRectMake(16, 16, .0, .0)];
        _generalCountOfPoints.font = [UIFont systemFontOfSize:14.f];
        _generalCountOfPoints.textColor = [UIColor whiteColor];
        [self addSubview:_generalCountOfPoints];
        
        _dataSeries = [NSMutableArray new];
        
        self.chartProviderName = @"SciChart";
        
        _paliteColors = @[[UIColor colorWithRed:229/255.f green:75/255.f blue:21/255.f alpha:1.f],
                          [UIColor colorWithRed:64/255.f green:131/255.f blue:183/255.f alpha:1.f],
                          [UIColor colorWithRed:254/255.f green:165/255.f blue:1/255.f alpha:1.f]];
        
        [self initializeSurface];
    }
    return self;
}

-(void) initializeSurface {

    [self.surface.renderSurface setReduceGPUFrames:YES]; // set NO for Debug
    self.surface.backgroundColor = [UIColor fromARGBColorCode:0xFF1c1c1e];
    self.surface.renderableSeriesAreaFill = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF1c1c1e];
    
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
    [self.surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setAutoRange:SCIAutoRange_Always];
    axis.axisId = @"xAxis";
    [axis setStyle: axisStyle];
    axis.animatedChangeDuration = updateTime*2;
    axis.animateVisibleRangeChanges = YES;
    [self.surface.xAxes add:axis];
    
}

-(void) initializeSurfaceData {
    
    [_dataSeries removeAllObjects];

    [self.surface.renderableSeries clear];
    
    int colorIndex = 0;
    xCount = 0;
    
    for (int i = 0; i < _seriesNumber; i++) {
        if (colorIndex > _paliteColors.count-1)
            colorIndex = 0;
        
        [self addSeries:[self getECGRenderableSeriesWithColorLine:_paliteColors[colorIndex]]];
        xCount = self->TestParameters.PointCount;
        colorIndex++;
    }
}

-(SCIFastLineRenderableSeries*) getECGRenderableSeriesWithColorLine:(UIColor*)color{
    
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    
    NSMutableArray* randomWalkData = [randomWalkGenerator GetRandomWalkSeries:self->TestParameters.PointCount min:-0.5 max:0.5 includePrior:YES];
    
    for(int i=0; i<self->TestParameters.PointCount; i++){
        double x = [[[randomWalkData objectAtIndex:0] objectAtIndex:i] doubleValue];
        double y = [[[randomWalkData objectAtIndex:1] objectAtIndex:i] doubleValue];
        [dataSeries appendX:SCIGeneric(x) Y:SCIGeneric(y)];
    };
    
    dataSeries.seriesName = @"ECG";
    dataSeries.dataDistributionCalculator = [SCIUserDefinedDistributionCalculator new];
    
    SCIFastLineRenderableSeries * ecgRenderableSeries = [[SCIFastLineRenderableSeries alloc] init];
    
    
    [ecgRenderableSeries setStrokeStyle:[[SCISolidPenStyle alloc] initWithColor:color withThickness:0.5f]];
    [ecgRenderableSeries setXAxisId: @"xAxis"];
    [ecgRenderableSeries setYAxisId: @"yAxis"];
    [ecgRenderableSeries setDataSeries:dataSeries];
    
    [_dataSeries addObject:dataSeries];
    return ecgRenderableSeries;
}

-(void) addSeries:(id<SCIRenderableSeriesProtocol>)series {
    if (series.xAxisId == nil || series.yAxisId == nil) {
        series.xAxisId = @"xAxis";
        series.yAxisId = @"yAxis";
    }
    [self.surface.renderableSeries add:series];
}

#pragma SpeedTest implementation

-(void)runTest:(TestParameters)testParameters{
    self->TestParameters = testParameters;
    appendCount = testParameters.AppendPoints;
    _seriesNumber = testParameters.SeriesNumber;
    [self initializeSurfaceData];
}

-(void)updateChart{
    [self.testCase chartExampleStarted];
    
    int countPoints = 0;
    for (SCIXyDataSeries *currentDataSeries in _dataSeries) {
        for (int i = xCount; i < appendCount + xCount; i++){
            [currentDataSeries appendX:SCIGeneric(i)
                                     Y:SCIGeneric([randomWalkGenerator next:-0.5 :0.5 :YES])];
        }
        countPoints = countPoints + currentDataSeries.count;
    }
    xCount += appendCount;

    _generalCountOfPoints.text = [NSString stringWithFormat:@"Amount of points: %li", (long)countPoints];
    [_generalCountOfPoints sizeToFit];
    
    [self.surface invalidateElement];
    
    if (countPoints > 1000000) {
        [self stopTest];
    }
}

- (void)stopTest{
    [self.testCase processCompleted];
}

@end

