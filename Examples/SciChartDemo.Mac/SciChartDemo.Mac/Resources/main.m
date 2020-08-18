#import <Cocoa/Cocoa.h>
#import "AppDelegate.h"
#import <dlfcn.h>
#import <sys/types.h>

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif

void disable_gdb() {
    void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
    ptrace_ptr_t ptrace_ptr = dlsym(handle, "ptrace");
    ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
    dlclose(handle);
}

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
