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
    IBOutlet UIImageView *ScreenImage;
}

@property (strong, nonatomic) NSString *Title;
@property (strong, nonatomic) NSString *Description;
@property (strong, nonatomic) UIImage *Image;

@property (strong, nonatomic) IBOutlet UILabel *TitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *DescriptionLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ScreenImage;

- (instancetype) initWithTitle:(NSString*) title
                   Description:(NSString*) description
                         Image:(UIImage*) image;

@end
