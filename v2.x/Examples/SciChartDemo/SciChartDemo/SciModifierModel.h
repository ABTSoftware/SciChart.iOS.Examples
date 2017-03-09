//
//  SciModifierModel.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

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
