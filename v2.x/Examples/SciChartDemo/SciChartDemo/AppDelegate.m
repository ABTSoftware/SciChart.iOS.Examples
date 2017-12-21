//
//  AppDelegate.m
//  SciChartDemo
//
//  Created by Admin on 09.07.15.
//  Copyright (c) 2016 SciChart Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "SCDConstants.h"
#import <CommonCrypto/CommonCrypto.h>

static NSString *kFirstTimeNavController = @"FirstTimeNavController";
static NSString *kMainNavController = @"MainNavController";
static NSString *kMainStoryBoard = @"Main";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 5, 0);

    UIImage *myImage = [UIImage imageNamed:@"Home"];
    UIImage *backButtonImage = [myImage imageWithAlignmentRectInsets:insets];

    [[UINavigationBar appearance] setBackIndicatorImage:backButtonImage];
    [[UINavigationBar appearance] setBackIndicatorTransitionMaskImage:backButtonImage];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.333 green:0.761 blue:0.357 alpha:1]];
    [self setShouldRotate:FALSE];

    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];

    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:kMainStoryBoard bundle:nil];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:kFirstTimeLaunching]) {
        UINavigationController *navController = [mainStoryBoard instantiateViewControllerWithIdentifier:kMainNavController];
        self.window.rootViewController = navController;
    }
    else {
        UINavigationController *navController = [mainStoryBoard instantiateViewControllerWithIdentifier:kFirstTimeNavController];
        self.window.rootViewController = navController;
    }

    
    return YES;
}

-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.shouldRotate)
        return UIInterfaceOrientationMaskAllButUpsideDown;
    else
        return UIInterfaceOrientationMaskPortrait;
}

-(void)setShouldRotate:(BOOL)shouldRotate {
    _shouldRotate = YES;
    //    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    //    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
