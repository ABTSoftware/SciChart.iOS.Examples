//
//  PieChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 11/9/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "PieChartView.h"

@implementation PieChartView

//@synthesize pieChartSurface = _pieChartSurface;

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
        
        _pieChartSurface.layoutManager.segmentSpacing = 1;
    }
    
    return self;
}

-(void) initializeSurfaceData{
    SCIPieRenderableSeries * pieChart = [SCIPieRenderableSeries new];
    
    [pieChart.segments add: [self buildSegmentWithValue:40.0 Title:@"Green" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff84BC3D finish:0xff5B8829]]];
    [pieChart.segments add: [self buildSegmentWithValue:10.0 Title:@"Red" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [pieChart.segments add: [self buildSegmentWithValue:20.0 Title:@"Blue" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    [pieChart.segments add: [self buildSegmentWithValue:15.0 Title:@"Yellow" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffFFFF00 finish:0xfffed325]]];
    
    [_pieChartSurface.renderableSeries add:pieChart];
    
    SCIPieLegendModifier * legendModifier = [[SCIPieLegendModifier alloc] initWithPosition:SCILegendPositionBottom andOrientation:SCIOrientationVertical];
    legendModifier.pieSeries = pieChart;
    
    [_pieChartSurface.chartModifiers add:legendModifier];
}

-(SCIPieSegment*) buildSegmentWithValue: (double)segmentValue Title:(NSString*)title RadialGradient:(SCIRadialGradientBrushStyle*)gradientBrush{
    SCIPieSegment * segment = [SCIPieSegment new];
    segment.fillStyle = gradientBrush;
    segment.value = segmentValue;
    segment.title = title;
    
    return segment;
}
@end
