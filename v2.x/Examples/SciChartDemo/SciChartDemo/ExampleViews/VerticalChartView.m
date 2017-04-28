//
//  VerticalChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 4/5/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "VerticalChartView.h"
#import "DataManager.h"

@implementation VerticalChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

-(void) createBandRenderableSeries{
    SCIXyDataSeries *dataSeries1 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    SCIXyDataSeries *dataSeries2 = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    
    [DataManager getRandomDoubleSeries:dataSeries1 cound:20];
    [DataManager getRandomDoubleSeries:dataSeries2 cound:20];
    
    SCIFastLineRenderableSeries * lineSeries1 = [[SCIFastLineRenderableSeries alloc] init];
    [lineSeries1 setDataSeries:dataSeries1];
    [lineSeries1.style setLinePen:[[SCISolidPenStyle alloc]initWithColorCode:0xFF4682B4 withThickness:2.0]];
    
    SCIFastLineRenderableSeries *lineSeries2 = [SCIFastLineRenderableSeries new];
    [lineSeries2 setDataSeries:dataSeries2];
    [lineSeries2.style setLinePen: [[SCISolidPenStyle alloc]initWithColorCode:0xFF00FF00 withThickness:2.0]];
    
    [surface.renderableSeries add:lineSeries1];
    [surface.renderableSeries add:lineSeries2];
    
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
    
    SCITextFormattingStyle *  textFormatting= [[SCITextFormattingStyle alloc] init];
    [textFormatting setFontSize: 12];
    
    id<SCIAxis2DProtocol> axis = [[SCINumericAxis alloc] init];
    axis.axisAlignment = SCIAxisAlignment_Left;
    [axis setAxisTitle:@"X-Axis"];
    [axis.style setLabelStyle:textFormatting];
    [surface.xAxes add:axis];
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis alloc] init];
    [yAxis setAxisTitle:@"Y-Axis"];
    yAxis.axisAlignment = SCIAxisAlignment_Top;
    [yAxis.style setLabelStyle: textFormatting];
    [surface.yAxes add:yAxis];
    
    [surface invalidateElement];
}

@end

