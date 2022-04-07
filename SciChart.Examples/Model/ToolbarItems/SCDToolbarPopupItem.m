//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDToolbarPopupItem.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDToolbarPopupItem.h"

#if TARGET_OS_OSX
#import <AppKit/NSPopUpButton.h>
#endif
#import "SCDPanelButton.h"

@interface SCDToolbarPopupItem ()

@property (nonatomic, copy) void (^action)(NSUInteger selectedIndex);

@end

@implementation SCDToolbarPopupItem {
    NSArray<NSString *> *_titles;
    NSUInteger _selectedIndex;
    SCIButton *_createdButton;
}

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles selectedIndex:(NSUInteger)selectedIndex andAction:(void (^)(NSUInteger selectedIndex))action {
    self = [super init];
    if (self) {
        _titles = titles;
        _selectedIndex = selectedIndex;
        self.action = action;
    }
    return self;
}

- (SCIView *)createView {
#if TARGET_OS_OSX
    NSPopUpButton *popUpButton = [NSPopUpButton new];
    [popUpButton addItemsWithTitles:_titles];
    [popUpButton selectItemAtIndex:_selectedIndex];
    popUpButton.target = self;
    popUpButton.action = @selector(p_SCD_onPopUpButtonSelect:);
    
    _createdButton = (SCIButton *)popUpButton;
#elif TARGET_OS_IOS
    _createdButton = [[SCDPanelButton alloc] initWithTitle:_titles[_selectedIndex] target:self selector:@selector(p_SCD_onButtonPress:)];
#endif
    return _createdButton;
}

#if TARGET_OS_OSX
- (void)p_SCD_onPopUpButtonSelect:(NSPopUpButton *)sender {
    self.action(sender.indexOfSelectedItem);
}
#elif TARGET_OS_IOS
- (void)p_SCD_onButtonPress:(SCDPanelButton *)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select orientation" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(self) wSelf = self;
    for (NSInteger i = 0, count = _titles.count; i < count; i++) {
        [alertController addAction:[UIAlertAction actionWithTitle:_titles[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self->_createdButton setTitleCommon:self->_titles[i]];
            wSelf.action(i);
        }]];
    }
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    alertController.popoverPresentationController.sourceView = _createdButton;
    alertController.popoverPresentationController.sourceRect = CGRectMake(CGRectGetMidX(_createdButton.bounds), CGRectGetMidY(_createdButton.bounds),0,0);
    
    [[self p_SCD_topViewController] presentViewController:alertController animated:YES completion:nil];
}

- (UIViewController *)p_SCD_topViewController {
    UIViewController *topViewController = UIApplication.sharedApplication.keyWindow.rootViewController;
    while (true) {
        if (topViewController.presentedViewController) {
            topViewController = topViewController.presentedViewController;
        } else if ([topViewController isKindOfClass:UINavigationController.class]) {
            UINavigationController *nav = (UINavigationController *)topViewController;
            topViewController = nav.topViewController;
        } else if ([topViewController isKindOfClass:UITabBarController.class]) {
            UITabBarController *tab = (UITabBarController *)topViewController;
            topViewController = tab.selectedViewController;
        } else {
            break;
        }
    }
    
    return topViewController;
}

#endif

@end
