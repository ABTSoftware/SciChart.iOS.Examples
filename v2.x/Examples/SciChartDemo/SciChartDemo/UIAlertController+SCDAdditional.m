//
//  UIAlertController+_SCDAdditional.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 6/8/16.
//  Copyright © 2016 ABT. All rights reserved.
//

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
