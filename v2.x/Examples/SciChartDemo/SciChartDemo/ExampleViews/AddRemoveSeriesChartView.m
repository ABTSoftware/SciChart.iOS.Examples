//
//  AddRemoveSeriesChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 25/04/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "AddRemoveSeriesChartView.h"
#import "AddRemoveSeriesPanel.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import "RandomUtil.h"

@implementation AddRemoveSeriesChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        
        __weak typeof(self) wSelf = self;
        
        AddRemoveSeriesPanel * panel = (AddRemoveSeriesPanel *)[[NSBundle mainBundle] loadNibNamed:@"AddRemoveSeriesPanel" owner:self options:nil].firstObject;
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        panel.onClearClicked = ^() { [wSelf clear]; };
        panel.onAddClicked = ^() { [wSelf add]; };
        panel.onRemoveClicked = ^() { [wSelf remove]; };
        
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
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.0) Max:SCIGeneric(150.0)];
    xAxis.axisTitle = @"X Axis";
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.axisTitle = @"Y Axis";
    
    [surface.xAxes add:xAxis];
    [surface.yAxes add:yAxis];
    
    surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
}

- (void)add {
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        DoubleSeries * randomDoubleSeries = [DataManager getRandomDoubleSeriesWithCound:150];
        SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
        [dataSeries appendRangeX:randomDoubleSeries.xValues Y:randomDoubleSeries.yValues Count:randomDoubleSeries.size];
    
        SCIFastMountainRenderableSeries * mountainRenderSeries = [[SCIFastMountainRenderableSeries alloc]init];
        mountainRenderSeries.dataSeries = dataSeries;
        mountainRenderSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColor:[[UIColor alloc] initWithRed:randi(0, 255) green:randi(0, 255) blue:randi(0, 255) alpha:1.0]];
        mountainRenderSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[[UIColor alloc] initWithRed:randi(0, 255) green:randi(0, 255) blue:randi(0, 255) alpha:1.0] withThickness:1.0];
        
        [surface.renderableSeries add:mountainRenderSeries];
    }];
}

- (void)remove {
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        if (surface.renderableSeries.count > 0) {
            [surface.renderableSeries removeAt:0];
        }
    }];
}

- (void)clear {
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.renderableSeries clear];
    }];
}

@end
