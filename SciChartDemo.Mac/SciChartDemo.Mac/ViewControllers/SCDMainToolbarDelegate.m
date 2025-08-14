//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMainToolbarDelegate.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMainToolbarDelegate.h"
#import <AppKit/NSToolbarItem.h>
#import <SciChart.Examples/SCDConstants.h>
#import <SciChart.Examples/SCDToolbarTitle.h>
#import <SciChart.Examples/SCDToolbarFlexibleSpace.h>
#import <SciChart.Examples/SCDToolbarButton.h>
#import <SciChart.Examples/SCDToolbarButtonsGroup.h>
#import <SciChart.Examples/SCDExampleBaseViewController.h>
#import <SciChart.Examples/SCDExamplesDataSource.h>
#import "SCDExampleListViewController.h"

@implementation SCDMainToolbarDelegate {
    NSToolbar *_toolbar;
    NSMutableDictionary<NSString *, id<ISCDToolbarItem>> *_toolbarItems;
    NSUInteger _initialToolbarItemsCount;
    BOOL isSwift;
    NSInteger _myInt;
}

- (instancetype)initWithToolbar:(NSToolbar *)toolbar {
    self = [super init];
    if (self) {
        _toolbar = toolbar;
        _toolbarItems = [NSMutableDictionary<NSString *, id<ISCDToolbarItem>> new];
        isSwift = YES;
        
        [self addInitialItems:@[
            [self p_SCD_createExamplesTypeToolbarSegment],
            [[SCDToolbarTitle alloc] initWithTitle:@"SciChart macOS"],
            [SCDToolbarFlexibleSpace new],
            [self p_SCD_createIsSwiftToolbarItem]
        ]];
    }
    return self;
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar {
    return @[];
}

- (NSArray<NSToolbarItemIdentifier> *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar {
    return @[TOOLBAR_EXAMPLES_SELECTOR, TOOLBAR_TITLE, TOOLBAR_IS_SWIFT];
}

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSToolbarItemIdentifier)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag {
    if (![toolbar.identifier isEqualToString:MAIN_TOOLBAR]) return nil;
    
    NSToolbarItem *toolbarItem = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    toolbarItem.view = [_toolbarItems[itemIdentifier] createView];

    return toolbarItem;
}

#pragma mark - Update toolbar Items

- (void)addInitialItems:(NSArray<id<ISCDToolbarItem>> *)items {
    for (id<ISCDToolbarItem> item in items) {
        [self p_SCD_insertItem:item atIndex:_toolbar.items.count];
    }
    
    _initialToolbarItemsCount = items.count;
}

- (void)updateTitle:(id<ISCDToolbarItem>)titleItem {
    NSInteger titleIndex = [self p_SCD_toolbar:_toolbar indexOfItemWithIdentifier:titleItem.identifier];
    if (titleIndex == -1) return;
    
    [_toolbar removeItemAtIndex:titleIndex];
    [self p_SCD_insertItem:titleItem atIndex:titleIndex];
}

- (void)updateExampleItems:(NSArray<id<ISCDToolbarItem>> *)items {
    while (_toolbar.items.count > _initialToolbarItemsCount) {
        NSUInteger indexToRemove = _toolbar.items.count - 2;
        NSString *keyToRemove = [_toolbar.items objectAtIndex:indexToRemove].itemIdentifier;
        
        [_toolbar removeItemAtIndex:_toolbar.items.count - 2];
        [_toolbarItems removeObjectForKey:keyToRemove];
    }

    for (id<ISCDToolbarItem> item in items) {
        [self p_SCD_insertItem:item atIndex:_toolbar.items.count - 1];
    }
}

#pragma mark - Helper Methods

- (void)p_SCD_insertItem:(id<ISCDToolbarItem>)item atIndex:(NSInteger)index {
    [_toolbarItems setObject:item forKey:item.identifier];
    [_toolbar insertItemWithItemIdentifier:item.identifier atIndex:index];
}

- (NSInteger)p_SCD_toolbar:(NSToolbar *)toolbar indexOfItemWithIdentifier:(NSString *)identifier {
    for (NSUInteger i = 0, count = toolbar.items.count; i < count; i++) {
        if ([toolbar.items[i].itemIdentifier isEqualToString:identifier]) {
            return i;
        }
    }
    
    return -1;
}

// MARK: - Toolbar
- (id<ISCDToolbarItem>)p_SCD_createExamplesTypeToolbarSegment {
    NSInteger selectedSegment;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _myInt = [prefs integerForKey:@"indexValue"];
    if (_myInt==0)  {
        selectedSegment = 0;
    } else if (_myInt==1) {
        selectedSegment = 1;
    } else {
        selectedSegment = 2;
    }
    id<ISCDToolbarItem> item = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarButton alloc] initWithTitle:@"2D" image:nil andAction:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SWITCH_EXAMPLE_CATEGORY object:Examples2DPlistFileName userInfo:@{@"identifier": TOOLBAR_2D}];
    }],
        [[SCDToolbarButton alloc] initWithTitle:@"3D" image:nil andAction:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SWITCH_EXAMPLE_CATEGORY object:Examples3DPlistFileName userInfo:@{@"identifier": TOOLBAR_3D}];
    }],
        [[SCDToolbarButton alloc] initWithTitle:@"Featured" image:nil andAction:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SWITCH_EXAMPLE_CATEGORY object:FeaturedAppsPlistName userInfo:@{@"identifier": TOOLBAR_Apps}];
    }],
    ] withTrackingMode:NSSegmentSwitchTrackingSelectOne andSelectedSegment:selectedSegment];
    item.identifier = TOOLBAR_EXAMPLES_SELECTOR;

    return item;
}

- (id<ISCDToolbarItem>)p_SCD_createIsSwiftToolbarItem {
    id<ISCDToolbarItem> item = [[SCDToolbarButton alloc] initWithTitle:@"Is Swift" image:[SCIImage imageNamed:@"icon.swift"] isSelected:isSwift andAction:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:SWITCH_EXAMPLE_CATEGORY object:nil userInfo:@{@"identifier": TOOLBAR_IS_SWIFT, @"data": @(self->isSwift)}];
    }];
    item.identifier = TOOLBAR_IS_SWIFT;

    return item;
}


@end
