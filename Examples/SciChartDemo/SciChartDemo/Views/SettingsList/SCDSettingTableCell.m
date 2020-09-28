//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSettingTableCell.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSettingTableCell.h"

@interface SCDSettingTableCell ()

@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation SCDSettingTableCell

+ (NSString *)reuseId { return NSStringFromClass(SCDSettingTableCell.class); }

- (void)updateWithText:(NSString *)text andIcon:(UIImage *)icon {
    self.icon.image = icon;
    self.label.text = text;
}

@end
