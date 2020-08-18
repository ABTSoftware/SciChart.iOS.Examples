//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDDragAxisToScaleChartViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDDragAxisToScaleChartViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDConstants.h"

@implementation SCDDragAxisToScaleChartViewControllerBase {
    SCDSettingsPresenter *_settingsPresenter;
}

@synthesize xAxisDragModifier = _xAxisDragModifier;
@synthesize yAxisDragModifier = _yAxisDragModifier;
@synthesize selectedDragMode = _selectedDragMode;
@synthesize selectedDirection = _selectedDirection;

- (Class)associatedType { return SCIChartSurface.class; }

- (void)commonInit {
    _selectedDragMode = SCIAxisDragMode_Scale;
    _selectedDirection = SCIDirection2D_XyDirection;
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
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createLegendModifierSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createLegendModifierSettingsItems {
    __weak typeof(self) wSelf = self;
    SCDToolbarPopupItem *dragModePopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:@[@"Scale", @"Pan"] selectedIndex:_selectedDragMode andAction:^(NSUInteger selectedDragMode) {
        [wSelf p_SCD_onDragModeChange:selectedDragMode];
    }];
    SCDToolbarPopupItem *directionPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:@[@"XDirection", @"YDirection", @"XyDirection"] selectedIndex:_selectedDirection andAction:^(NSUInteger selectedDirection) {
        [wSelf p_SCD_onDirectionChange:selectedDirection];
    }];
    
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Axis drag mode:" item:dragModePopupItem],
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Direction:" item:directionPopupItem]
    ];
}

- (void)p_SCD_onDragModeChange:(SCIAxisDragMode)selectedDragMode {
    _selectedDragMode = selectedDragMode;
    _xAxisDragModifier.dragMode = _selectedDragMode;
    _yAxisDragModifier.dragMode = _selectedDragMode;
}

- (void)p_SCD_onDirectionChange:(SCIDirection2D)selectedDirection {
    _selectedDirection = selectedDirection;
    switch (_selectedDirection) {
        case SCIDirection2D_XDirection:
            _xAxisDragModifier.isEnabled = YES;
            _yAxisDragModifier.isEnabled = NO;
            break;
        case SCIDirection2D_YDirection:
            _xAxisDragModifier.isEnabled = NO;
            _yAxisDragModifier.isEnabled = YES;
            break;
        case SCIDirection2D_XyDirection:
            _xAxisDragModifier.isEnabled = YES;
            _yAxisDragModifier.isEnabled = YES;
            break;
        default:
            break;
    }
}

@end
