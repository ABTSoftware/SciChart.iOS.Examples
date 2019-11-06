//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MultiPieDonutChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "MultiPieDonutChartView.h"

@implementation MultiPieDonutChartView

- (void)initExample {
    SCIPieRenderableSeries *pieSeries = [SCIPieRenderableSeries new];
    [pieSeries.segments add:[self buildSegmentWithValue:34 Title:@"Ecologic" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xff84BC3D edgeColorCode:0xff5B8829]]];
    [pieSeries.segments add:[self buildSegmentWithValue:34.4 Title:@"Municipal" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xffe04a2f edgeColorCode:0xffB7161B]]];
    [pieSeries.segments add:[self buildSegmentWithValue:31.6 Title:@"Personal" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xff4AB6C1 edgeColorCode:0xff2182AD]]];
    
    SCIDonutRenderableSeries *donutChart = [SCIDonutRenderableSeries new];
    [donutChart.segments add:[self buildSegmentWithValue:28.8 Title:@"Walking" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xff84BC3D edgeColorCode:0xff5B8829]]];
    [donutChart.segments add:[self buildSegmentWithValue:5.2 Title:@"Bycicle" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xff84BC3D edgeColorCode:0xff5B8829]]];
    
    [donutChart.segments add:[self buildSegmentWithValue:12.3 Title:@"Metro" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xffe04a2f edgeColorCode:0xffB7161B]]];
    [donutChart.segments add:[self buildSegmentWithValue:3.5 Title:@"Tram" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xffe04a2f edgeColorCode:0xffB7161B]]];
    [donutChart.segments add:[self buildSegmentWithValue:5.9 Title:@"Rail" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xffe04a2f edgeColorCode:0xffB7161B]]];
    [donutChart.segments add:[self buildSegmentWithValue:9.7 Title:@"Bus" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xffe04a2f edgeColorCode:0xffB7161B]]];
    [donutChart.segments add:[self buildSegmentWithValue:3 Title:@"Taxi" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xffe04a2f edgeColorCode:0xffB7161B]]];
    
    [donutChart.segments add:[self buildSegmentWithValue:23.2 Title:@"Car" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xff4AB6C1 edgeColorCode:0xff2182AD]]];
    [donutChart.segments add:[self buildSegmentWithValue:3.1 Title:@"Motor" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xff4AB6C1 edgeColorCode:0xff2182AD]]];
    [donutChart.segments add:[self buildSegmentWithValue:5.3 Title:@"Other" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:0xff4AB6C1 edgeColorCode:0xff2182AD]]];
    
    // Initializing and hiding the pie and donut Renderable series - needed for animation
    // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
    pieSeries.isVisible = NO;
    donutChart.isVisible = NO;
    
    SCIPieLegendModifier *legendModifier = [SCIPieLegendModifier new];
    legendModifier.sourceSeries = pieSeries;
    legendModifier.margins = UIEdgeInsetsMake(17, 17, 17, 17);
    legendModifier.position = SCIAlignment_Bottom | SCIAlignment_CenterHorizontal;
    
    [self.pieChartSurface.renderableSeries add:pieSeries];
    [self.pieChartSurface.renderableSeries add:donutChart];
    [self.pieChartSurface.chartModifiers add:legendModifier];
    [self.pieChartSurface.chartModifiers add:[SCIPieTooltipModifier new]];
    
    dispatch_after(0, dispatch_get_main_queue(), ^(void) {
        [pieSeries animate:0.7];
        pieSeries.isVisible = YES;
        [donutChart animate:0.7];
        donutChart.isVisible = YES;
    });
}

- (SCIPieSegment *)buildSegmentWithValue:(double)segmentValue Title:(NSString *)title RadialGradient:(SCIRadialGradientBrushStyle *)gradientBrush {
    SCIPieSegment *segment = [SCIPieSegment new];
    segment.fillStyle = gradientBrush;
    segment.value = segmentValue;
    segment.title = title;
    
    return segment;
}

@end
