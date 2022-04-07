//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AppMenu.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AppMenu.h"
#import <AppKit/NSApplication.h>
#import <AppKit/NSWindow.h>
#import <AppKit/NSTextField.h>

@implementation AppMenu

- (NSString *)appName {
    return NSProcessInfo.processInfo.processName;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMenuItem *mainMenu = [NSMenuItem new];
        mainMenu.submenu = [[NSMenu alloc] initWithTitle:@"MainMenu"];
        mainMenu.submenu.itemArray = @[
            [self itemWithTitle:[@"About " stringByAppendingString:self.appName] action:@selector(orderFrontStandardAboutPanel:)],
            NSMenuItem.separatorItem,
            [self itemWithTitle:@"Preferences..." action:nil key:@","],
            NSMenuItem.separatorItem,
            [self itemWithTitle:[@"Hide " stringByAppendingString:self.appName] action:@selector(hide:) key:@"h"],
            [self itemWithTitle:@"Hide Others" action:@selector(hideOtherApplications:) key:@"h" andModifierMask:NSEventModifierFlagCommand | NSEventModifierFlagOption],
            [self itemWithTitle:@"Show All" action:@selector(unhideAllApplications:) key:@""],
            NSMenuItem.separatorItem,
            [self itemWithTitle:[@"Quit " stringByAppendingString:self.appName] action:@selector(terminate:) key:@"q"],
        ];
        
        NSMenuItem *viewMenu = [NSMenuItem new];
        viewMenu.submenu = [[NSMenu alloc] initWithTitle:@"View"];
        viewMenu.submenu.itemArray = @[
            [self itemWithTitle:@"Full Screen" action:@selector(toggleFullScreen:) key:@"f" andModifierMask:NSEventModifierFlagCommand | NSEventModifierFlagControl],
        ];
        
        NSMenuItem *windowMenu = [NSMenuItem new];
        windowMenu.submenu = [[NSMenu alloc] initWithTitle:@"Window"];
        windowMenu.submenu.itemArray = @[
            [self itemWithTitle:@"Minimize" action:@selector(miniaturize:) key:@"m"],
            [self itemWithTitle:@"Zoom" action:@selector(performZoom:)],
            NSMenuItem.separatorItem,
            [self itemWithTitle:@"Show All" action:@selector(arrangeInFront:) key:@"m"],
        ];
        
        NSMenuItem *helpMenu = [NSMenuItem new];
        NSMenuItem *helpMenuSearch = [NSMenuItem new];
        helpMenuSearch.view = [NSTextField new];
        helpMenu.submenu = [[NSMenu alloc] initWithTitle:@"Help"];
        helpMenu.submenu.itemArray = @[
            helpMenuSearch
        ];
        
        self.itemArray = @[mainMenu, viewMenu, windowMenu, helpMenu];
    }
    return self;
}

- (NSMenuItem *)itemWithTitle:(NSString *)title action:(SEL)action {
    return [self itemWithTitle:title action:action key:@""];
}

- (NSMenuItem *)itemWithTitle:(NSString *)title action:(SEL)action key:(NSString *)key {
    return [[NSMenuItem alloc] initWithTitle:title action:action keyEquivalent:key];
}

- (NSMenuItem *)itemWithTitle:(NSString *)title action:(SEL)action key:(NSString *)key andModifierMask:(NSEventModifierFlags)mask {
    NSMenuItem *item = [self itemWithTitle:title action:action key:key];
    [item setKeyEquivalentModifierMask:mask];
    
    return item;
}

@end
