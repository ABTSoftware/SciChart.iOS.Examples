//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UIAlertController+SCDAdditional.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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
