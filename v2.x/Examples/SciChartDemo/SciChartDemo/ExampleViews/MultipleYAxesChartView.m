//
//  MultipleYAxesChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/4/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "MultipleYAxesChartView.h"
#import "DataManager.h"

@implementation MultipleYAxesChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) createBandRenderableSeries{
    SCIXyDataSeries *fourierDataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    
    [DataManager getFourierSeries:fourierDataSeries amplitude:1.0 phaseShift:0.1 count:5000];
    [DataManager getDampedSinwave:1500 aplitude:3.0 phase:0.0 dampingFactor:0.005 count:5000 freq:10 dataSeries:lineDataSeries];
    
    SCIFastLineRenderableSeries * fourierRenderableSeries = [[SCIFastLineRenderableSeries alloc] init];
    [fourierRenderableSeries setDataSeries:fourierDataSeries];
    [fourierRenderableSeries.style setLinePen:[[SCISolidPenStyle alloc]initWithColorCode:0xFF0944CF withThickness:1.0]];
    [fourierRenderableSeries setYAxisId:@"leftAxisId"];
    
    SCIFastLineRenderableSeries *lineRenderableSeries = [SCIFastLineRenderableSeries new];
    [lineRenderableSeries setDataSeries:lineDataSeries];
    [lineRenderableSeries.style setLinePen: [[SCISolidPenStyle alloc]initWithColorCode:0xFF279B27 withThickness:2.0]];
    [lineRenderableSeries setYAxisId:@"rightAxisId"];
    
    [surface.renderableSeries add:fourierRenderableSeries];
    [surface.renderableSeries add:lineRenderableSeries];
    
    [surface invalidateElement];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]init];
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

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
    [self createBandRenderableSeries];
    
    SCITextFormattingStyle *  bottomTextFormatting= [[SCITextFormattingStyle alloc] init];
    [bottomTextFormatting setFontSize: 12];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    [axis setAxisTitle:@"Bottom Axis"];
    [axis.style setLabelStyle:bottomTextFormatting];
    [axis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [surface.xAxes add:axis];
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize: 12];
    [textFormatting setColorCode: 0xFF4083B7];
    
    SCITextFormattingStyle *  rightTextFormatting= [[SCITextFormattingStyle alloc] init];
    [rightTextFormatting setFontSize: 12];
    [rightTextFormatting setColorCode: 0xFF279B27];
    
    id<SCIAxis2DProtocol> rightYAxis = [[SCINumericAxis alloc] init];
    [rightYAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [rightYAxis setAxisTitle:@"Right Axis"];
    [rightYAxis.style setLabelStyle: rightTextFormatting];
    [rightYAxis setAxisId:@"rightAxisId"];
    [rightYAxis setAxisAlignment:SCIAxisAlignment_Right];
    [surface.yAxes add:rightYAxis];
    
    id<SCIAxis2DProtocol> leftYAxis = [[SCINumericAxis alloc] init];
    [leftYAxis setGrowBy: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)]];
    [leftYAxis setAxisId:@"leftAxisId"];
    [leftYAxis setAxisTitle:@"Left Axis"];
    [leftYAxis.style setLabelStyle: textFormatting];
    [leftYAxis setAxisAlignment:SCIAxisAlignment_Left];
    [surface.yAxes add:leftYAxis];
    
    [surface invalidateElement];
}

@end
