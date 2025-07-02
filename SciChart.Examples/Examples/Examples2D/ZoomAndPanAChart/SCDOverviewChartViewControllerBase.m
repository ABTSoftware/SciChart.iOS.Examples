//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDRealtimeTickingStockChartViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDOverviewChartViewControllerBase.h"
#import <SciChart/NSObject+ExceptionUtil.h>
#import "SCDToolbarPopupItem.h"
#import "SCDToolbarButton.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCIStackView.h"

@interface SCDOverviewChartViewControllerBase()
@property (nonatomic) NSArray<Class> *seriesTypes;
@end

@implementation SCDOverviewChartViewControllerBase

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    [SCIThemeManager applyTheme:theme toThemeable:self.mainSurface];
    self.view.platformBackgroundColor = self.mainSurface.backgroundBrushStyle.color;
}

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    SCIStackView *stackView = [SCIStackView new];
    stackView.axis = SCILayoutConstraintAxisVertical;
    stackView.spacing = 0;

    SCIChartSurface *mainSurface = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [stackView addArrangedSubview:mainSurface];
    
    _mainSurface = mainSurface;
    
    _overviewChart = [[SCIChartOverview alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [stackView addArrangedSubview:_overviewChart];
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    
    [self.view addConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [_overviewChart.heightAnchor constraintEqualToConstant:100]
    ]];
}

- (SCIView *)createCustomGripView {
    SCIView *vw = [[SCIView alloc] initWithFrame:CGRectMake(0, 0, 20.0, 100.0)];
    
    SCIView *rectVw = [[SCIView alloc] initWithFrame:CGRectMake(0, 0, 10.0, CGRectGetHeight(vw.frame))];
    rectVw.center = vw.center;
    [vw addSubview:rectVw];
    
    SCIView *roundVw = [[SCIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(vw.frame) / 2 - 10, 20, 20)];
    [vw addSubview:roundVw];
    
#if defined(__MAC_OS_X_VERSION_MAX_ALLOWED)
    // macOS specific code
    vw.wantsLayer = YES;
    vw.layer.backgroundColor = [SCIColor clearColor].CGColor;

    rectVw.wantsLayer = YES;
    rectVw.layer.backgroundColor = [SCIColor colorWithRed:103/256.0 green:156/256.0 blue:220/256.0 alpha:1].CGColor;

    roundVw.wantsLayer = YES;
    roundVw.layer.backgroundColor = [SCIColor colorWithRed:164/256.0 green:235/256.0 blue:198/256.0 alpha:1].CGColor;
    roundVw.layer.cornerRadius = CGRectGetHeight(roundVw.frame) / 2;

#else
    // iOS specific code
    vw.backgroundColor = [SCIColor clearColor];
    
    rectVw.backgroundColor = [SCIColor colorWithRed:103/256.0 green:156/256.0 blue:220/256.0 alpha:1];
    
    roundVw.backgroundColor = [SCIColor colorWithRed:164/256.0 green:235/256.0 blue:198/256.0 alpha:1];
    roundVw.layer.cornerRadius = CGRectGetHeight(roundVw.frame) / 2;
#endif
    
    return vw;
}

@end
