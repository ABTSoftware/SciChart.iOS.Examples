//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2024. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDCustomModifierViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDCustomModifierViewController.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDSwitchItem.h"
#import "SCDConstants.h"
#import "SCDToolbarSliderItem.h"
#import "SCISegmentedControl.h"

@interface SCDCustomModifierViewController()

@end

@implementation SCDCustomModifierViewController {
    SCDSettingsPresenter *_settingsPresenter;
    
    NSArray<NSString *> *_contentModeTitle;
    SCISegmentedControl *drawModeSegmentControl;
}

@synthesize drawMode = _drawMode;

- (Class)associatedType { return SCIChartSurface.class; }

- (void)commonInit {
    _contentModeTitle = @[@"Box", @"Line", @"Marker"];
    [self createView];
}

-(void)createView {
    drawModeSegmentControl = [self p_SCD_createSegmentedControlWithItems:_contentModeTitle];
    drawModeSegmentControl.selectedSegment = 0;
    _drawMode = DrawMode_Box;
    [self.view addSubview:drawModeSegmentControl];
    
    [drawModeSegmentControl addTarget:self valueChangeAction:@selector(segmentValueChanged:)];
    
    drawModeSegmentControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
        [drawModeSegmentControl.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor constant:10],
        [drawModeSegmentControl.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor constant:-50],
        [drawModeSegmentControl.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor constant:10]
    ]];
}


- (SCISegmentedControl *)p_SCD_createSegmentedControlWithItems:(NSArray<NSString *> *)items {
    SCISegmentedControl *segmentedControl = [[SCISegmentedControl alloc] initWithItems:items];
#if TARGET_OS_IOS
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: SCIColor.whiteColor} forState:UIControlStateNormal];
    if (@available(iOS 13.0, *)) {
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: SCIColor.labelColor} forState:UIControlStateSelected];
    } else {
        [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName: SCIColor.blackColor} forState:UIControlStateSelected];
    }
#endif
    return segmentedControl;
}

- (IBAction)segmentValueChanged:(SCISegmentedControl *)sender {
    DrawMode selectedMode = _drawMode;
    switch (sender.selectedSegment) {
        case 0:
            selectedMode = DrawMode_Box;
            break;
        case 1:
            selectedMode = DrawMode_Line;
            break;
        case 2:
            selectedMode = DrawMode_Markers;
            break;
        default:
            break;
    }
    [self didDragModeChange:selectedMode];
}

- (void)didDragModeChange:(DrawMode)drawMode {
    self.drawMode = drawMode;
}

@end
