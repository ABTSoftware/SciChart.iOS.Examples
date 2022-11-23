//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDThemeManagerViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDThemeManagerViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDConstants.h"
#import "SCDSelectableItem.h"
#import "SCDToggleButtonsGroup.h"
#import "SCDToolbarPopupItem.h"
#import "SCIStackView.h"
@import SciChart.Utils;

@implementation SCDThemeManagerViewControllerBase {
    SCDSettingsPresenter *_settingsPresenter;
    SCDToggleButtonsGroup *_buttonsGroup;
    
    SCICursorModifier *_cursorModifier;
    SCIModifierGroup *_zoomingModifiers;
    
    NSArray *_themeNames;
    NSArray *_themes;
    NSInteger _initialThemeIndex;
    
    SCDToolbarPopupItem *_changeThemeItem;
}

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    [SCIThemeManager applyTheme:theme toThemeable:self.surface];
}

- (void)commonInit {
    _themeNames = @[@"Black Steel", @"Bright Spark", @"Chrome", @"Chart V4 Dark", @"Electric", @"Expression Dark", @"Expression Light", @"Oscilloscope" , @"Navy"];
    _themes = @[SCIChartThemeBlackSteel, SCIChartThemeBrightSpark, SCIChartThemeChrome, SCIChartThemeV4Dark, SCIChartThemeElectric, SCIChartThemeExpressionDark, SCIChartThemeExpressionLight, SCIChartThemeOscilloscope, SCIChartThemeNavy];
    _initialThemeIndex = 8;
    
    _changeThemeItem = [self p_SCD_createToolbarPopupItem];
    
    _cursorModifier = [SCICursorModifier new];
    _cursorModifier.isEnabled = YES;
    
    SCIPinchZoomModifier *pinchZoom = [SCIPinchZoomModifier new];
    pinchZoom.receiveHandledEvents = YES;
    
    SCIZoomPanModifier *zoomPan = [SCIZoomPanModifier new];
    zoomPan.receiveHandledEvents = YES;
    _zoomingModifiers = [[SCIModifierGroup alloc] initWithChildModifiers:@[pinchZoom, zoomPan]];
    _zoomingModifiers.isEnabled = NO;
}

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    SCIStackView *stackView = [SCIStackView new];
    stackView.axis = SCILayoutConstraintAxisVertical;
    stackView.spacing = 0;
    
#if TARGET_OS_IOS
    [stackView addArrangedSubview:[self providePanel]];
#endif
    
    SCIView<ISCIChartSurfaceBase> *surface = [[self.associatedType alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [stackView addArrangedSubview:surface];
    _surface = surface;
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:stackView];
    
    [self.view addConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [stackView.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor],
    ]];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [((SCIChartSurface *)self.surface).chartModifiers addAll:self->_cursorModifier, self->_zoomingModifiers, nil];
    }];
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;
    
    SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"Theme manager settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
    
    return @[
        settingsToolbar,
#if TARGET_OS_OSX
        _changeThemeItem
#endif
    ];
}

#if TARGET_OS_IOS
- (SCIView *)providePanel {
    return [_changeThemeItem createView];
}
#endif

- (SCDToolbarPopupItem *)p_SCD_createToolbarPopupItem {
    __weak typeof(self) wSelf = self;
    return [[SCDToolbarPopupItem alloc] initWithTitles:_themeNames selectedIndex:_initialThemeIndex andAction:^(NSUInteger selectedIndex) {
        [wSelf applyTheme:self->_themes[selectedIndex] toThemeable:wSelf.surface];
    }];
}

- (void)applyTheme:(SCIChartTheme)theme toThemeable:(id<ISCIThemeable>)themeable {
    @throw [self notImplementedExceptionFor:_cmd];
}

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    
    _buttonsGroup = [[SCDToggleButtonsGroup alloc] initWithSelectableItems:@[
        [[SCDSelectableItem alloc] initWithTitle:@"Enable cursor" isSelected:_cursorModifier.isEnabled andAction:^(BOOL isSelected) {
            [wSelf p_SCD_toggleModifiersWithIndex:0];
        }],
        [[SCDSelectableItem alloc] initWithTitle:@"Enable Zoom/Pan" isSelected:_zoomingModifiers.isEnabled andAction:^(BOOL isSelected) {
            [wSelf p_SCD_toggleModifiersWithIndex:1];
        }]
    ]];
    
    return @[_buttonsGroup];
}

- (void)p_SCD_toggleModifiersWithIndex:(NSUInteger)index {
    NSArray<id<ISCIChartModifier>> *modifiers = @[_cursorModifier, _zoomingModifiers];
    for (NSUInteger i = 0, count = modifiers.count; i < count; i++) {
        modifiers[i].isEnabled = i == index;
    }
    
    [_buttonsGroup buttonSelectedWithIndex:index];
}

@end
