//
//  NestedPieChartsView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 11/17/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "MultiPieDonutChartView.h"

@implementation MultiPieDonutChartView

- (void)initExample {
    // Initializing and hiding the pie and donut Renderable series - needed for animation
    // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
    
    SCIPieRenderableSeries * pieChart = [SCIPieRenderableSeries new];
    pieChart.isVisible = NO;
    [pieChart.segments add:[self buildSegmentWithValue:34 Title:@"Ecologic" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff84BC3D finish:0xff5B8829]]];
    [pieChart.segments add:[self buildSegmentWithValue:34.4 Title:@"Municipal" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [pieChart.segments add:[self buildSegmentWithValue:31.6 Title:@"Personal" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    
    SCIDonutRenderableSeries * donutChart = [SCIDonutRenderableSeries new];
    donutChart.isVisible = NO;
    [donutChart.segments add:[self buildSegmentWithValue:28.8 Title:@"Walking" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff84BC3D finish:0xff5B8829]]];
    [donutChart.segments add:[self buildSegmentWithValue:5.2 Title:@"Bycicle" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff84BC3D finish:0xff5B8829]]];
    
    [donutChart.segments add:[self buildSegmentWithValue:12.3 Title:@"Metro" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [donutChart.segments add:[self buildSegmentWithValue:3.5 Title:@"Tram" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [donutChart.segments add:[self buildSegmentWithValue:5.9 Title:@"Rail" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [donutChart.segments add:[self buildSegmentWithValue:9.7 Title:@"Bus" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [donutChart.segments add:[self buildSegmentWithValue:3 Title:@"Taxi" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    
    [donutChart.segments add:[self buildSegmentWithValue:23.2 Title:@"Car" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    [donutChart.segments add:[self buildSegmentWithValue:3.1 Title:@"Motor" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    [donutChart.segments add:[self buildSegmentWithValue:5.3 Title:@"Other" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    
    dispatch_after(0, dispatch_get_main_queue(), ^(void) {
        [pieChart animate:0.7];
        pieChart.isVisible = YES;
        [donutChart animate:0.7];
        donutChart.isVisible = YES;
    });
    
    SCIPieLegendModifier * legendModifier = [[SCIPieLegendModifier alloc] initWithPosition:SCILegendPositionBottom andOrientation:SCIOrientationVertical];
    legendModifier.pieSeries = pieChart;
    
    [self.pieChartSurface.renderableSeries add:pieChart];
    [self.pieChartSurface.renderableSeries add:donutChart];
    [self.pieChartSurface.chartModifiers add:legendModifier];
    [self.pieChartSurface.chartModifiers add:[SCIPieTooltipModifier new]];
}

- (SCIPieSegment *)buildSegmentWithValue:(double)segmentValue Title:(NSString *)title RadialGradient:(SCIRadialGradientBrushStyle *)gradientBrush {
    SCIPieSegment * segment = [SCIPieSegment new];
    segment.fillStyle = gradientBrush;
    segment.value = segmentValue;
    segment.title = title;
    
    return segment;
}
@end
