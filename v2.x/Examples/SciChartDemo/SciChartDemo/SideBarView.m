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

@implementation SideBarView {
    __weak IBOutlet UIImageView *_settingsImageView;
    __weak IBOutlet UIButton *_exampleSettingsButton;
}

@synthesize ExampleUIView;

- (IBAction)ShowExampleSettings:(id)sender {
    if (_settingsClickHandler) {
        _settingsClickHandler();
    }
}

- (void)showSettingsExampleOption:(BOOL)isShow {
    _settingsImageView.hidden = !isShow;
    _exampleSettingsButton.hidden = !isShow;
}

@end
