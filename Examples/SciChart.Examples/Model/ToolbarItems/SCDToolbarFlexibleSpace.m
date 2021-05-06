//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDToolbarFlexibleSpace.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDToolbarFlexibleSpace.h"
#import <SciChart/NSObject+ExceptionUtil.h>
#if TARGET_OS_OSX
#import <AppKit/NSToolbarItem.h>
#endif

@implementation SCDToolbarFlexibleSpace

- (instancetype)init {
    self = [super init];
    if (self) {
#if TARGET_OS_OSX
        self.identifier = NSToolbarFlexibleSpaceItemIdentifier;
#endif
    }
    return self;
}

- (SCIView *)createView {
    @throw [self notImplementedExceptionFor:_cmd];
}

@end
