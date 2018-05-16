//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SideBarView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SideBarView.h"
#import "ShowSourceCodeViewController.h"
#import "ExamplesViewController.h"

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
