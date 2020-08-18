//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AddPointsPerformanceChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AddPointsPerformanceChartView.h"
#import "SCDButtonsTopPanel.h"
#import "SCDToolbarButton.h"
#import "SCDPanelButton.h"
#import "SCDRandomUtil.h"
#import "SCDRandomWalkGenerator.h"
#import "SCDToolbarButtonsGroup.h"

@implementation AddPointsPerformanceChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (NSArray<id<ISCDToolbarItemModel>> *)panelItems {
    __weak typeof(self) wSelf = self;
    return @[
        [[SCDToolbarButton alloc] initWithTitle:@"+10K" image:nil andAction:^{ [wSelf appendPoints:10000]; }],
        [[SCDToolbarButton alloc] initWithTitle:@"+100K" image:nil andAction:^{ [wSelf appendPoints:100000]; }],
        [[SCDToolbarButton alloc] initWithTitle:@"+1MLN" image:nil andAction:^{ [wSelf appendPoints:1000000]; }],
        [[SCDToolbarButton alloc] initWithTitle:@"Clear" image:nil andAction:^{ [wSelf.surface.renderableSeries clear]; }],
    ];
}

#if TARGET_OS_OSX
- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    return @[[[SCDToolbarButtonsGroup alloc] initWithToolbarItems:self.panelItems]];
}
#elif TARGET_OS_IOS
- (SCIView *)providePanel {
    return [[SCDButtonsTopPanel alloc] initWithToolbarItems:self.panelItems];
}
#endif

- (void)initExample {
    [self.surface.xAxes add:[SCINumericAxis new]];
    [self.surface.yAxes add:[SCINumericAxis new]];
    [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
}

- (void)appendPoints:(int)count {
    SCDDoubleSeries *doubleSeries = [[[SCDRandomWalkGenerator new] setBias:randf(0.0, 1.0) / 100] getRandomWalkSeries:count];
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    [dataSeries appendValuesX:doubleSeries.xValues y:doubleSeries.yValues];
    
    SCIFastLineRenderableSeries *rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:[SCIColor colorWithRed:randf(0, 1) green:randf(0, 1) blue:randf(0, 1) alpha:1.0].colorARGBCode thickness:1];
    
    [self.surface.renderableSeries add:rSeries];
    [self.surface animateZoomExtentsWithDuration:0.5];
}

@end
