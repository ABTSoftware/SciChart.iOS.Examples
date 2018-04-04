//
//  BillionsLabelProvider.m
//  SciChartDemo
//
//  Created by Admin on 04/05/2017.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "BillionsLabelProvider.h"

@implementation BillionsLabelProvider

- (NSString *)formatLabel:(SCIGenericType)dataValue {
    return [NSString stringWithFormat: @"%@B", [super formatLabel:SCIGeneric(SCIGenericDouble(dataValue) / pow(10, 9))]];
}

@end
