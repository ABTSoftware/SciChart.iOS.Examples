//
//  SciModifierModel.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "SciModifierModel.h"

@implementation SciModifierModel

@synthesize Title;
@synthesize ModifierDecription;
@synthesize Icon;
@synthesize ClassName;
@synthesize Enabled;

-(instancetype) initWithTitle:(NSString *)title ModifierDescription:(NSString *)description Icon:(UIImage *)icon ClassName:(NSString *)className{
    if((self = [super init])){
        Title = title;
        ModifierDecription = description;
        Icon = icon;
        ClassName = className;
        Enabled = false;
    }
    return self;
}

@end
