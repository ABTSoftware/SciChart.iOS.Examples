//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// main.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import <dlfcn.h>
#import <sys/types.h>

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif

#if !(DEBUG)
static void disable_gdb() {
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
}
#endif

int main(int argc, const char * argv[]) {
#if !(DEBUG) // Don't interfere with Xcode debugging sessions.
    disable_gdb();
#endif
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        NSApplication *app = NSApplication.sharedApplication;
        [NSApp setActivationPolicy:NSApplicationActivationPolicyRegular];
        
        AppDelegate *appDelegate = [AppDelegate new];
        app.delegate = appDelegate;
        
        [app run];
    }
    
    return NSApplicationMain(argc, argv);
}
