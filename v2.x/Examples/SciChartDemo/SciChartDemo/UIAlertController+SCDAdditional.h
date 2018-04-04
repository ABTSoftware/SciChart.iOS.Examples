//
//  UIAlertController+_SCDAdditional.h
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 6/8/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (SCDAdditional)


+ (UIAlertController* _Nonnull)shareAlertControllerWithSwiftShareActionHandler:(void (^ __nullable)(UIAlertAction  * _Nullable action))handler
                                                     andObjcShareActionHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

+ (UIAlertController* _Nonnull)sourceAlertControllerWithSwiftSourceActionHandler:(void (^ __nullable)(UIAlertAction  * _Nullable action))handler
                                                      andObjcSourceActionHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;

+ (UIAlertController* _Nonnull)alerControllerWithFirstActionName:(NSString * _Nullable)actionName
                                                   actionHandler:(void (^ __nullable)(UIAlertAction  * _Nullable action))handler
                                             andSecondActionName:(NSString * _Nullable)secondActionName
                                       andObjcShareActionHandler:(void (^ __nullable)(UIAlertAction * _Nullable action))handler;



@end
