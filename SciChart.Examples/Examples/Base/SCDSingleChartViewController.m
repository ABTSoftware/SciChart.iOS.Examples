//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SingleChartLayout.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSingleChartViewController.h"
#import <SciChart/NSObject+ExceptionUtil.h>

@implementation SCDSingleChartViewController

- (Class)associatedType {
    @throw [self notImplementedExceptionFor:_cmd];
}

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    SCIView<ISCIChartSurfaceBase> *surface = [[self.associatedType alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    surface.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:surface];
    _surface = surface;
    
    [self p_SCD_placePanel];
}

- (void)p_SCD_placePanel {
    
    [_surface.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_surface.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [_surface.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [_surface.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
}

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    [SCIThemeManager applyTheme:theme toThemeable:self.surface];
    self.view.platformBackgroundColor = self.surface.backgroundBrushStyle.color;
}

@end
