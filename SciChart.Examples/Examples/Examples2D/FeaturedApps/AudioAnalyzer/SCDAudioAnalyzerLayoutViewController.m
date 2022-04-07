//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDAudioAnalyzerLayoutViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDAudioAnalyzerLayoutViewController.h"
#import "SCIStackView.h"

@implementation SCDAudioAnalyzerLayoutViewController

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    [SCIThemeManager applyTheme:theme toThemeable:self.audioStreamChart];
    [SCIThemeManager applyTheme:theme toThemeable:self.fftChart];
    [SCIThemeManager applyTheme:theme toThemeable:self.spectrogramChart];
}

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    SCIChartSurface *audioStreamChart = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    SCIChartSurface *fftChart = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    SCIChartSurface *spectrogramChart = [[SCIChartSurface alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    SCIStackView *stackView = [SCIStackView new];
    stackView.axis = SCILayoutConstraintAxisHorizontal;
    stackView.distribution = SCIStackViewDistributionFillEqually;
    stackView.spacing = 0;
    [stackView addArrangedSubview:fftChart];
    [stackView addArrangedSubview:spectrogramChart];
    
    for (SCIView *surface in @[audioStreamChart, stackView]) {
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:surface];
    }
    
    [self.view addConstraints:@[
        [audioStreamChart.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [audioStreamChart.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [audioStreamChart.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [audioStreamChart.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.35],
        
        [stackView.topAnchor constraintEqualToAnchor:audioStreamChart.bottomAnchor],
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor]
    ]];
    
    _audioStreamChart = audioStreamChart;
    _fftChart = fftChart;
    _spectrogramChart = spectrogramChart;
}

@end
