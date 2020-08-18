//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// NSViewController+UIViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "NSViewController+UIViewController.h"

#if TARGET_OS_OSX

#import <SciChart/SCIObjCRuntimeHelper.h>

@implementation NSViewController (UIViewController)

#pragma mark - Swizzling methods

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [SCIObjCRuntimeHelper swizzleSelector:@selector(viewWillAppear) withSelector:@selector(p_SCI_viewWillAppear) forClass:self.class];
        [SCIObjCRuntimeHelper swizzleSelector:@selector(viewDidDisappear) withSelector:@selector(p_SCI_viewDidDisappear) forClass:self.class];
    });
}

#pragma mark - Swizzling AppKit System’s viewWillAppear

- (void)p_SCI_viewWillAppear {
    [self viewWillAppear:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [self p_SCI_viewWillAppear];
}

#pragma mark - Swizzling AppKit System’s viewDidDisappear

- (void)p_SCI_viewDidDisappear {
    [self viewDidDisappear:NO];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self p_SCI_viewDidDisappear];
}

@end

#endif
