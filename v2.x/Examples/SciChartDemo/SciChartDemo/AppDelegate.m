//
//  AppDelegate.m
//  SciChartDemo
//
//  Created by Admin on 09.07.15.
//  Copyright (c) 2016 SciChart Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "SCDConstants.h"
//@BEGINDELETE
#import <SciChart/SciChart.h>
//@ENDDELETE

static NSString *kFirstTimeNavController = @"FirstTimeNavController";
static NSString *kMainNavController = @"MainNavController";
static NSString *kMainStoryBoard = @"Main";

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //@BEGINDELETE
//    [SCIChartSurface setLicenseContract:@""
//     "<LicenseContract>"
//     "<Customer>SCI-TEST</Customer>"
//     "<OrderId>testing-trial</OrderId>"
//     "<LicenseCount>1</LicenseCount>"
//     "<IsTrialLicense>true</IsTrialLicense>"
//     "<SupportExpires>10/01/2016 00:00:00</SupportExpires>"
//     "<ProductCode>SC-IOS-2D-ENTERPRISE-SRC</ProductCode>"
//     "<KeyCode>2c018432bef213c947e047169c6f33998d9e670ddb679958be76cd23a88ff33d7bd23c0230a9ba12f6834a4a2b7a87ef0cb3ba41de20ab0437a3d5ab86787056820a2e324426561f82317d7dde614e3cc779422ffcb92eb328ea03d49b0aa763bcb81bccd34a28d2760cd299a2af1becedc7bdfca9a845475817cfb14a3157c6f0f12d4cfe3008fa24e780f77f3185b39681d2da95121c90ca7900e4e7848da3fe8532865027</KeyCode>"
//     "</LicenseContract>"];
    //@ENDDELETE
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
