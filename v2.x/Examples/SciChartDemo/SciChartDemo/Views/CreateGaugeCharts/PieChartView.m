//
//  PieChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 11/9/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "PieChartView.h"

@implementation PieChartView

- (void)initExample {
    SCIPieRenderableSeries * pieChart = [SCIPieRenderableSeries new];
    
    // hiding the pie Renderable series - needed for animation
    // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
    pieChart.isVisible = NO;
    
    [pieChart.segments add:[self buildSegmentWithValue:40.0 Title:@"Green" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff84BC3D finish:0xff5B8829]]];
    [pieChart.segments add:[self buildSegmentWithValue:10.0 Title:@"Red" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [pieChart.segments add:[self buildSegmentWithValue:20.0 Title:@"Blue" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    [pieChart.segments add:[self buildSegmentWithValue:15.0 Title:@"Yellow" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffFFFF00 finish:0xfffed325]]];
    
    dispatch_after(0, dispatch_get_main_queue(), ^(void){
        [pieChart startAnimation];
        pieChart.isVisible = YES;
    });
    
    SCIPieLegendModifier * legendModifier = [[SCIPieLegendModifier alloc] initWithPosition:SCILegendPositionBottom andOrientation:SCIOrientationVertical];
    legendModifier.pieSeries = pieChart;
    
    [self.pieChartSurface.renderableSeries add:pieChart];
    [self.pieChartSurface.chartModifiers add:legendModifier];
    [self.pieChartSurface.chartModifiers add:[SCIPieSelectionModifier new]];
}

- (SCIPieSegment *)buildSegmentWithValue:(double)segmentValue Title:(NSString *)title RadialGradient:(SCIRadialGradientBrushStyle *)gradientBrush {
    SCIPieSegment * segment = [SCIPieSegment new];
    segment.fillStyle = gradientBrush;
    segment.value = segmentValue;
    segment.title = title;
    
    return segment;
}

@end
