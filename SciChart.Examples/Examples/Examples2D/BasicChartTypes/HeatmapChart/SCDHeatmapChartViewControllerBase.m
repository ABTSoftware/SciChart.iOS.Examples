//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSingleChartWithHeatmapViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDHeatmapChartViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDConstants.h"

@implementation SCDHeatmapChartViewControllerBase {
    SCDSettingsPresenter *_settingsPresenter;
    NSUInteger _selectedOrientationIndex;
    NSArray<NSString *> *_orientations;
    
    NSLayoutConstraint *_leadingConstraint;
    NSLayoutConstraint *_trailingConstraint;
    NSLayoutConstraint *_topConstraint;
    NSLayoutConstraint *_bottomConstraint;
}

- (Class)associatedType { return SCIChartSurface.class; }

- (void)commonInit {
    _orientations = @[@"Horizontal", @"Vertical"];
    _selectedOrientationIndex = 1;
}

 - (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
     __weak typeof(self) wSelf = self;
     
     SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
         [[SCDToolbarItem alloc] initWithTitle:@"ColourMap settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
     ]];
     settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
     
     return @[settingsToolbar];
 }

- (void)viewDidLoad {
    SCIChartHeatmapColourMap *colourMap = [SCIChartHeatmapColourMap new];
    colourMap.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.surface.renderableSeriesArea.view addSubview:colourMap];
    
    _heatmapColourMap = colourMap;
    
    [self p_SCD_createConstraints];
    [self p_SCD_updateConstraints];
    
    [super viewDidLoad];
}

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    SCDToolbarPopupItem *orientationPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_orientations selectedIndex:_selectedOrientationIndex andAction:^(NSUInteger selectedIndex) {
        [wSelf p_SCD_onSelectedOrientationChange:selectedIndex];
    }];
    
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Colour map orientation:" item:orientationPopupItem iOS_orientation:SCILayoutConstraintAxisVertical]
    ];
}

- (void)p_SCD_onSelectedOrientationChange:(NSUInteger)index {
    _selectedOrientationIndex = index;
    self.heatmapColourMap.orientation = (SCIOrientation)_selectedOrientationIndex;
    [self p_SCD_updateConstraints];
}

- (void)p_SCD_createConstraints {
    SCIView *superview = self.surface.renderableSeriesArea.view;
    SCIChartHeatmapColourMap *colourMap = self.heatmapColourMap;
    
    _leadingConstraint = [colourMap.leadingAnchor constraintLessThanOrEqualToAnchor:superview.leadingAnchor constant:8];
    _trailingConstraint = [colourMap.trailingAnchor constraintGreaterThanOrEqualToAnchor:superview.trailingAnchor constant:-8];
    _topConstraint = [colourMap.topAnchor constraintLessThanOrEqualToAnchor:superview.topAnchor constant:8];
    _bottomConstraint = [colourMap.bottomAnchor constraintGreaterThanOrEqualToAnchor:superview.bottomAnchor constant:-8];
}

- (void)p_SCD_updateConstraints {
    _leadingConstraint.active = YES;
    _bottomConstraint.active = YES;
    _trailingConstraint.active = self.heatmapColourMap.orientation == SCIOrientationHorizontal;
    _topConstraint.active = self.heatmapColourMap.orientation == SCIOrientationVertical;
}

@end
