//
//  ThousandsLabelProvider.m
//  SciChartDemo
//
//  Created by Admin on 04/05/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "ThousandsLabelProvider.h"

@implementation ThousandsLabelProvider

-(NSString*)formatLabel:(SCIGenericType)dataValue{
    return [NSString stringWithFormat:@"%.1fk", SCIGenericDouble(dataValue)/1000];
}

@end
