//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSwitchItem.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDToolbarItemBase.h"
#import <SciChart/SCIButton.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SCDSwitchItemAction) (BOOL isSelected);

@interface SCDSwitchItem : SCDToolbarItemBase

@property (nonatomic) NSString *title;
@property (nonatomic) BOOL isSelected;
@property (nonatomic, copy) SCDSwitchItemAction action;

- (instancetype)initWithTitle:(NSString *)title isSelected:(BOOL)isSelected andAction:(SCDSwitchItemAction)action;

#if TARGET_OS_OSX
- (void)onButtonSelect:(SCIButton *)sender;
#endif

@end

NS_ASSUME_NONNULL_END
