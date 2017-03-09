//
//  OnboardingPageViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/21/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "OnboardingPageViewController.h"

@implementation OnboardingPageViewController

@synthesize DescriptionLabel;
@synthesize TitleLabel;
@synthesize ScreenImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.TitleLabel.text = self.Title;
    self.DescriptionLabel.text = self.Description;
    self.ScreenImage.image = self.Image;

}

- (instancetype) initWithTitle:(NSString *)title Description:(NSString *)description Image:(UIImage *)image{
    if((self = [super init])){
        self.Title = title;
        self.Description = description;
        self.Image = image;
        
        self.TitleLabel = [[UILabel alloc]init];
        self.DescriptionLabel = [[UILabel alloc]init];
        self.ScreenImage = [[UIImageView alloc]init];
        
        self.TitleLabel.text = self.Title;
        self.DescriptionLabel.text = self.Description;
        self.ScreenImage.image = self.Image;
    }
    return self;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
