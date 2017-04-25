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

@synthesize sciChartSurfaceView;
@synthesize surface;

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        SCIChartSurfaceView * view = [[SCIChartSurfaceView alloc]initWithFrame:frame];
        sciChartSurfaceView = view;
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        __weak typeof(self) wSelf = self;
        
        AddRemoveSeriesPanel * panel = (AddRemoveSeriesPanel*)[[[NSBundle mainBundle] loadNibNamed:@"AddRemoveSeriesPanel" owner:self options:nil] firstObject];
        
//        panel.onClearClicked = ^() { [wSelf clear]; };
//        panel.onAddClicked() = ^() { [wSelf createSeries100K]; };
//        panel.onRemoveClicked() = ^() { [wSelf createSeries1KK]; };
        
        [self addSubview:panel];
        [self addSubview:sciChartSurfaceView];
        
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        NSDictionary *layout = @{@"SciChart":sciChartSurfaceView, @"Panel":panel};
        
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

-(void) initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView: sciChartSurfaceView];
    
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
    
    SCIModifierGroup * gm = [[SCIModifierGroup alloc] initWithChildModifiers:@[pzm, zem, zpm]];
    surface.chartModifier = gm;
}


@end
