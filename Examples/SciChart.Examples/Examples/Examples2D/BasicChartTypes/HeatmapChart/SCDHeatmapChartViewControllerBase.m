//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSingleChartWithHeatmapViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDHeatmapChartViewControllerBase.h"

@implementation SCDHeatmapChartViewControllerBase

- (Class)associatedType { return SCIChartSurface.class; }

- (void)viewDidLoad {
    SCIChartHeatmapColourMap *colourMap = [SCIChartHeatmapColourMap new];
    colourMap.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.surface.renderableSeriesArea.view addSubview:colourMap];
    [self.surface.renderableSeriesArea.view addConstraints:@[
        [colourMap.leadingAnchor constraintEqualToAnchor:self.surface.renderableSeriesArea.view.leadingAnchor constant:8],
        [colourMap.bottomAnchor constraintEqualToAnchor:self.surface.renderableSeriesArea.view.bottomAnchor constant:-8],
        [colourMap.topAnchor constraintEqualToAnchor:self.surface.renderableSeriesArea.view.topAnchor constant:8]
    ]];
    
    [colourMap addConstraint:[colourMap.widthAnchor constraintEqualToConstant:100]];
    
    _heatmapColourMap = colourMap;
    
    [super viewDidLoad];
}

@end
