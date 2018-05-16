//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DonutChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "DonutChartView.h"

@implementation DonutChartView

- (void)initExample {
    SCIDonutRenderableSeries * donutChart = [SCIDonutRenderableSeries new];
    
    // hiding the donut Renderable series - needed for animation
    // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
    donutChart.isVisible = NO;
    
    [donutChart.segments add:[self buildSegmentWithValue:40.0 Title:@"Green" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff84BC3D finish:0xff5B8829]]];
    [donutChart.segments add:[self buildSegmentWithValue:10.0 Title:@"Red" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [donutChart.segments add:[self buildSegmentWithValue:20.0 Title:@"Blue" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    [donutChart.segments add:[self buildSegmentWithValue:15.0 Title:@"Yellow" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffFFFF00 finish:0xfffed325]]];
    
    // adding animations for the donut renderable series
    dispatch_after(0, dispatch_get_main_queue(), ^(void){
        [donutChart animate:0.7];
        donutChart.isVisible = YES;
    });
    
    SCIPieLegendModifier * legendModifier = [[SCIPieLegendModifier alloc] initWithPosition:SCILegendPositionBottom andOrientation:SCIOrientationVertical];
    legendModifier.pieSeries = donutChart;

    // setting the DonutChart's hole radius
    [self.pieChartSurface setHoleRadius:100];
    
    [self.pieChartSurface.renderableSeries add:donutChart];
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
