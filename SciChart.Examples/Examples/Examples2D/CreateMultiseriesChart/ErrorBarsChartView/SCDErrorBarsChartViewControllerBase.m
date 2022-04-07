//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDErrorBarsChartViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDErrorBarsChartViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDConstants.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDToolbarSliderItem.h"

@implementation SCDErrorBarsChartViewControllerBase {
    SCDSettingsPresenter *_settingsPresenter;
}

@synthesize errorBars0 = _errorBars0;
@synthesize errorBars1 = _errorBars1;
@synthesize dataPointWidth = _dataPointWidth;
@synthesize strokeThickness = _strokeThickness;

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)commonInit {
    _dataPointWidth = 0.5;
    _strokeThickness = 1.0;
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;
    SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"ErrorBars settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
    
    return @[settingsToolbar];
}

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    SCDToolbarSliderItem *dataPointWidthItem = [[SCDToolbarSliderItem alloc] initWithSliderValue:_dataPointWidth maxValue:1.0 andAction:^(double sliderValue) {
        [wSelf p_SCD_onDataPointWidthChange:sliderValue];
    }];
    SCDToolbarSliderItem *strokeThicknessItem = [[SCDToolbarSliderItem alloc] initWithSliderValue:_strokeThickness maxValue:2.0 andAction:^(double sliderValue) {
        [wSelf p_SCD_onStrokeThicknessChange:sliderValue];
    }];

    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Change ErrorBars dataPointWidth" item:dataPointWidthItem iOS_orientation:SCILayoutConstraintAxisVertical],
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Change ErrorBars strokeThickness" item:strokeThicknessItem iOS_orientation:SCILayoutConstraintAxisVertical]
    ];
}

- (void)p_SCD_onDataPointWidthChange:(double)sliderValue {
    _dataPointWidth = sliderValue;
    self.errorBars0.dataPointWidth = _dataPointWidth;
    self.errorBars1.dataPointWidth = _dataPointWidth;
}

- (void)p_SCD_onStrokeThicknessChange:(double)sliderValue {
    _strokeThickness = (float)sliderValue;
    _errorBars0.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:_errorBars0.strokeStyle.colorCode thickness:_strokeThickness];
    _errorBars1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:_errorBars1.strokeStyle.colorCode thickness:_strokeThickness];
}

@end
