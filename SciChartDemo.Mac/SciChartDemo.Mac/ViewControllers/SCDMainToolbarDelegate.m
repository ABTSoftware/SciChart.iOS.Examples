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

@implementation SCDMainToolbarDelegate {
    NSToolbar *_toolbar;
    NSMutableDictionary<NSString *, id<ISCDToolbarItem>> *_toolbarItems;
    NSUInteger _initialToolbarItemsCount;
}

- (instancetype)initWithToolbar:(NSToolbar *)toolbar {
    self = [super init];
    if (self) {
        _toolbar = toolbar;
        _toolbarItems = [NSMutableDictionary<NSString *, id<ISCDToolbarItem>> new];
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

@end
