//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SciModifierModel.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SciModifierModel : NSObject

@property (nonatomic, strong) NSString * Title;
@property (nonatomic, strong) NSString * ModifierDecription;
@property (nonatomic, strong) UIImage * Icon;
@property (nonatomic, strong) NSString* ClassName;
@property (nonatomic) Boolean Enabled;

-(instancetype) initWithTitle:(NSString*) title
          ModifierDescription:(NSString*) description
                         Icon:(UIImage*) icon
                    ClassName:(NSString*) className;

@end
