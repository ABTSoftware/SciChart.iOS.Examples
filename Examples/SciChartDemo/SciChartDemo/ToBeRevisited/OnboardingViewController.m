//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// OnboardingViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "OnboardingViewController.h"

@implementation OnboardingViewController {
    
    NSMutableArray * viewControllers;
    NSUInteger viewsQuantity;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewControllers = [self getviewControllers];
    viewsQuantity = [viewControllers count];
    
    self.pageViewController = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageViewController.dataSource = self;
    
    [self.pageViewController.view setFrame:[self.view bounds]];
    [self.pageViewController setViewControllers:[[NSArray alloc]initWithObjects:[viewControllers objectAtIndex:0],nil] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageViewController];
    [[self view] addSubview:[self.pageViewController view]];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    UIButton *skipButton = [[UIButton alloc] init];
    [skipButton setTitle:@"Skip" forState:UIControlStateNormal];
    [skipButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18.f]];
    [skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [skipButton addTarget:self action:@selector(skipOnNoarding) forControlEvents:UIControlEventTouchUpInside];
    [skipButton sizeToFit];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:skipButton];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    

    
}

- (void) skipOnNoarding {
    [self performSegueWithIdentifier:@"GoToMainPageSegue" sender:nil];
}


- (NSMutableArray*) getviewControllers{
    NSMutableArray * pages = [[NSMutableArray alloc]init];
    
    OnboardingPageViewController * vcFirstPage = [[OnboardingPageViewController alloc]init];
    
    [vcFirstPage setTitle: @"What is SciChart?"];
    [vcFirstPage setDescription: @"SciChart is a High Performance, Native iOS Chart Library for developers.\n\nCreate next-gen scientific, financial & medical apps for iPad and iPhone in Objective-C and Swift with our High Performance Realtime Charts."];
    [vcFirstPage setImage:[UIImage imageNamed:@"StartPage"]];
    [vcFirstPage setImageClickUrl: @"https://youtu.be/rfJsWVm4Epc"];
    
    [pages addObject:vcFirstPage];
    
    OnboardingPageViewController * vcSecondPage = [[OnboardingPageViewController alloc]init];
    [vcSecondPage setTitle: @"Examples"];
    [vcSecondPage setDescription: @"Find the example you're looking for by searching or scrolling. "];
    [vcSecondPage setImage:[UIImage imageNamed:@"MainView"]];
    
    [pages addObject:vcSecondPage];
    
    OnboardingPageViewController * vcThirdPage = [[OnboardingPageViewController alloc]init];
    [vcThirdPage setTitle: @"Features and Settings"];
    [vcThirdPage setDescription: @"Play around with particular example. Configure modifiers, share example as *.xcodeproj or take a look at examples code."];
    [vcThirdPage setImage:[UIImage imageNamed:@"SideBarMenu"]];
    
    [pages addObject:vcThirdPage];
    
    // Dummy page, doesnt show! For advancing to main app
    OnboardingPageViewController * vcDummyPage = [[OnboardingPageViewController alloc]init];
    [pages addObject:vcDummyPage];
   
    return pages;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [viewControllers indexOfObject:viewController];
    
    if (index == 0) {
        
        return nil;
    }
    
    index--;
    
    return [viewControllers objectAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [viewControllers indexOfObject:viewController];
    
    index++;
    
    // Shake button to draw attention to it
    [self pv_shakeSkipButton];
    
    // Auto proceed to homepage on last scroll (last page is dummy page)
    if (index > viewsQuantity-1) {
        [self performSegueWithIdentifier:@"GoToMainPageSegue" sender:nil];
        return nil;
    }
    
    return [viewControllers objectAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return viewsQuantity;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

- (void)pv_shakeSkipButton {
    UIView *lockView = self.navigationItem.rightBarButtonItem.customView;
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration = 0.6;
    animation.values = @[ @(-20), @(20), @(-20), @(20), @(-10), @(10), @(-5), @(5), @(0) ];
    [lockView.layer addAnimation:animation forKey:@"shake"];
}

@end
