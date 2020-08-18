//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDLegendChartViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDLegendChartViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDSwitchItem.h"
#import "SCDConstants.h"

@implementation SCDLegendChartViewControllerBase {
    NSArray<NSString *> *_sourceModesNames;
    SCDSettingsPresenter *_settingsPresenter;
}

@synthesize orientation = _orientation;
@synthesize showLegend = _showLegend;
@synthesize showCheckBoxes = _showCheckBoxes;
@synthesize showSeriesMarkers = _showSeriesMarkers;
@synthesize sourceMode = _sourceMode;
@synthesize legendModifier = _legendModifier;

- (Class)associatedType { return SCIChartSurface.class; }

- (void)commonInit {
    _orientation = SCIOrientationVertical;
    _showLegend = YES;
    _showCheckBoxes = YES;
    _showSeriesMarkers = YES;
    _sourceMode = SCISourceMode_AllSeries;
    _sourceModesNames = @[
        @"AllSeries",
        @"AllVisibleSeries",
        @"SelectedSeries",
        @"UnselectedSeries"
    ];
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;
    
    SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"Legend settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
    
    return @[settingsToolbar];
}

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    SCDToolbarPopupItem *orientationPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:@[@"Horizontal", @"Vertical"] selectedIndex:_orientation andAction:^(NSUInteger selectedIndex) {
        [wSelf p_SCD_onOrientationChange:(SCIOrientation)selectedIndex];
    }];
    SCDToolbarPopupItem *sourceModePopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_sourceModesNames selectedIndex:_sourceMode andAction:^(NSUInteger selectedIndex) {
        [wSelf p_SCD_onSourceModeChange:selectedIndex];
    }];
    
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Legend orientation" item:orientationPopupItem],
        [[SCDSwitchItem alloc] initWithTitle:@"Show legend" isSelected:_showLegend andAction:^(BOOL showLegend) {
            [wSelf p_SCD_onShowLegendChange:showLegend];
        }],
        [[SCDSwitchItem alloc] initWithTitle:@"Show checkboxes" isSelected:_showCheckBoxes andAction:^(BOOL showCheckBoxes) {
            [wSelf p_SCD_onShowCheckboxesChange:showCheckBoxes];
        }],
        [[SCDSwitchItem alloc] initWithTitle:@"Show series markers" isSelected:_showSeriesMarkers andAction:^(BOOL showSeriesMarkers) {
            [wSelf p_SCD_onShowSeriesMarkersChange:showSeriesMarkers];
        }],
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Data Source" item:sourceModePopupItem]
    ];
}

- (void)p_SCD_onOrientationChange:(SCIOrientation)orientation {
    _orientation = orientation;
    _legendModifier.orientation = _orientation == 0 ? SCIOrientationHorizontal : SCIOrientationVertical;
}

- (void)p_SCD_onShowLegendChange:(BOOL)showLegend {
    _showLegend = showLegend;
    _legendModifier.showLegend = _showLegend;
}

- (void)p_SCD_onShowCheckboxesChange:(BOOL)showCheckBoxes {
    _showCheckBoxes = showCheckBoxes;
    _legendModifier.showCheckBoxes = _showCheckBoxes;
}

- (void)p_SCD_onShowSeriesMarkersChange:(BOOL)showSeriesMarkers {
    _showSeriesMarkers = showSeriesMarkers;
    _legendModifier.showSeriesMarkers = _showSeriesMarkers;
}

- (void)p_SCD_onSourceModeChange:(SCISourceMode)sourceMode {
    _sourceMode = sourceMode;
    _legendModifier.sourceMode = _sourceMode;
}

@end
