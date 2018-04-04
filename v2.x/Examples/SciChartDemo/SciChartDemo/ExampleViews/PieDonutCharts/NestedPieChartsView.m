//
//  NestedPieChartsView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 11/17/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "NestedPieChartsView.h"

@implementation NestedPieChartsView{
    SCIPieRenderableSeries * pieChart;
    SCIDonutRenderableSeries * donutChart;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self) {
        _pieChartSurface = [[SCIPieChartSurface alloc]initWithFrame:frame];
        [_pieChartSurface setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self addSubview:_pieChartSurface];
        NSDictionary *layout = @{@"SciChart":_pieChartSurface};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData{
    
    // Initializing and hiding the pie and donut Renderable series - needed for animation
    // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
    
    pieChart = [SCIPieRenderableSeries new];
    pieChart.isVisible = NO;
    
    [pieChart setDrawLabels:YES];
    [pieChart.segments add: [self buildSegmentWithValue:34 Title:@"Ecologic" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff84BC3D finish:0xff5B8829]]];
    [pieChart.segments add: [self buildSegmentWithValue:34.4 Title:@"Municipal" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [pieChart.segments add: [self buildSegmentWithValue:31.6 Title:@"Personal" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    
    donutChart = [SCIDonutRenderableSeries new];
    donutChart.isVisible = NO;
    [donutChart setDrawLabels:YES];
    
    [donutChart.segments add: [self buildSegmentWithValue:28.8 Title:@"Walking" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff84BC3D finish:0xff5B8829]]];
    [donutChart.segments add: [self buildSegmentWithValue:5.2 Title:@"Bycicle" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff84BC3D finish:0xff5B8829]]];
    
    [donutChart.segments add: [self buildSegmentWithValue:12.3 Title:@"Metro" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [donutChart.segments add: [self buildSegmentWithValue:3.5 Title:@"Tram" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [donutChart.segments add: [self buildSegmentWithValue:5.9 Title:@"Rail" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [donutChart.segments add: [self buildSegmentWithValue:9.7 Title:@"Bus" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [donutChart.segments add: [self buildSegmentWithValue:3 Title:@"Taxi" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    
    [donutChart.segments add: [self buildSegmentWithValue:23.2 Title:@"Car" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    [donutChart.segments add: [self buildSegmentWithValue:3.1 Title:@"Motor" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    [donutChart.segments add: [self buildSegmentWithValue:5.3 Title:@"Other" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    
    // adding animations for the pie and donut renderable series
    dispatch_after(0, dispatch_get_main_queue(), ^(void) {
        [pieChart animate:0.7];
        pieChart.isVisible = YES;
        [donutChart animate:0.7];
        donutChart.isVisible = YES;
    });
    
    [_pieChartSurface.renderableSeries add:pieChart];
    [_pieChartSurface.renderableSeries add:donutChart];
    
    // Adding some basic modifiers - Legend and Selection
    SCIPieLegendModifier * legendModifier = [[SCIPieLegendModifier alloc] initWithPosition:SCILegendPositionBottom andOrientation:SCIOrientationVertical];
    legendModifier.pieSeries = pieChart;
    
    [_pieChartSurface.chartModifiers add:legendModifier];
    [_pieChartSurface.chartModifiers add:[SCIPieTooltipModifier new]];
    
    _pieChartSurface.backgroundColor = UIColor.darkGrayColor;
    _pieChartSurface.layoutManager.segmentSpacing = 3;
    _pieChartSurface.layoutManager.seriesSpacing = 3;
}

/*
 Function for building the Segments for Pie Renderable series
 */
-(SCIPieSegment*) buildSegmentWithValue: (double)segmentValue Title:(NSString*)title RadialGradient:(SCIRadialGradientBrushStyle*)gradientBrush{
    SCIPieSegment * segment = [SCIPieSegment new];
    segment.fillStyle = gradientBrush;
    segment.value = segmentValue;
    segment.title = title;
//    [segment setCenterOffset:2];
    return segment;
}
@end
