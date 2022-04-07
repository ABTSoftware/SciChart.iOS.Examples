//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// OnboardingPageViewController.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <UIKit/UIKit.h>

@interface OnboardingPageViewController : UIViewController{
    IBOutlet UILabel *TitleLabel;
    IBOutlet UILabel *DescriptionLabel;
    IBOutlet UIButton* ImageButton;
}

@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) UIImage *Image;
@property (strong, nonatomic) NSString *ImageClickUrl;

@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (strong, nonatomic) IBOutlet UIButton *ImageButton;

- (IBAction)handleButtonClick:(id)sender;

@end
