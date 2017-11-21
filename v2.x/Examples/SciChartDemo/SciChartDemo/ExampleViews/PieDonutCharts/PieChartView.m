//
//  PieChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 11/9/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "PieChartView.h"

@implementation PieChartView{
    SCIPieRenderableSeries * pieChart;
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
        
        UISwitch *drawLabelsSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(_pieChartSurface.frame.size.width - 180, 20, 0, 0)];
        [drawLabelsSwitch addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
        
        UILabel *drawLabelsLabel = [[UILabel alloc] initWithFrame:CGRectMake(_pieChartSurface.frame.size.width - 120, 20, 110, 30)];
        [drawLabelsLabel setText:@"Draw Labels"];
        [drawLabelsLabel setTextColor: [UIColor whiteColor]];
        
        [_pieChartSurface addSubview:drawLabelsSwitch];
        [_pieChartSurface addSubview:drawLabelsLabel];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

-(void) initializeSurfaceData{
    pieChart = [SCIPieRenderableSeries new];
    
    // hiding the pie Renderable series - needed for animation
    // by default the pie renderable series are visible, so that when the animation starts - the pie chart might be already drawn
    pieChart.isVisible = NO;
    
    [pieChart.segments add: [self buildSegmentWithValue:40.0 Title:@"Green" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff84BC3D finish:0xff5B8829]]];
    [pieChart.segments add: [self buildSegmentWithValue:10.0 Title:@"Red" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffe04a2f finish:0xffB7161B]]];
    [pieChart.segments add: [self buildSegmentWithValue:20.0 Title:@"Blue" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xff4AB6C1 finish:0xff2182AD]]];
    [pieChart.segments add: [self buildSegmentWithValue:15.0 Title:@"Yellow" RadialGradient:[[SCIRadialGradientBrushStyle alloc] initWithColorCodeStart:0xffFFFF00 finish:0xfffed325]]];
    
    // adding animations for the pie renderable series
    dispatch_after(0, dispatch_get_main_queue(), ^(void){
        [pieChart startAnimation];
        pieChart.isVisible = YES;
    });
    
    [_pieChartSurface.renderableSeries add:pieChart];
    
    // Adding some basic modifiers - Legend and Selection
    SCIPieLegendModifier * legendModifier = [[SCIPieLegendModifier alloc] initWithPosition:SCILegendPositionBottom andOrientation:SCIOrientationVertical];
    legendModifier.pieSeries = pieChart;
    
    [_pieChartSurface.chartModifiers add:legendModifier];
    [_pieChartSurface.chartModifiers add:[SCIPieSelectionModifier new]];
    
    _pieChartSurface.backgroundColor = UIColor.darkGrayColor;
}

/*
 Function for building the Segments for Pie Renderable series
 */
-(SCIPieSegment*) buildSegmentWithValue: (double)segmentValue Title:(NSString*)title RadialGradient:(SCIRadialGradientBrushStyle*)gradientBrush{
    SCIPieSegment * segment = [SCIPieSegment new];
    segment.fillStyle = gradientBrush;
    segment.value = segmentValue;
    segment.title = title;
    
    return segment;
}

/*
 UISwitch valueChanged handler
 */
- (void)changeSwitch:(id)sender{
    if([sender isOn]){
        pieChart.drawLabels = YES;
        [_pieChartSurface invalidateElement];
    } else{
        pieChart.drawLabels = NO;
        [_pieChartSurface invalidateElement];
    }
}
@end
