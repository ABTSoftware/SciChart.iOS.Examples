//
//  SecondaryYAxesChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/4/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "SecondaryYAxesChartView.h"
#import "DataManager.h"

@implementation SecondaryYAxesChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        sciChartSurfaceView = [[SCIChartSurfaceView alloc] init];
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    xAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.axisTitle = @"Bottom Axis";
    
    id<SCIAxis2DProtocol> rightYAxis = [[SCINumericAxis alloc] init];
    rightYAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    rightYAxis.axisId = @"rightAxisId";
    rightYAxis.axisTitle = @"Right Axis";
    rightYAxis.axisAlignment = SCIAxisAlignment_Right;
    rightYAxis.style.labelStyle.colorCode = 0xFF279B27;
    
    id<SCIAxis2DProtocol> leftYAxis = [[SCINumericAxis alloc] init];
    leftYAxis.growBy = [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    leftYAxis.axisId = @"leftAxisId";
    leftYAxis.axisTitle = @"Left Axis";
    leftYAxis.axisAlignment = SCIAxisAlignment_Left;
    leftYAxis.style.labelStyle.colorCode = 0xFF4083B7;

    SCIXyDataSeries *fourierDataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    
    [DataManager getFourierSeries:fourierDataSeries amplitude:1.0 phaseShift:0.1 count:5000];
    DoubleSeries *dampedSinewave = [DataManager getDampedSinewaveWithAmplitude:3.0 DampingFactor:0.005 PointCount:5000 Freq:10];
    [lineDataSeries appendRangeX:dampedSinewave.xValues Y:dampedSinewave.yValues Count:dampedSinewave.size];
    
    SCIFastLineRenderableSeries *fourierRenderableSeries = [[SCIFastLineRenderableSeries alloc] init];
    fourierRenderableSeries.dataSeries = fourierDataSeries;
    fourierRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF4083B7 withThickness:1.0];
    fourierRenderableSeries.yAxisId = @"leftAxisId";
    
    SCIFastLineRenderableSeries *lineRenderableSeries = [[SCIFastLineRenderableSeries alloc] init];
    lineRenderableSeries.dataSeries = lineDataSeries;
    lineRenderableSeries.strokeStyle = [[SCISolidPenStyle alloc]initWithColorCode:0xFF279B27 withThickness:2.0];
    lineRenderableSeries.yAxisId = @"rightAxisId";

    [surface.xAxes add:xAxis];
    [surface.yAxes add:leftYAxis];
    [surface.yAxes add:rightYAxis];
    [surface.renderableSeries add:fourierRenderableSeries];
    [surface.renderableSeries add:lineRenderableSeries];
    
    [surface invalidateElement];
}

@end
