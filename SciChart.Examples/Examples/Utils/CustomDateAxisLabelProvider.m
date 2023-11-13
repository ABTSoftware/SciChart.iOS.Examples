//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomDateAxisLabelProvider.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
#import "DateAxisChartView.h"
#import <SciChart/SCILabelProviderBase+Protected.h>

@interface CustomDateAxisLabelProvider : SCILabelProviderBase
@end

@implementation CustomDateAxisLabelProvider {
    NSDateFormatter *_dateFormatter;
}

- (instancetype)init {
    self = [super initWithAxisType:@protocol(ISCIDateAxis)];
    if (self) {
        _dateFormatter = [NSDateFormatter createWithFormat:@"hh:mm dd/mm/yyyy"];
    }
    return self;
}

- (NSString *)formatDate:(NSDate *)itemDate isCommon:(BOOL)isCommonValue {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    if (isCommonValue) {
        [dateFormat setDateFormat:@"HH:mm\t"];
        NSString *itemString = [dateFormat stringFromDate:itemDate];
        NSDate *commonDate = [dateFormat dateFromString:itemString];
        return [dateFormat stringFromDate:commonDate];
    } else {
        [dateFormat setDateFormat:@"MMM dd\nHH:mm"];
        NSString *itemString = [dateFormat stringFromDate:itemDate];
        NSDate *zeroLastDate = [dateFormat dateFromString:itemString];
        return [dateFormat stringFromDate:zeroLastDate];
    }
    return @"";
}

- (void)updateTickLabels:(NSMutableArray<id<ISCIString>> *)formattedTickLabels majorTicks:(SCIDoubleValues *)majorTicks {
    NSInteger size = majorTicks.count;
    double *majorTicksArray = majorTicks.itemsArray;
    NSString  *formattedValue;
    for (NSInteger i = 0, count = majorTicks.count; i < count; i ++) {
        double valueToFormat = majorTicksArray[i];
        NSDate *item = [NSDate dateWithTimeIntervalSince1970:majorTicksArray[i]];
        if (i == 0 || i == size - 1) {
            formattedValue = [self formatDate:item isCommon:NO];
        } else {
            formattedValue = [self formatDate:item isCommon:YES];
        }
        [formattedTickLabels addObject:formattedValue];
    }
}


@end
