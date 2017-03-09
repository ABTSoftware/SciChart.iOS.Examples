//
//  OnboardingViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "OnboardingViewController.h"

@implementation OnboardingViewController {
    
    NSMutableArray * viewControllers;
    int viewsQuantity;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    viewControllers = [self getviewControllers];
    viewsQuantity = 3;
    
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
    [vcFirstPage setTitle: @"SciChart"];
    [vcFirstPage setDescription: @"The best high performance charts. Incredible iOS charts engineered for speed, amazing flexibility. Real-time, interactive iOS Charts with blazing Objective-C / OpenGL performance comes as standard."];
    [vcFirstPage setImage:[UIImage imageNamed:@"StartPage"]];
    
    [pages addObject:vcFirstPage];
    
    OnboardingPageViewController * vcSecondPage = [[OnboardingPageViewController alloc]init];
    [vcSecondPage setTitle: @"Examples"];
    [vcSecondPage setDescription: @"Find the example you're looking for"];
    [vcSecondPage setImage:[UIImage imageNamed:@"MainView"]];
    
    [pages addObject:vcSecondPage];
    
    OnboardingPageViewController * vcThirdPage = [[OnboardingPageViewController alloc]init];
    [vcThirdPage setTitle: @"Features and Settings"];
    [vcThirdPage setDescription: @"Play around with particular example. Configure modifiers, share example or take a look at example's code."];
    [vcThirdPage setImage:[UIImage imageNamed:@"SideBarMenu"]];
    
    [pages addObject:vcThirdPage];
   
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
    
    if (index == viewsQuantity-1) {
        [self pv_shakeSkipButton];
        return nil;
    }
    index++;
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
