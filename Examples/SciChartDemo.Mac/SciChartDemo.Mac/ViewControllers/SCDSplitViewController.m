//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSplitViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSplitViewController.h"
#import "SCDExampleListViewController.h"
#import <SciChart.Examples/SCDConstants.h>
#import <SciChart.Examples/SCDExampleBaseViewController.h>

@implementation SCDSplitViewController {
    SCDExampleListViewController *_exampleListViewController;
    NSViewController *_detailViewController;
    
    __weak SCDExampleBaseViewController *_exampleViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _exampleListViewController = [SCDExampleListViewController new];
    _detailViewController = [NSViewController new];
    _detailViewController.view = [NSView new];
   
    self.splitView.autosaveName = @"Please Save Me!";
    [self addSplitViewItem:[NSSplitViewItem splitViewItemWithViewController:_exampleListViewController]];
    [self addSplitViewItem:[NSSplitViewItem splitViewItemWithViewController:_detailViewController]];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleSelectionChange:) name:EXAMPLE_SELECTION_CHANGED object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(effectiveAppearanceChanged:) name:APPEARENCE_CHANGED object:nil];
}

- (void)handleSelectionChange:(NSNotification *)notification {
    _exampleViewController = (SCDExampleBaseViewController *)notification.object;
    if (_exampleViewController == nil) return;
    
    for (NSViewController *vc in _detailViewController.childViewControllers) {
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }
    
    _exampleViewController.view.frame = _detailViewController.view.bounds;
    [_detailViewController addChildViewController:_exampleViewController];
    [_detailViewController.view addSubview:_exampleViewController.view];
}

- (void)effectiveAppearanceChanged:(NSNotification *)notification {
    if (@available(macOS 10.14, *)) {
        NSAppearanceName appearenceName = NSApplication.sharedApplication.effectiveAppearance.name;
        SCIChartTheme theme = [appearenceName isEqualTo:NSAppearanceNameDarkAqua] ? SCIChartThemeV4Dark : SCIChartThemeBrightSpark;
        
        SCDExampleBaseViewController.chartTheme = theme;
        if (_exampleViewController != nil) {
            [_exampleViewController tryUpdateChartTheme:theme];
        }
    }
}

@end
