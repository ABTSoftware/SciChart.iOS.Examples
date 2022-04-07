//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMenuItem.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ISCDMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface SCDMenuItem : NSObject<ISCDMenuItem>

- (instancetype)initWithTitle:(NSString *)title subtitle:(nullable NSString *)subtitle iconImageName:(nullable NSString *)imageName andAction:(nullable dispatch_block_t)action;

@end

NS_ASSUME_NONNULL_END
