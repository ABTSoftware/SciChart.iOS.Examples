//
//  SCDSplitViewController.m
//  SciChartDemo.Mac
//
//  Created by Andriy Pohorilko on 15.04.2020.
//  Copyright © 2020 SciChart Ltd. All rights reserved.
//

#import "SCDSplitViewController.h"
#import "SCDExampleListViewController.h"
#import <SciChart.Examples/SCDExampleBaseViewController.h>

@implementation SCDSplitViewController {
    SCDExampleListViewController *_exampleListViewController;
    NSViewController *_detailViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _exampleListViewController = [SCDExampleListViewController new];
    _detailViewController = [NSViewController new];
    _detailViewController.view = [NSView new];
   
    self.splitView.autosaveName = @"Please Save Me!";
    [self addSplitViewItem:[NSSplitViewItem splitViewItemWithViewController:_exampleListViewController]];
    [self addSplitViewItem:[NSSplitViewItem splitViewItemWithViewController:_detailViewController]];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleSelectionChange:) name:@"selectionChanged" object:NULL];
}

- (void)handleSelectionChange:(NSNotification *)notification {
    __weak SCDExampleBaseViewController *exampleVC = (SCDExampleBaseViewController *)notification.object;
    if (exampleVC == nil) return;
    
    for (NSViewController *vc in _detailViewController.childViewControllers) {
        [vc removeFromParentViewController];
        [vc.view removeFromSuperview];
    }
    
    exampleVC.view.frame = _detailViewController.view.bounds;
    [_detailViewController addChildViewController:exampleVC];
    [_detailViewController.view addSubview:exampleVC.view];
}

@end
