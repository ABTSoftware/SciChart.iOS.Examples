//
//  SCDSplitViewController.m
//  SciChartDemo.Mac
//
//  Created by Andriy Pohorilko on 15.04.2020.
//  Copyright © 2020 SciChart Ltd. All rights reserved.
//

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
        NSString *themeKey = [appearenceName isEqualTo:NSAppearanceNameDarkAqua] ? SCIChart_SciChartv4DarkStyleKey : SCIChart_Bright_SparkStyleKey;
        
        SCDExampleBaseViewController.chartThemeKey = themeKey;
        if (_exampleViewController != nil) {
            [_exampleViewController tryUpdateChartThemeWithKey:themeKey];
        }
    }
}

@end
