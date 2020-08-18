//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDOscilloscopeChartViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDOscilloscopeChartViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDSwitchItem.h"
#import "SCDConstants.h"

@implementation SCDOscilloscopeChartViewControllerBase {
    BOOL _isDigitalLine;
    NSArray<NSString *> *_seriesNames;
    NSInteger _initialSeriesIndex;
    NSArray<SCIAction> *_actions;
    SCDSettingsPresenter *_settingsPresenter;
}

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar {
    return NO;
}

- (void)commonInit {
    __weak typeof(self) wSelf = self;
    
    _seriesNames = @[@"Fourier", @"Lisajous"];
    _actions = @[^{
        [wSelf onFourierSeriesSelected];
    }, ^{
        [wSelf onLissajousSelected];
    }];
    _isDigitalLine = NO;
    _initialSeriesIndex = 0;
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;
    
    SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"Oscilloscope settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
    
    return @[settingsToolbar];
}

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    SCDToolbarPopupItem *dataSourcePopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_seriesNames selectedIndex:_initialSeriesIndex andAction:^(NSUInteger selectedIndex) {
        self->_actions[selectedIndex]();
    }];
        
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Data source:" item:dataSourcePopupItem],
        [[SCDSwitchItem alloc] initWithTitle:@"Is step line" isSelected:_isDigitalLine andAction:^(BOOL isYLogAxis) {
            [wSelf p_SCD_changeIsDigital];
        }]
    ];
}

- (void)p_SCD_changeIsDigital {
    _isDigitalLine = !_isDigitalLine;
    
    [self onIsDigitalLineChanged:_isDigitalLine];
}

- (void)onFourierSeriesSelected { }
- (void)onLissajousSelected { }
- (void)onIsDigitalLineChanged:(BOOL)isDigitalLine { }

@end
