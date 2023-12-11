//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomSeriesInfoProvider.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CustomSeriesInfoProvider.h"


#pragma mark - Custom Tooltips

@interface CustomXySeriesTooltip : SCIXySeriesTooltip
@property(nonatomic, weak) id <CustomXySeriesTooltipDelegate> delegate;
@end

@implementation CustomXySeriesTooltip
@synthesize delegate;

- (void)internalUpdateWithSeriesInfo:(SCIXySeriesInfo *)seriesInfo {
    NSString *string = NSString.empty;
    string = [string stringByAppendingFormat:@"X: %@\n", seriesInfo.formattedXValue.rawString];
    string = [string stringByAppendingFormat:@"Y: %@", seriesInfo.formattedYValue.rawString];

    self.text = string;

    [self setSeriesColor:0xFFFFFFFF];

    [delegate getTouchDataSeriesIndex: seriesInfo.dataSeriesIndex];
}
@end

#pragma mark - Custom Info Providers

@implementation CustomSeriesInfoProvider
@synthesize delegate;

- (id<ISCISeriesTooltip>)getSeriesTooltipInternalWithSeriesInfo:(SCIXySeriesInfo *)seriesInfo modifierType:(Class)modifierType {
    if (modifierType == SCITooltipModifier.class) {
        CustomXySeriesTooltip *customXySeriesTooltip = [[CustomXySeriesTooltip alloc] initWithSeriesInfo:seriesInfo];
        customXySeriesTooltip.delegate = self;
        return customXySeriesTooltip;
    } else {
        return [super getSeriesTooltipInternalWithSeriesInfo:seriesInfo modifierType:modifierType];
    }
}

- (void)getTouchDataSeriesIndex:(NSInteger)dataSeriesIndex {
    [delegate getTouchDataSeriesIndex: dataSeriesIndex];
}
@end
