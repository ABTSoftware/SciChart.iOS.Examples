//
//  SideBarMenuCell.m
//  SciChartDemo
//
//  Created by Admin on 04.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

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
