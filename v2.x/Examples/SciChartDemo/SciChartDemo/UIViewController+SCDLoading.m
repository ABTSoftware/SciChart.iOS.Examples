//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UIViewController+SCDLoading.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UIViewController+SCDLoading.h"

static NSString *viewLoadingName = @"SCDLoadingView";
static int viewLoadingTag = 999;

@implementation UIViewController (SCDLoading)


- (void)startAnimating {
    
    if (![self.view.window viewWithTag:viewLoadingTag]) {
        UIView *viewLoading = [[[NSBundle mainBundle] loadNibNamed:viewLoadingName owner:self options:nil] firstObject];
        viewLoading.tag = viewLoadingTag;
        viewLoading.frame = self.view.window.bounds;
        viewLoading.translatesAutoresizingMaskIntoConstraints = YES;
        viewLoading.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.view.window addSubview:viewLoading];
    }
    
    
}

- (void)stopAnimating {
    if ([self.view.window viewWithTag:viewLoadingTag]) {
        [[self.view.window viewWithTag:viewLoadingTag] removeFromSuperview];
    }
}

@end
