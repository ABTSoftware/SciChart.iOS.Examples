//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDAlertPresenter.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDAlertPresenter.h"
#if TARGET_OS_OSX
#import <AppKit/NSAlert.h>
#elif TARGET_OS_IOS
#import <UIKit/UIAlertController.h>
#import "SCDTopViewControllerProvider.h"
#endif

@implementation SCDAlertPresenter {
#if TARGET_OS_IOS
    UIAlertController * _alertPopup;
#endif
}

- (instancetype)initWithMessage:(NSString *)message {
    self = [super init];
    if (self) {
#if TARGET_OS_OSX
        NSAlert *alert = [NSAlert new];
        alert.messageText = message;
       
        [alert runModal];
#elif TARGET_OS_IOS
        _alertPopup = [UIAlertController alertControllerWithTitle:@"HitTestInfo" message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [SCDTopViewControllerProvider.topViewController presentViewController:_alertPopup animated:YES completion:nil];
        
        [self performSelector:@selector(dismissAlert) withObject:_alertPopup afterDelay:1];
#endif
    }
    return self;
}

#if TARGET_OS_IOS
- (void)dismissAlert {
    [_alertPopup dismissViewControllerAnimated:YES completion:nil];
}
#endif

@end
