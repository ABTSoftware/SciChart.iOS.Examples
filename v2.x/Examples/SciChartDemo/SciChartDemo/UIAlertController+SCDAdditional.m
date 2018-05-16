//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UIAlertController+SCDAdditional.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UIAlertController+SCDAdditional.h"

@implementation UIAlertController (SCDAdditional)

+ (UIAlertController *)shareAlertControllerWithSwiftShareActionHandler:(void (^)(UIAlertAction *))swiftHandler
                                             andObjcShareActionHandler:(void (^)(UIAlertAction *))objcHandler {
    
    return [self alerControllerWithFirstActionName:@"Share Swift Examples"
                                     actionHandler:swiftHandler
                               andSecondActionName:@"Share Objective-C Examples"
                         andObjcShareActionHandler:objcHandler];
    
};

+ (UIAlertController *)sourceAlertControllerWithSwiftSourceActionHandler:(void (^)(UIAlertAction * _Nullable))swiftHandler
                                              andObjcSourceActionHandler:(void (^)(UIAlertAction * _Nullable))objcHandler {
    
    return [self alerControllerWithFirstActionName:@"Source Code in Swift"
                                     actionHandler:swiftHandler
                               andSecondActionName:@"Source Code in Objective-C"
                         andObjcShareActionHandler:objcHandler];
    
}

+ (UIAlertController *)alerControllerWithFirstActionName:(NSString *)actionName
                                           actionHandler:(void (^)(UIAlertAction * _Nullable))firstHandler
                                     andSecondActionName:(NSString *)secondActionName
                               andObjcShareActionHandler:(void (^)(UIAlertAction * _Nullable))secondHandler {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction *swiftShareAction = [UIAlertAction actionWithTitle:actionName
                                                               style:UIAlertActionStyleDefault
                                                             handler:firstHandler];
    
    UIAlertAction *objcShareAction = [UIAlertAction actionWithTitle:secondActionName
                                                              style:UIAlertActionStyleDefault
                                                            handler:secondHandler];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];
    
    [alertController addAction:swiftShareAction];
    [alertController addAction:objcShareAction];
    [alertController addAction:cancel];
    
    return alertController;
    
}

@end
