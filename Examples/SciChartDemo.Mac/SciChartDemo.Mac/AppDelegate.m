#import "AppDelegate.h"
#import "SCDSplitViewController.h"
#import <AppKit/NSScreen.h>

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
    
    if (@available(macOS 10.16, *)) {
        window.toolbarStyle = NSWindowToolbarStyleUnified;
    }
    
    [window makeKeyAndOrderFront:nil];
    [window setFrame:rect display:YES];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

@end
