//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDDoubleChartPaneViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDDoubleChartPaneViewController.h"

@implementation SCDDoubleChartPaneViewController

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    SCIChartSurface *firstSurface = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    SCIChartSurface *secondSurface = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    for (SCIView *surface in @[firstSurface, secondSurface]) {
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:surface];
    }
    
    [self.view addConstraints:@[
        [firstSurface.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [firstSurface.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [firstSurface.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [firstSurface.bottomAnchor constraintEqualToAnchor:secondSurface.topAnchor],
        
        [secondSurface.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [secondSurface.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [secondSurface.heightAnchor constraintEqualToConstant:200],
        [secondSurface.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    _firstSurface = firstSurface;
    _secondSurface = secondSurface;
}

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    [SCIThemeManager applyTheme:theme toThemeable:self.firstSurface];
    [SCIThemeManager applyTheme:theme toThemeable:self.secondSurface];
}

@end
