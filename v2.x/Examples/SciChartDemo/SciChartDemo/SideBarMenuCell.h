//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SideBarMenuCell.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <UIKit/UIKit.h>

@interface SideBarMenuCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *SettingName;
@property (strong, nonatomic) IBOutlet UIImageView *SettingImage;
@property (strong) NSString *SettingSegue;

-(instancetype)initWithSettingName:(NSString *)settingName
                       settingIcon:(NSString *)settingIcon
                      settingSegue:(NSString *)settingSegue;

@end
