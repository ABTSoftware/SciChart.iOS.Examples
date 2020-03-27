//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDAppLaunchCoordinator.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDAppLaunchCoordinator.h"
#import "SCDExamplesDataSource.h"
#import "SCDConstants.h"
#import "SCDExamplesListViewController.h"
#import "SCDMainMenuViewController.h"
#import "SCDMenuItem.h"
#import <SciChart/UIColor+Util.h>

@implementation SCDAppLaunchCoordinator {
    UIWindow *_keyWindow;
    SCDMainMenuViewController *_mainMenuViewController;
    
    SCDExamplesDataSource *_examples2DDataSource;
    SCDExamplesDataSource *_examples3DDataSource;
    SCDExamplesDataSource *_featuredAppsDataSource;
    SCDExamplesDataSource *_sandboxDataSource;
    
    BOOL _showSandbox;
}

- (SCDExamplesDataSource *)examples3DDataSource {
    if (_examples3DDataSource == nil) {
        _examples3DDataSource = [[SCDExamplesDataSource alloc] initWithPlistFileName:Examples3DPlistFileName];
    }
    return _examples3DDataSource;
}

- (SCDExamplesDataSource *)examples2DDataSource {
    if (_examples2DDataSource == nil) {
        _examples2DDataSource = [[SCDExamplesDataSource alloc] initWithPlistFileName:Examples2DPlistFileName];
    }
    return _examples2DDataSource;
}

- (SCDExamplesDataSource *)featuredAppsDataSource {
    if (_featuredAppsDataSource == nil) {
        _featuredAppsDataSource = [[SCDExamplesDataSource alloc] initWithPlistFileName:FeaturedAppsPlistName];
    }
    return _featuredAppsDataSource;
}

- (SCDExamplesDataSource *)sandboxDataSource {
    if (_sandboxDataSource == nil) {
        _sandboxDataSource = [[SCDExamplesDataSource alloc] initWithPlistFileName:SandboxPlistNameName];
    }
    return _sandboxDataSource;
}

- (instancetype)initWithWindow:(UIWindow *)window {
    self = [super init];
    if (self) {
        _keyWindow = window;
        
        _showSandbox = NO;
    }
    return self;
}

- (void)start {
    if ([NSUserDefaults.standardUserDefaults objectForKey:kFirstTimeLaunching]) {
        _keyWindow.rootViewController = self.mainMenuViewController;
    } else {
        _keyWindow.rootViewController = self.mainMenuViewController;
        // TODO: Uncommend onbording logic after side menu is refactored and ready to use
        // rootNavigationController = [mainStoryBoard instantiateViewControllerWithIdentifier:kFirstTimeNavController];
        [NSUserDefaults.standardUserDefaults setObject:@(YES) forKey:kFirstTimeLaunching];
        [NSUserDefaults.standardUserDefaults synchronize];
    }
}

- (SCDMainMenuViewController *)mainMenuViewController {
    if (_mainMenuViewController == nil) {
        NSMutableArray *items = [[NSMutableArray alloc] initWithArray:@[
            [[SCDMenuItem alloc] initWithTitle:@"2D CHARTS" subtitle:@"SELECTION OF 2D CHARTS" iconImageName:@"chart.2d" andAction:^{
                [self p_SCD_navigateToExamplesWithDataSource:self.examples2DDataSource andTitle:@"2D CHARTS"];
            }],
            [[SCDMenuItem alloc] initWithTitle:@"3D CHARTS" subtitle:@"SELECTION OF 3D CHARTS" iconImageName:@"chart.3d" andAction:^{
                [self p_SCD_navigateToExamplesWithDataSource:self.examples3DDataSource andTitle:@"3D CHARTS"];
            }],
            [[SCDMenuItem alloc] initWithTitle:@"FEATURED APPS" subtitle:@"SELECTION OF FEATURED APPS" iconImageName:@"chart.featured" andAction:^{
                [self p_SCD_navigateToExamplesWithDataSource:self.featuredAppsDataSource andTitle:@"FEATURED APPS"];
            }]
        ]];
        
        if (_showSandbox) {
            [items insertObject:[[SCDMenuItem alloc] initWithTitle:@"SANDBOX" subtitle:@"SELECTION OF SANDBOX" iconImageName:@"chart.2d" andAction:^{
                [self p_SCD_navigateToExamplesWithDataSource:self.sandboxDataSource andTitle:@"SANDBOX"];
            }] atIndex:0];
        }
        
        _mainMenuViewController = [[SCDMainMenuViewController alloc] initWitItems:items];
    }
    return _mainMenuViewController;
}

- (void)p_SCD_navigateToExamplesWithDataSource:(SCDExamplesDataSource *)source andTitle:(NSString *)title {
    SCDExamplesListViewController *examplesList = [SCDExamplesListViewController new];
    examplesList.dataSource = source;
    examplesList.title = title;
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:examplesList];
    navigationController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    
    if (@available(iOS 13.0, *)) {
        UINavigationBarAppearance *appearence = [UINavigationBarAppearance new];
        appearence.backgroundColor = [UIColor colorNamed:@"color.primary.green"];
        appearence.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColor.whiteColor, NSForegroundColorAttributeName, nil];
        
        UINavigationBar.appearance.tintColor = UIColor.whiteColor;
        UINavigationBar.appearance.barTintColor = UIColor.whiteColor;
        UINavigationBar.appearance.standardAppearance = appearence;
        UINavigationBar.appearance.compactAppearance = appearence;
        UINavigationBar.appearance.scrollEdgeAppearance = appearence;
    } else {
        UINavigationBar.appearance.tintColor = UIColor.whiteColor;
        UINavigationBar.appearance.barTintColor = [UIColor colorNamed:@"color.primary.green"];
        UINavigationBar.appearance.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColor.whiteColor, NSForegroundColorAttributeName, nil];
        UINavigationBar.appearance.translucent = NO;
    }
    
    CATransition *transition = [CATransition new];
    transition.duration = 0.25;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [_keyWindow.layer addAnimation:transition forKey:kCATransition];
    
    [_mainMenuViewController presentViewController:navigationController animated:NO completion:nil];
}

@end
