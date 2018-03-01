//
//  LinePerformanceView.m
//  SciChartDemo
//
//  Created by Admin on 28.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "AddPointsPerformanceView.h"
#import <SciChart/SciChart.h>
#import "AddPointsPerformanceControlPanelView.h"
#import "RandomUtil.h"
#import "RandomWalkGenerator.h"

@implementation AddPointsPerformanceView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) wSelf = self;
        
        AddPointsPerformanceControlPanelView * panel = (AddPointsPerformanceControlPanelView *)[NSBundle.mainBundle loadNibNamed:@"AddPointsPerformanceControlPanelView" owner:self options:nil].firstObject;
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        panel.onClearClicked = ^() { [wSelf clear]; };
        panel.onAdd100KClicked = ^() { [wSelf appendPoints:100000]; };
        panel.onAdd1KKClicked = ^() { [wSelf appendPoints:1000000]; };
        
        [self addSubview:panel];
        [self addSubview:surface];
        
        NSDictionary * layout = @{@"SciChart":surface, @"Panel":panel};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(43)]-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|" options:0 metrics:0 views:layout]];
        
        [self initializeSurfaceData];
    }
    
    return self;
}

- (void)initializeSurfaceData {
    [surface.xAxes add:[SCINumericAxis new]];
    [surface.yAxes add:[SCINumericAxis new]];
    surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
}

- (void)appendPoints:(int)count {
    DoubleSeries * doubleSeries = [[[RandomWalkGenerator new] setBias:randf(0.0, 1.0) / 100] getRandomWalkSeries:count];
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    [dataSeries appendRangeX:doubleSeries.xValues Y:doubleSeries.yValues Count:doubleSeries.size];
    
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:[UIColor colorWithRed:randf(0, 1) green:randf(0, 1) blue:randf(0, 1) alpha:1.0].colorARGBCode withThickness:1];
    
    [surface.renderableSeries add:rSeries];
    [surface animateZoomExtents:0.5];
}

- (void)clear {
    [surface.renderableSeries clear];
}

@end
