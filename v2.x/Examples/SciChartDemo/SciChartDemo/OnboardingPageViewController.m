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
@synthesize ImageButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.TitleLabel.text = self.Title;
    self.DescriptionLabel.text = self.Description;
    [self.ImageButton setBackgroundColor:[UIColor clearColor]];
    [self.ImageButton setOpaque:NO];
    [self.ImageButton setBackgroundImage: self.Image forState: UIControlStateNormal];
}

- (IBAction)handleButtonClick:(id)sender{
    
    if ([_ImageClickUrl length] != 0){
        // Open the image click URL in a browser or better WebView
        NSLog(@"Clicked an image!");
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_ImageClickUrl]];
    }
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
