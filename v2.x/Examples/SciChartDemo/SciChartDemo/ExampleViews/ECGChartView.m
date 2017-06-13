//
//  ECGChartView.m
//  SciChartDemo
//
//  Created by Admin on 21.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ECGChartView.h"
#import <SciChart/SciChart.h>
#include <math.h>
#include "DataManager.h"

@implementation ECGChartView{
    SCIXyDataSeries * oldData;
    SCIXyDataSeries * newData;
    SCIXyDataSeries * _sourceData;
    
    NSTimer *timer;
    int _currentIndex;
    int _totalIndex;
}


@synthesize surface;

-(void) createECGRenderableSeries{
    oldData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [oldData setFifoCapacity:1500];
    
    SCIFastLineRenderableSeries * wave1 = [[SCIFastLineRenderableSeries alloc] init];
    
    [wave1 setStrokeStyle:[[SCISolidPenStyle alloc] initWithColorCode:0xFFb3e8f6 withThickness:1]];
    [wave1 setXAxisId: @"xAxis"];
    [wave1 setYAxisId: @"yAxis"];
    [wave1 setDataSeries:oldData];
    [surface.renderableSeries add:wave1];
    
    newData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [newData setFifoCapacity:1500];
    
    SCIFastLineRenderableSeries * wave2 = [[SCIFastLineRenderableSeries alloc] init];
    
    [wave2 setStrokeStyle:[[SCISolidPenStyle alloc] initWithColorCode:0xFFb3e8f6 withThickness:1]];
    [wave2 setXAxisId: @"xAxis"];
    [wave2 setYAxisId: @"yAxis"];
    [wave2 setDataSeries:newData];
    [surface.renderableSeries add:wave2];
}

-(void)updateECGData:(NSTimer *)timer{
    for (int i = 0; i < 10; i++)
    [self AppendPoint:400];
}

-(void) AppendPoint:(double) sampleRate{
    if (_currentIndex >= 1800) {
        _currentIndex = 0;
        _totalIndex = 0;
        
        id swap = oldData;
        oldData = newData;
        newData = swap;
    }
    
    // Get the next voltage and time, and append to the chart
    double voltage = [[_sourceData yValues] valueAt:_currentIndex].floatData*1000;
    double time = _totalIndex / sampleRate;
    [newData appendX:SCIGeneric(time) Y:SCIGeneric(voltage)];
    [oldData appendX:SCIGeneric(time) Y:SCIGeneric(NAN)];
    [surface invalidateElement];
    _currentIndex++;
    _totalIndex++;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]init];
        surface = view;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:surface];
        NSDictionary *layout = @{@"SciChart":surface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        _currentIndex=0;
        _totalIndex =0;
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    
    
    _sourceData = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    [DataManager loadDataFromFile:_sourceData fileName:@"WaveformData"];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setAutoRange:SCIAutoRange_Never];
    [axis setAxisId: @"yAxis"];
    [axis setVisibleRange:[[SCIDoubleRange alloc] initWithMin:SCIGeneric(-400) Max:SCIGeneric(1200)]];
    [surface.yAxes add:axis];
    
    axis = [[SCINumericAxis alloc] init];
    [axis setAutoRange:SCIAutoRange_Never];
    axis.axisId = @"xAxis";
    [axis setVisibleRange:[[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(4.5)]];
    [surface.xAxes add:axis];
    
    [self createECGRenderableSeries];
    
    [surface invalidateElement];
}

- (void)willMoveToWindow:(UIWindow *)newWindow{
    [super willMoveToWindow: newWindow];
    if(timer == nil){
        timer = [NSTimer scheduledTimerWithTimeInterval:0.04
                                                 target:self
                                               selector:@selector(updateECGData:)
                                               userInfo:nil
                                                repeats:YES];
    } else {
        [timer invalidate];
        timer = nil;
    }
}

@end
