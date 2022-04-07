//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMenuItem.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMenuItem.h"

@implementation SCDMenuItem

@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize icon = _icon;
@synthesize action = _action;

- (instancetype)initWithTitle:(NSString *)title subtitle:(NSString *)subtitle iconImageName:(NSString *)imageName andAction:(dispatch_block_t)action {
    self = [super init];
    if (self) {
        _title = title;
        _subtitle = subtitle;
        _icon = [SCIImage imageNamed:imageName];
        _action = action;
    }
    return self;
}

@end
