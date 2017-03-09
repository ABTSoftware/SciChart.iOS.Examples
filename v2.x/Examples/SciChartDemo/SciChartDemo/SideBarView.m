//
//  SideBarViewController.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 04.05.16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "SideBarView.h"
#import "ShowSourceCodeViewController.h"
#import "ExampleUIViewController.h"

@implementation SideBarView

@synthesize ExampleUIView;

- (IBAction)ShowExampleSettings:(id)sender {
    [((ExampleUIViewController*)[self.superview nextResponder]) performSegueWithIdentifier:@"ExampleSettingsSegue" sender:self];
}


@end
