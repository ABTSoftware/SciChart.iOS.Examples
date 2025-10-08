//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2025. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMainWindowController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMainWindowController.h"
#import "SCDMainToolbarDelegate.h"
#import <SciChart.Examples/SCDToolbarTitle.h>
#import <SciChart.Examples/SCDToolbarFlexibleSpace.h>
#import <SciChart.Examples/SCDToolbarButton.h>
#import <SciChart.Examples/SCDToolbarButtonsGroup.h>
#import <SciChart.Examples/SCDConstants.h>
#import <SciChart.Examples/SCDExampleBaseViewController.h>
#import <SciChart.Examples/SCDExamplesDataSource.h>
#import "SCDExampleListViewController.h"

@implementation SCDMainWindowController
{
    NSInteger _myInt;
    SCDExamplesDataSource *_examplesDataSource;
    SCDMainToolbarDelegate *_toolbarDelegate;
    SCDExampleListViewController *exampleList;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSSplitViewController *splitVC = (NSSplitViewController *)self.contentViewController;
    
    if ([splitVC isKindOfClass:[NSSplitViewController class]]) {
        NSSplitViewItem *item = splitVC.splitViewItems.firstObject;
        if ([item.viewController isKindOfClass:[SCDExampleListViewController class]]) {
            
            exampleList = (SCDExampleListViewController *)item.viewController;
        }
    }
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _myInt = [prefs integerForKey:@"indexValue"];
    if (_myInt==0)  {
        [exampleList updateDataSourceFromFile:Examples2DPlistFileName];
    } else if (_myInt==1) {
        [exampleList updateDataSourceFromFile:Examples3DPlistFileName];
    } else if (_myInt==2) {
        [exampleList updateDataSourceFromFile:FeaturedAppsPlistName];
    }
    
    [self.window setTitle:@""];
    
    [self p_SCD_createToolbar];
}

- (void)p_SCD_createToolbar {
    NSWindow *window = self.window;
    if (!window) return;

    if (![window.toolbar.identifier isEqual:MAIN_TOOLBAR]) {
        NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:MAIN_TOOLBAR];
        
        if (@available(macOS 10.14, *)) {
            toolbar.centeredItemIdentifier = TOOLBAR_TITLE;
        }

        _toolbarDelegate = [[SCDMainToolbarDelegate alloc] initWithToolbar:toolbar];
        toolbar.delegate = _toolbarDelegate;

        self.window.toolbar = toolbar;
        exampleList.toolbarDelegate = _toolbarDelegate;
    }
}
@end
