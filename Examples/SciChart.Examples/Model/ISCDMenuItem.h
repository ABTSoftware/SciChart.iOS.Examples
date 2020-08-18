//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ISCDMenuItem.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <SciChart/SciChart.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ISCDMenuItem <NSObject>

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic, nullable) NSString *subtitle;
@property (strong, nonatomic) SCIImage *icon;
@property (nonatomic, nullable) dispatch_block_t action;

@end

NS_ASSUME_NONNULL_END
