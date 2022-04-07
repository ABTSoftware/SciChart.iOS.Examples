//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSettingsPresenter.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSettingsPresenter.h"
#import<SciChart/SCIView.h>
#import "SCDConstants.h"
#import "SCDSettingsViewController.h"
#if TARGET_OS_OSX
#import <AppKit/NSToolbarItem.h>
#elif TARGET_OS_IOS
#import "SCDTopViewControllerProvider.h"
#endif

@implementation SCDSettingsPresenter {
    SCIViewController *_settingsViewController;
    NSString *_identifier;
}

- (instancetype)initWithSettingsItems:(NSArray<id<ISCDToolbarItem>> *)settingsItems andIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _settingsViewController = [[SCDSettingsViewController alloc] initWithSettingsItems:settingsItems];
        _identifier = identifier;
        [self p_SCD_showContentView];
    }
    return self;
}

- (void)p_SCD_showContentView {
#if TARGET_OS_OSX
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"itemIdentifier == %@", _identifier];
    NSArray<NSToolbarItem *> *items = [NSApp.mainWindow.toolbar.items filteredArrayUsingPredicate:resultPredicate];
    SCIView *toolbarView = [items firstObject].view;
    CGRect relativeRect = toolbarView.bounds;
    relativeRect.origin.y += 20;
    
    NSPopover *popover = [NSPopover new];
    popover.contentViewController = _settingsViewController;
    popover.behavior = NSPopoverBehaviorTransient;
    
    [popover showRelativeToRect:relativeRect ofView:toolbarView preferredEdge:NSRectEdgeMaxY];
#elif TARGET_OS_IOS
    _settingsViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [SCDTopViewControllerProvider.topViewController presentViewController:_settingsViewController animated:YES completion:nil];
#endif
}

@end
