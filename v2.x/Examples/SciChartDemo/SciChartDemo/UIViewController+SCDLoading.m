//
//  UIViewController+SCDLoading.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 6/8/16.
//  Copyright © 2016 ABT. All rights reserved.
//

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
