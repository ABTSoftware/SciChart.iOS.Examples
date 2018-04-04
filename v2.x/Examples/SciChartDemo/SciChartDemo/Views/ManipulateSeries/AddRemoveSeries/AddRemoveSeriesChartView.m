//
//  AddRemoveSeriesChartView.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 25/04/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "AddRemoveSeriesChartView.h"
#import "DataManager.h"
#import "RandomUtil.h"

@implementation AddRemoveSeriesChartView

- (void)initExample {
    __weak typeof(self) wSelf = self;
    self.addSeries = ^{ [wSelf add]; };
    self.removeSeries = ^{ [wSelf remove]; };
    self.clearSeries = ^{ [wSelf clear]; };
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.0) Max:SCIGeneric(150.0)];
    xAxis.axisTitle = @"X Axis";
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.axisTitle = @"Y Axis";
    
    [self.surface.xAxes add:xAxis];
    [self.surface.yAxes add:yAxis];
    
    self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new]]];
}

- (void)add {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        DoubleSeries * randomDoubleSeries = [DataManager getRandomDoubleSeriesWithCound:150];
        SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
        [dataSeries appendRangeX:randomDoubleSeries.xValues Y:randomDoubleSeries.yValues Count:randomDoubleSeries.size];
    
        SCIFastMountainRenderableSeries * mountainRenderSeries = [[SCIFastMountainRenderableSeries alloc]init];
        mountainRenderSeries.dataSeries = dataSeries;
        mountainRenderSeries.areaStyle = [[SCISolidBrushStyle alloc] initWithColor:[[UIColor alloc] initWithRed:randi(0, 255) green:randi(0, 255) blue:randi(0, 255) alpha:1.0]];
        mountainRenderSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[[UIColor alloc] initWithRed:randi(0, 255) green:randi(0, 255) blue:randi(0, 255) alpha:1.0] withThickness:1.0];
        
        [self.surface.renderableSeries add:mountainRenderSeries];
    }];
}

- (void)remove {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        if (self.surface.renderableSeries.count > 0) {
            [self.surface.renderableSeries removeAt:0];
        }
    }];
}

- (void)clear {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.renderableSeries clear];
    }];
}

@end
