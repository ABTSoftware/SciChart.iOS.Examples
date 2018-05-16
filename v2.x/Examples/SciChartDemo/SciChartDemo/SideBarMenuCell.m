//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SideBarMenuCell.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SideBarMenuCell.h"

@implementation SideBarMenuCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}


-(instancetype)initWithSettingName:(NSString *)settingName
                       settingIcon:(NSString *)settingIcon
                      settingSegue:(NSString *)settingSegue{
    self = [super init];
    if(self){
        self.SettingName = [[UILabel alloc]init];
        self.SettingImage = [[UIImageView alloc]init];
        self.SettingSegue = [[NSString alloc]init];
        
        self.SettingName.text = settingName;
        self.SettingImage.image = [UIImage imageNamed:settingIcon];
        self.SettingSegue = settingSegue;
    }
    return self;
}

@end
