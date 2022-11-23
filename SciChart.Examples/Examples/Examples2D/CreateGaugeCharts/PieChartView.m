//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PieChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "PieChartView.h"

@implementation PieChartView

- (Class)associatedType { return SCIPieChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; };

- (void)initExample {
    SCIPieRenderableSeries *pieSeries = [SCIPieRenderableSeries new];
    [pieSeries.segmentsCollection add:[self segmentWithValue:40 title:@"Green" centerColor:0xFF34c19c edgeColor:0xFF34c19c]];
    [pieSeries.segmentsCollection add:[self segmentWithValue:10 title:@"Red" centerColor:0xFFc43360 edgeColor:0xFFc43360]];
    [pieSeries.segmentsCollection add:[self segmentWithValue:20 title:@"Blue" centerColor:0xFF373dbc edgeColor:0xFF373dbc]];
    [pieSeries.segmentsCollection add:[self segmentWithValue:15 title:@"Yellow" centerColor:0xffe8c667 edgeColor:0xffe8c667]];
    
    SCIPieChartLegendModifier *legendModifier = [SCIPieChartLegendModifier new];
    legendModifier.sourceSeries = pieSeries;
    legendModifier.margins = (SCIEdgeInsets){.left = 17, .top = 17, .right = 17, .bottom = 17};
    legendModifier.position = SCIAlignment_Bottom | SCIAlignment_CenterHorizontal;
    
    SCIPieSegmentSelectionModifier *selectionModifier = [SCIPieSegmentSelectionModifier new];
    
    [self.surface.renderableSeries add:pieSeries];
    [self.surface.chartModifiers add:legendModifier];
    
    [self.surface.chartModifiers add:selectionModifier];
    
    // setting scale to 0 - needed for animation
    // by default scale == 1, so that when the animation starts - the pie chart might be already drawn
    pieSeries.scale = 0;
    [pieSeries animateWithDuration:0.7];
}

- (SCIPieSegment *)segmentWithValue:(double)segmentValue title:(NSString *)title centerColor:(unsigned int)centerColor edgeColor:(unsigned int)edgeColor {
    SCIPieSegment *segment = [SCIPieSegment new];
    segment.value = segmentValue;
    segment.title = title;
    segment.fillStyle = [[SCIRadialGradientBrushStyle alloc] initWithCenterColorCode:centerColor edgeColorCode:edgeColor];
        
    return segment;
}

@end
