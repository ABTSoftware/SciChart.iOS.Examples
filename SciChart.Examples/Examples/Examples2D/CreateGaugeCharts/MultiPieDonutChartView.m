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

- (Class)associatedType { return SCIPieChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; };

- (void)initExample {
    SCIPieRenderableSeries *pieSeries = [SCIPieRenderableSeries new];
    [pieSeries.segmentsCollection add:[self segmentWithValue:34 title:@"Ecologic" centerColor:0xFF34c19c edgeColor:0xFF34c19c]];
    [pieSeries.segmentsCollection add:[self segmentWithValue:34.4 title:@"Municipal" centerColor:0xFFc43360 edgeColor:0xFFc43360]];
    [pieSeries.segmentsCollection add:[self segmentWithValue:31.6 title:@"Personal" centerColor:0xFF373dbc edgeColor:0xFF373dbc]];
    
    SCIDonutRenderableSeries *donutChart = [SCIDonutRenderableSeries new];
    [donutChart.segmentsCollection add:[self segmentWithValue:28.8 title:@"Walking" centerColor:0xFF34c19c edgeColor:0xFF34c19c]];
    [donutChart.segmentsCollection add:[self segmentWithValue:5.2 title:@"Bycicle" centerColor:0xFF34c19c edgeColor:0xFF34c19c]];
    
    [donutChart.segmentsCollection add:[self segmentWithValue:12.3 title:@"Metro" centerColor:0xFFc43360 edgeColor:0xFFc43360]];
    [donutChart.segmentsCollection add:[self segmentWithValue:3.5 title:@"Tram" centerColor:0xFFc43360 edgeColor:0xFFc43360]];
    [donutChart.segmentsCollection add:[self segmentWithValue:5.9 title:@"Rail" centerColor:0xFFc43360 edgeColor:0xFFc43360]];
    [donutChart.segmentsCollection add:[self segmentWithValue:9.7 title:@"Bus" centerColor:0xFFc43360 edgeColor:0xFFc43360]];
    [donutChart.segmentsCollection add:[self segmentWithValue:3 title:@"Taxi" centerColor:0xFFc43360 edgeColor:0xFFc43360]];
    
    [donutChart.segmentsCollection add:[self segmentWithValue:23.2 title:@"Car" centerColor:0xFF373dbc edgeColor:0xFF373dbc]];
    [donutChart.segmentsCollection add:[self segmentWithValue:3.1 title:@"Motor" centerColor:0xFF373dbc edgeColor:0xFF373dbc]];
    [donutChart.segmentsCollection add:[self segmentWithValue:5.3 title:@"Other" centerColor:0xFF373dbc edgeColor:0xFF373dbc]];
    
    SCIPieChartLegendModifier *legendModifier = [SCIPieChartLegendModifier new];
    legendModifier.sourceSeries = pieSeries;
    legendModifier.margins = (SCIEdgeInsets){.left = 17, .top = 17, .right = 17, .bottom = 17};;
    legendModifier.position = SCIAlignment_Bottom | SCIAlignment_CenterHorizontal;
    legendModifier.showCheckBoxes = NO;
    
    [self.surface.renderableSeries add:pieSeries];
    [self.surface.renderableSeries add:donutChart];
    [self.surface.chartModifiers add:legendModifier];
    [self.surface.chartModifiers add:[SCIPieChartTooltipModifier new]];
    
    // setting scale to 0 - needed for animation
    // by default scale == 1, so that when the animation starts - the pie chart might be already drawn
    pieSeries.scale = 0;
    [pieSeries animateWithDuration:0.7];
    donutChart.scale = 0;
    [donutChart animateWithDuration:0.7];
}

- (SCIPieSegment *)segmentWithValue:(double)segmentValue title:(NSString *)title centerColor:(unsigned int)centerColor edgeColor:(unsigned int)edgeColor {
    SCIPieSegment *segment = [SCIPieSegment new];
    segment.value = segmentValue;
    segment.title = title;
    segment.fillStyle = [[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:centerColor edgeColorCode:edgeColor];
        
    return segment;
}

@end
