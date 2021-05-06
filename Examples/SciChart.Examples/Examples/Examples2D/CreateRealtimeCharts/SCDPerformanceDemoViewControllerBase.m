//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDPerformanceDemoViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDPerformanceDemoViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDConstants.h"

@implementation SCDPerformanceDemoViewControllerBase {
    SCDSettingsPresenter *_settingsPresenter;
    
    NSArray<NSString *> *_seriesTypes;
    NSArray<NSString *> *_strokeThicknessValues;
    NSArray<NSString *> *_speedValues;
    NSArray<NSString *> *_resamplingModes;

    NSUInteger _selectedSeriesTypeIndex;
    NSUInteger _selectedStrokeThicknessIndex;
    NSUInteger _selectedSpeedValueIndex;
    
    SCIResamplingMode _selectedResamplingMode;
}

@synthesize pointsCount = _pointsCount;

- (Class)associatedType { return SCIChartSurface.class; }

- (void)commonInit {
    _seriesTypes = @[
        @"SCIFastLineRenderableSeries",
        @"SCIFastMountainRenderableSeries",
        @"SCIXyScatterRenderableSeries",
    ];
    _selectedSeriesTypeIndex = 0;
    
    _strokeThicknessValues = @[
        @"1",
        @"2",
        @"3",
        @"4",
        @"5"
    ];
    _selectedStrokeThicknessIndex = 0;
    
    _speedValues = @[
        @"1k points p/s",
        @"10k points p/s",
        @"100k points p/s",
    ];
    _selectedSpeedValueIndex = 2;
    
    _resamplingModes = @[
        @"None",
        @"MinMax",
        @"Mid",
        @"Max",
        @"Min",
        @"MinOrMax",
        @"Auto",
    ];
    _selectedResamplingMode = SCIResamplingMode_Auto;
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;
    
    SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"Performance demo settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
    
    return @[
        settingsToolbar,
        [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
            [[SCDToolbarItem alloc] initWithTitle:@"Start" image:[SCIImage imageNamed:@"chart.play"] andAction:^{ [wSelf onStartPress]; }],
            [[SCDToolbarItem alloc] initWithTitle:@"Pause" image:[SCIImage imageNamed:@"chart.pause"] andAction:^{ [wSelf onPausePress]; }],
            [[SCDToolbarItem alloc] initWithTitle:@"Stop" image:[SCIImage imageNamed:@"chart.stop"] andAction:^{ [wSelf onStopPress]; }],
        ]]
    ];
}

- (void)onStartPress { }
- (void)onPausePress { }
- (void)onStopPress { }

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    SCDToolbarPopupItem *seriesTypePopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_seriesTypes selectedIndex:_selectedSeriesTypeIndex andAction:^(NSUInteger selectedIndex) {
        [wSelf p_SCD_onSelectedSeriesTypeChange:selectedIndex];
    }];
    SCDToolbarPopupItem *strokePopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_strokeThicknessValues selectedIndex:_selectedStrokeThicknessIndex andAction:^(NSUInteger selectedIndex) {
        [wSelf p_SCD_onSelectedStrokeThicknessChange:selectedIndex];
    }];
    SCDToolbarPopupItem *speedPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_speedValues selectedIndex:_selectedSpeedValueIndex andAction:^(NSUInteger selectedIndex) {
        [wSelf p_SCD_onSelectedSpeedChange:selectedIndex];
    }];
    SCDToolbarPopupItem *resamplingPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_resamplingModes selectedIndex:(int)_selectedResamplingMode andAction:^(NSUInteger selectedIndex) {
        [wSelf p_SCD_onSelectedResamplingModeChange:selectedIndex];
    }];
    
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Series type:" item:seriesTypePopupItem],
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Stroke:" item:strokePopupItem],
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Speed:" item:speedPopupItem],
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Resampling:" item:resamplingPopupItem]
    ];
}

- (void)p_SCD_onSelectedSeriesTypeChange:(NSUInteger)index {
    _selectedSeriesTypeIndex = index;
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        for (NSUInteger i = 0, count = self.surface.renderableSeries.count; i < count; i++) {
            id<ISCIRenderableSeries> oldSeries = self.surface.renderableSeries[i];
            id<ISCIRenderableSeries> newSeries = [self createRenderableSeriesWithColorCode:oldSeries.strokeStyle.colorCode];
            newSeries.dataSeries = oldSeries.dataSeries;
            
            [self.surface.renderableSeries setObject:newSeries at:i];
        }
    }];
}

- (id<ISCIRenderableSeries>)createRenderableSeriesWithColorCode:(unsigned int)colorCode {
    id<ISCIRenderableSeries> rSeries = [self p_SCD_getRenderableSeries];
    rSeries.dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int yType:SCIDataType_Float];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:colorCode thickness:[self p_SCD_getStrokeThickness]];
    rSeries.resamplingMode = _selectedResamplingMode;
    
    if ([rSeries isKindOfClass:SCIFastMountainRenderableSeries.class]) {
        ((SCIFastMountainRenderableSeries *)rSeries).areaStyle = [[SCISolidBrushStyle alloc] initWithColorCode:colorCode];
    } else if ([rSeries isKindOfClass:SCIXyScatterRenderableSeries.class]) {
        SCICrossPointMarker *pointMarker = [SCICrossPointMarker new];
        pointMarker.size = CGSizeMake(20, 20);
        pointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:colorCode thickness:[self p_SCD_getStrokeThickness]];
        rSeries.pointMarker = pointMarker;
    }

    return rSeries;
}

- (id<ISCIRenderableSeries>)p_SCD_getRenderableSeries {
    switch (_selectedSeriesTypeIndex) {
        case 0:
            return [SCIFastLineRenderableSeries new];
        case 1:
            return [SCIFastMountainRenderableSeries new];
        case 2:
            return [SCIXyScatterRenderableSeries new];
        default:
            return nil;
    }
}

- (float)p_SCD_getStrokeThickness {
    return _strokeThicknessValues[_selectedStrokeThicknessIndex].floatValue;
}

- (void)p_SCD_onSelectedStrokeThicknessChange:(NSUInteger)index {
    _selectedStrokeThicknessIndex = index;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        for (id<ISCIRenderableSeries> series in self.surface.renderableSeries) {
            series.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:series.strokeStyle.colorCode thickness:[self p_SCD_getStrokeThickness]];
            if ([series isKindOfClass:SCIXyScatterRenderableSeries.class]) {
                series.pointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:series.strokeStyle.colorCode thickness:[self p_SCD_getStrokeThickness]];
            }
        }
    }];
}

- (void)p_SCD_onSelectedSpeedChange:(NSUInteger)index {
    _selectedSpeedValueIndex = index;
}

- (int)pointsCount {
    switch (_selectedSpeedValueIndex) {
        case 0:
            return 10;
        case 1:
            return 100;
        case 2:
            return 1000;
        default:
            return 100;
    }
}

- (void)p_SCD_onSelectedResamplingModeChange:(NSUInteger)index {
    _selectedResamplingMode = index > 5 ? SCIResamplingMode_Auto : (SCIResamplingMode)index;
    
    SCIResamplingMode selectedMode = _selectedResamplingMode;
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        for (id<ISCIRenderableSeries> series in self.surface.renderableSeries) {
            series.resamplingMode = selectedMode;
        }
    }];
}

@end
