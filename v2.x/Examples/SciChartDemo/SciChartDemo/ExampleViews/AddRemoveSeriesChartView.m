//
//  AddRemoveSeriesChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 25/04/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "AddRemoveSeriesChartView.h"
#import "AddRemoveSeriesPanel.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation AddRemoveSeriesChartView


@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurface * view = [[SCIChartSurface alloc]initWithFrame:frame];
        surface = view;
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        __weak typeof(self) wSelf = self;
        
        AddRemoveSeriesPanel * panel = (AddRemoveSeriesPanel*)[[[NSBundle mainBundle] loadNibNamed:@"AddRemoveSeriesPanel" owner:self options:nil] firstObject];
        
        panel.onClearClicked = ^() { [wSelf clear]; };
        panel.onAddClicked = ^() { [wSelf add]; };
        panel.onRemoveClicked = ^() { [wSelf remove]; };
        
        [self addSubview:panel];
        [self addSubview:surface];
        
        [surface setTranslatesAutoresizingMaskIntoConstraints:NO];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *layout = @{@"SciChart":surface, @"Panel":panel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(43)]-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|"
                                                                     options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) add{
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [DataManager getRandomDoubleSeries:dataSeries cound:150];
    
    SCIFastMountainRenderableSeries *mountainRenderSeries = [[SCIFastMountainRenderableSeries alloc]init];
    [mountainRenderSeries setDataSeries:dataSeries];
    [mountainRenderSeries.style setAreaStyle: [[SCISolidBrushStyle alloc]initWithColor: [[UIColor alloc]initWithRed:randi(0, 255) green:randi(0, 255) blue:randi(0, 255) alpha:1.0] ]];
    [mountainRenderSeries.style setStrokeStyle:[[SCISolidPenStyle alloc]initWithColor: [[UIColor alloc]initWithRed:randi(0, 255) green:randi(0, 255) blue:randi(0, 255) alpha:1.0] withThickness:1.0 ]];
    
    [surface.renderableSeries add:mountainRenderSeries];
}

-(void) remove{
    if ([surface.renderableSeries count]>0) {
        [surface.renderableSeries removeAt:0];
    }
}

-(void) clear{
    [surface.renderableSeries clear];
}

-(void) initializeSurfaceData {
    
    
    [self addAxes];
    [self addModifiers];
}

-(void) addAxes{
    id<SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    [xAxis setAutoRange:SCIAutoRange_Always];
    [xAxis setVisibleRange: [[SCIDoubleRange alloc]initWithMin:SCIGeneric(0.0) Max:SCIGeneric(150.0)]];
    [xAxis setAxisTitle:@"X Axis"];
    [surface.xAxes add:xAxis];
    
    id<SCIAxis2DProtocol> yAxis = [[SCINumericAxis alloc] init];
    [yAxis setAutoRange:SCIAutoRange_Always];
    [yAxis setAxisTitle:@"Y Axis"];
    [surface.yAxes add:yAxis];
}

-(void) addModifiers{
    SCIPinchZoomModifier * pzm = [[SCIPinchZoomModifier alloc] init];
    SCIZoomExtentsModifier * zem = [[SCIZoomExtentsModifier alloc] init];
    SCIZoomPanModifier * zpm = [[SCIZoomPanModifier alloc] init];
    
    SCIChartModifierCollection * gm = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[pzm, zem, zpm]];
    surface.chartModifiers = gm; 
}


@end
