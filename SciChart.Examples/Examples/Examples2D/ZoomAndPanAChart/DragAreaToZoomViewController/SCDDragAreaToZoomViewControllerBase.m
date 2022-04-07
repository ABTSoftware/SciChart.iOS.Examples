//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDDragAreaToZoomViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDDragAreaToZoomViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDSwitchItem.h"
#import "SCDConstants.h"

@implementation SCDDragAreaToZoomViewControllerBase {
    SCDSettingsPresenter *_settingsPresenter;
}

@synthesize useAnimation = _useAnimation;
@synthesize isXAxisOnly = _isXAxisOnly;
@synthesize zoomExtentsY = _zoomExtentsY;

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)commonInit {
    _useAnimation = YES;
    _isXAxisOnly = YES;
    _zoomExtentsY = NO;
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;

    SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"RubberBand settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openRubberBandSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
    
    return @[settingsToolbar];
}

- (void)p_SCD_openRubberBandSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createRubberBandSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createRubberBandSettingsItems {
    __weak typeof(self) wSelf = self;
    return @[
        [[SCDSwitchItem alloc] initWithTitle:@"Zoom X-Axis Only" isSelected:_isXAxisOnly andAction:^(BOOL isXAxisOnly) {
            [wSelf p_SCD_onIsXAxisOnlyChange:isXAxisOnly];
        }],
        [[SCDSwitchItem alloc] initWithTitle:@"Zoom Extents Y-Axis" isSelected:_zoomExtentsY andAction:^(BOOL zoomExtentsY) {
            [wSelf p_SCD_onZoomExtentsYChange:zoomExtentsY];
        }],
        [[SCDSwitchItem alloc] initWithTitle:@"Use Animation" isSelected:_useAnimation andAction:^(BOOL useAnimation) {
            [wSelf p_SCD_onUseAnimationChange:useAnimation];
        }],
    ];
}

- (void)p_SCD_onUseAnimationChange:(BOOL)useAnimation {
    _useAnimation = useAnimation;
    _rubberBand.isAnimated = _useAnimation;
}

- (void)p_SCD_onIsXAxisOnlyChange:(BOOL)isXAxisOnly {
    _isXAxisOnly = isXAxisOnly;
    _rubberBand.isXAxisOnly = _isXAxisOnly;
}

- (void)p_SCD_onZoomExtentsYChange:(BOOL)zoomExtentsY {
    _zoomExtentsY = zoomExtentsY;
    _rubberBand.zoomExtentsY = _zoomExtentsY;
}

@end
