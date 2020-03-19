//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDBorderedView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDBorderedView.h"

@implementation SCDBorderedView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 2;
    self.layer.borderColor = [[UIColor colorWithRed:217 green:217 blue:193 alpha:1] CGColor];
    self.layer.borderWidth = 1;
    self.clipsToBounds = YES;
}

@end
