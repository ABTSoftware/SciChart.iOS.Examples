//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDPanAndZoomChartViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDPanAndZoomChartViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDSwitchItem.h"
#import "SCDConstants.h"

@implementation SCDPanAndZoomChartViewControllerBase {
    SCDSettingsPresenter *_settingsPresenter;
}

@synthesize zoomPanModifier = _zoomPanModifier;
@synthesize allowsScrollOnAxisDrag = _allowsScrollOnAxisDrag;

- (Class)associatedType { return SCIChartSurface.class; }

- (void)commonInit {
    _allowsScrollOnAxisDrag = NO;
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;
    
    SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"PanAndZoomModifier settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
    
    return @[settingsToolbar];
}

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    return @[
        [[SCDSwitchItem alloc] initWithTitle:@"Allow pan on axis" isSelected:_allowsScrollOnAxisDrag andAction:^(BOOL allowsScroll) {
            [wSelf p_SCD_onAllowsScrollOnAxisDragLabelChange:allowsScroll];
        }]
    ];
}

- (void)p_SCD_onAllowsScrollOnAxisDragLabelChange:(BOOL)allowsScroll {
    _allowsScrollOnAxisDrag = allowsScroll;
    _zoomPanModifier.allowsGestureOnAxis = _allowsScrollOnAxisDrag;
}

@end
