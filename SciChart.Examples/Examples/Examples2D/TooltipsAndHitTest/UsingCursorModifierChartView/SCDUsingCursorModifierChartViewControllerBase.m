//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDUsingCursorModifierChartViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDUsingCursorModifierChartViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDSwitchItem.h"
#import "SCDConstants.h"

@implementation SCDUsingCursorModifierChartViewControllerBase {
    NSArray<NSString *> *_sourceModesNames;
    SCDSettingsPresenter *_settingsPresenter;
}

@synthesize cursorModifier = _cursorModifier;
@synthesize sourceMode = _sourceMode;
@synthesize showTooltip = _showTooltip;
@synthesize showAxisLabel = _showAxisLabel;

- (Class)associatedType { return SCIChartSurface.class; }

- (void)commonInit {
    _sourceMode = SCISourceMode_AllVisibleSeries;
    _showTooltip = YES;
    _showAxisLabel = YES;
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
        [[SCDToolbarItem alloc] initWithTitle:@"UsingCursorModifier settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
    
    return @[settingsToolbar];
}

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    SCDToolbarPopupItem *sourceModePopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_sourceModesNames selectedIndex:_sourceMode andAction:^(NSUInteger selectedIndex) {
        [wSelf p_SCD_onSourceModeChange:selectedIndex];
    }];
    
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Data Source:" item:sourceModePopupItem],
        [[SCDSwitchItem alloc] initWithTitle:@"Show tooltips" isSelected:_showTooltip andAction:^(BOOL showTooltip) {
            [wSelf p_SCD_onShowTooltipChange:showTooltip];
        }],
        [[SCDSwitchItem alloc] initWithTitle:@"Show axis labels" isSelected:_showAxisLabel andAction:^(BOOL showAxisLabel) {
            [wSelf p_SCD_onShowAxisLabelChange:showAxisLabel];
        }]
    ];
}

- (void)p_SCD_onSourceModeChange:(SCISourceMode)sourceMode {
    _sourceMode = sourceMode;
    _cursorModifier.sourceMode = _sourceMode;
}

- (void)p_SCD_onShowTooltipChange:(BOOL)showTooltip {
    _showTooltip = showTooltip;
    _cursorModifier.showTooltip = _showTooltip;
}

- (void)p_SCD_onShowAxisLabelChange:(BOOL)showAxisLabel {
    _showAxisLabel = showAxisLabel;
    _cursorModifier.showAxisLabel = _showAxisLabel;
}

@end
