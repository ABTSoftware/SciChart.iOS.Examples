//
//  SideBarMenuCell.h
//  SciChartDemo
//
//  Created by Admin on 04.03.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarMenuCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *SettingName;
@property (strong, nonatomic) IBOutlet UIImageView *SettingImage;
@property (strong) NSString *SettingSegue;

-(instancetype)initWithSettingName:(NSString *)settingName
                       settingIcon:(NSString *)settingIcon
                      settingSegue:(NSString *)settingSegue;

@end
