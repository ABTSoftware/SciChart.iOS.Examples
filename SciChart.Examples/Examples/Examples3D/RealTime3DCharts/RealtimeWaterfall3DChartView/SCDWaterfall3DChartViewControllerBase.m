//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDWaterfall3DChartViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDWaterfall3DChartViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDSwitchItem.h"
#import "SCDConstants.h"


@implementation SCDWaterfall3DChartViewControllerBase {
    SCDSettingsPresenter *_settingsPresenter;
    NSArray<NSString *> *_strokeNames;
    NSArray<NSString *> *_fillNames;
    NSUInteger _currentStrokeColorPalette;
    NSUInteger _currentFillColorPalette;
    BOOL _showPointMarkers;
    BOOL _isVolumetric;
    
    SCIGradientColorPalette *_gradientFillColorPalette;
    SCIGradientColorPalette *_gradientStrokeColorPalette;
    SCISolidColorBrushPalette *_transparentColorPalette;
    SCISolidColorBrushPalette *_solidStrokeColorPalette;
    SCISolidColorBrushPalette *_solidFillColorPalette;
}

@synthesize rSeries = _rSeries;

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)commonInit {
    _strokeNames = @[
        @"Gradient Stroke Y",
        @"Gradient Stroke Z",
        @"Solid Fill Color (Green)",
        @"None"
    ];
    
    _fillNames = @[
        @"Gradient Fill YAxis",
        @"Gradient Fill ZAxis",
        @"Solid Color Fill (Blue)",
        @"None"
    ];
    
    _currentStrokeColorPalette = 0; // by default YAxis
    _currentFillColorPalette = 0; // by default YAxis
    
    _showPointMarkers = NO;
    _isVolumetric = YES;
    
    unsigned int fillColors[5] = { 0xFFFF0000, 0xFFFFA500, 0xFFFFFF00, 0xFFADFF2F, 0xFF006400 };
    float fillStops[5] = { 0.0, 0.4, 0.5, 0.6, 1.0 };
    _gradientFillColorPalette = [[SCIGradientColorPalette alloc] initWithColors:fillColors stops:fillStops count:5];
    
    unsigned int strokeColors[4] = {0xFFDC143C, 0xFFFF8C00, 0xFF32CD32, 0xFF32CD32 };
    float strokeStops[4] = { 0.0, 0.33, 0.67, 1.0 };
    _gradientStrokeColorPalette = [[SCIGradientColorPalette alloc] initWithColors:strokeColors stops:strokeStops count:4];
    
    _transparentColorPalette = [[SCISolidColorBrushPalette alloc] initWithColor:0];
    _solidStrokeColorPalette = [[SCISolidColorBrushPalette alloc] initWithColor:0xFF32CD32];
    _solidFillColorPalette = [[SCISolidColorBrushPalette alloc] initWithColor:0xAA00BFFF];
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;
    
    SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"Waterfall3D settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
    
    return @[settingsToolbar];
}

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    SCDToolbarPopupItem *strokePopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_strokeNames selectedIndex:_currentStrokeColorPalette andAction:^(NSUInteger selectedIndex) {
        self->_currentStrokeColorPalette = selectedIndex;
        [wSelf p_SCD_setupStrokeColorPalette];
    }];    
    SCDToolbarPopupItem *fillPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_fillNames selectedIndex:_currentFillColorPalette andAction:^(NSUInteger selectedIndex) {
        self->_currentFillColorPalette = selectedIndex;
        [wSelf p_SCD_setupFillColorPalette];
    }];
            
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Stroke:" item:strokePopupItem],
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Fill:" item:fillPopupItem],
        [[SCDSwitchItem alloc] initWithTitle:@"Show Point Markers" isSelected:_showPointMarkers andAction:^(BOOL showPointMarkers) {
            self->_showPointMarkers = showPointMarkers;
            [wSelf setupPointMarker];
        }],
        [[SCDSwitchItem alloc] initWithTitle:@"Is Volumetric" isSelected:_isVolumetric andAction:^(BOOL isVolumetric) {
            self->_isVolumetric = isVolumetric;
            [wSelf setupSliceThickness];
        }]
    ];
}

- (void)setupColorPalettes {
    [self p_SCD_setupFillColorPalette];
    [self p_SCD_setupStrokeColorPalette];
}

- (void)p_SCD_setupStrokeColorPalette {
    switch (_currentStrokeColorPalette) {
        case 0: // YAxis
            _rSeries.yStrokeColorMapping = _gradientStrokeColorPalette;
            _rSeries.zStrokeColorMapping = nil;
            break;
        case 1: // ZAxis
            _rSeries.yStrokeColorMapping = nil;
            _rSeries.zStrokeColorMapping = _gradientStrokeColorPalette;
            break;
        case 2: // Solid
            _rSeries.yStrokeColorMapping = _solidStrokeColorPalette;
            _rSeries.zStrokeColorMapping = _solidStrokeColorPalette;
            break;
        case 3: // None
            _rSeries.yStrokeColorMapping = _transparentColorPalette;
            _rSeries.zStrokeColorMapping = _transparentColorPalette;
            break;
        default:
            break;
    }
}

- (void)p_SCD_setupFillColorPalette {
    switch (_currentFillColorPalette) {
        case 0: // YAxis
            _rSeries.yColorMapping = _gradientFillColorPalette;
            _rSeries.zColorMapping = nil;
            break;
        case 1: // ZAxis
            _rSeries.yColorMapping = nil;
            _rSeries.zColorMapping = _gradientFillColorPalette;
            break;
        case 2: // Solid
            _rSeries.yColorMapping = _solidFillColorPalette;
            _rSeries.zColorMapping = _solidFillColorPalette;
            break;
        case 3: // None
            _rSeries.yColorMapping = _transparentColorPalette;
            _rSeries.zColorMapping = _transparentColorPalette;
            break;
        default:
            break;
    }
}

- (void)setupPointMarker {
    if (_showPointMarkers) {
        SCISpherePointMarker3D *pointMarker = [SCISpherePointMarker3D new];
        pointMarker.fillColor = 0xFF0000FF;
        pointMarker.size = 5;
        _rSeries.pointMarker = pointMarker;
    } else {
        _rSeries.pointMarker = nil;
    }
}

- (void)setupSliceThickness {
    _rSeries.sliceThickness = _isVolumetric ? 5 : 0;
}

@end
