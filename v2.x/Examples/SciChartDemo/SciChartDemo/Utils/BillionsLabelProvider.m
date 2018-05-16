//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BillionsLabelProvider.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "BillionsLabelProvider.h"

@implementation BillionsLabelProvider

- (NSAttributedString *)formatLabel:(SCIGenericType)dataValue {
    NSString * formattedValue = [NSString stringWithFormat: @"%@B", [super formatLabel:SCIGeneric(SCIGenericDouble(dataValue) / pow(10, 9))].string];
    return [[NSMutableAttributedString alloc] initWithString:formattedValue];
}

@end
