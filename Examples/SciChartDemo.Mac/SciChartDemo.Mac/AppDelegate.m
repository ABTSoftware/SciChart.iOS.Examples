//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AppDelegate.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AppDelegate.h"
#import "SCDSplitViewController.h"
#import <SciChart.Examples/SCDConstants.h>
#import <AppKit/NSScreen.h>
#import "AppMenu.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    NSSize screenSize = NSScreen.mainScreen.frame.size;
    NSSize windowSize = NSMakeSize(1400, 800);
    NSRect rect = NSMakeRect(screenSize.width / 2 - windowSize.width / 2,
                             screenSize.height / 2 - windowSize.height / 2,
                             windowSize.width,
                             windowSize.height);
    
    NSWindow *window = [NSWindow windowWithContentViewController:[SCDSplitViewController new]];
    window.styleMask = NSWindowStyleMaskMiniaturizable | NSWindowStyleMaskClosable | NSWindowStyleMaskResizable | NSWindowStyleMaskTitled;
    window.backingType = NSBackingStoreBuffered;
    window.titleVisibility = NSWindowTitleHidden;
    
    if (@available(macOS 11, *)) {
        // TODO: Uncomment after BigSur official release
        // window.toolbarStyle = NSWindowToolbarStyleUnified;
    }
    
    [window makeKeyAndOrderFront:nil];
    [window setFrame:rect display:YES];
    
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial;
    [NSApplication.sharedApplication addObserver:self forKeyPath:@"effectiveAppearance" options:options context:nil];
    
    NSApplication.sharedApplication.mainMenu = [AppMenu new];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    [NSNotificationCenter.defaultCenter postNotificationName:APPEARENCE_CHANGED object:self userInfo:nil];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
