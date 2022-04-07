//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSyncMultipleChartsViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDTwoChartsViewController.h"

@implementation SCDTwoChartsViewController

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    SCIView<ISCIChartSurfaceBase> *surface1 = [[self.associatedType alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    surface1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:surface1];
    
    SCIView<ISCIChartSurfaceBase> *surface2 = [[self.associatedType alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    surface2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:surface2];
    
    [self.view addConstraints:@[
        [surface1.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [surface1.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [surface1.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        
        [surface1.bottomAnchor constraintEqualToAnchor:surface2.topAnchor],
        [surface1.heightAnchor constraintEqualToAnchor:surface2.heightAnchor],
        
        [surface2.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [surface2.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [surface2.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    _surface1 = surface1;
    _surface2 = surface2;
}

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    [SCIThemeManager applyTheme:theme toThemeable:self.surface1];
    [SCIThemeManager applyTheme:theme toThemeable:self.surface2];
}

@end
