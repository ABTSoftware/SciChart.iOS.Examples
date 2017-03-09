//
//  ExampleSettingsTabBarController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/24/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ExampleSettingsTabBarController.h"
#import "ModifierTableViewController.h"
#import "ModifierTableViewController+InteractionWithExampleData.h"

@implementation ExampleSettingsTabBarController

@synthesize Surface;

-(void) viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
    ModifierTableViewController * vc = self.viewControllers[0];
    vc.sciSurface = Surface;
}

@end
