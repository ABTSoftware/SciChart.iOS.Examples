//
//  OnboardingPageViewController.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/21/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

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
