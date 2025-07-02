//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeTickingStockChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "OverviewChartView.h"
#import "SCDDataManager.h"
#import "SCDPriceSeries.h"
#import "SCDMovingAverage.h"
#import "SCDMarketDataService.h"

@implementation OverviewChartView

- (void)initExample {
    // Create X and Y axes
    SCINumericAxis *xAxis = [[SCINumericAxis alloc] init];
    SCINumericAxis *yAxis = [[SCINumericAxis alloc] init];
    
    int count = 1500;
    
    // Create random walk data series
    SCDRandomWalkGenerator *randomWalkGenerator = [SCDRandomWalkGenerator new];
    SCDDoubleSeries *data1 = [randomWalkGenerator getRandomWalkSeries:count];
    [randomWalkGenerator reset];
    
    SCDDoubleSeries *data2 = [randomWalkGenerator getRandomWalkSeries:count];
    [randomWalkGenerator reset];
    
    SCDDoubleSeries *data3 = [randomWalkGenerator getRandomWalkSeries:count];
    [randomWalkGenerator reset];
    
    // Create data series
    SCIXyDataSeries *ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds1.seriesName = @"Line Series";
    [ds1 appendValuesX:data1.xValues y:data1.yValues];
    
    SCIXyDataSeries *ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds2.seriesName = @"Mountain Series";
    [ds2 appendValuesX:data2.xValues y:data2.yValues];
    
    SCIXyDataSeries *ds3 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    ds3.seriesName = @"Column Series";
    [ds3 appendValuesX:data3.xValues y:data3.yValues];
    
    // Create renderable series
    SCIFastLineRenderableSeries *rSeries1 = [[SCIFastLineRenderableSeries alloc] init];
    rSeries1.dataSeries = ds1;
    rSeries1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF70FF thickness:2];
    
    SCIFastMountainRenderableSeries *rSeries2 = [[SCIFastMountainRenderableSeries alloc] init];
    rSeries2.dataSeries = ds2;
    rSeries2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFe9Fe64 thickness:2];
    
    SCIFastColumnRenderableSeries *rSeries3 = [[SCIFastColumnRenderableSeries alloc] init];
    rSeries3.dataSeries = ds3;
    rSeries3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFe97064 thickness:2];
    
    // Create legend modifier
    SCILegendModifier *legendModifier = [SCILegendModifier new];
    legendModifier.margins = (SCIEdgeInsets){.left = 10, .top = 60, .right = 16, .bottom = 16};
    
    // Using SCIUpdateSuspender to update the main surface
    [SCIUpdateSuspender usingWithSuspendable:self.mainSurface withBlock:^{
        [self.mainSurface.xAxes add:xAxis];
        [self.mainSurface.yAxes add:yAxis];
        [self.mainSurface.renderableSeries add:rSeries3];
        [self.mainSurface.renderableSeries add:rSeries2];
        [self.mainSurface.renderableSeries add:rSeries1];
        
        [SCIAnimations waveSeries:rSeries1 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations waveSeries:rSeries2 duration:3.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations waveSeries:rSeries3 duration:3.0 andEasingFunction:[SCICubicEase new]];
        
        [self.mainSurface.chartModifiers addAll: [SCIPinchZoomModifier new], [SCIZoomPanModifier new], [SCIZoomExtentsModifier new], legendModifier, nil];
        
        /// Create Overview
        SCIView *customView = [self createCustomGripView];
        SCIOverviewOptions *options = [SCIOverviewOptions new];
        
        NSMutableArray *filteredSeries = [NSMutableArray new];
        for (id<ISCIRenderableSeries> series in self.mainSurface.renderableSeries) {
            if (![series isKindOfClass:[SCIFastMountainRenderableSeries class]])
            {
                if ([series isKindOfClass:[SCIFastLineRenderableSeries class]])
                {
                    SCIFastMountainRenderableSeries *rSeries = [SCIFastMountainRenderableSeries new];
                    rSeries.dataSeries = series.dataSeries;
                    [filteredSeries addObject:rSeries];
                }
                else {
                    [filteredSeries addObject:series];
                }
            }
        }
        
        options.renderableSeries = filteredSeries;
        [self.overviewChart createOverviewChartForParentSurface:self.mainSurface gripView:customView options:options];
    }];
}

@end
