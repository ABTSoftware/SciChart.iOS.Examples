//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2024. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDFixThicknessAxisChartViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDFixThicknessAxisChartViewController.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDSwitchItem.h"
#import "SCDConstants.h"
#import "SCDToolbarSliderItem.h"

@interface SCDFixThicknessAxisChartViewController()

@end

@implementation SCDFixThicknessAxisChartViewController {
    SCDSettingsPresenter *_settingsPresenter;
    
    NSUInteger _xTopAxisSelectedIndex;
    NSUInteger _xBottomAxisSelectedIndex;
    NSUInteger _yRightAxisSelectedIndex;
    NSUInteger _yLeftAxisSelectedIndex;
    
    NSArray<NSString *> *_xAxisAlignments;
    NSArray<NSString *> *_yAxisAlignments;
}

@synthesize xBottomAxisTickLabelAlignment = _xBottomAxisTickLabelAlignment;
@synthesize yLeftAxisTickLabelAlignment = _yLeftAxisTickLabelAlignment;
@synthesize xTopAxisTickLabelAlignment = _xTopAxisTickLabelAlignment;
@synthesize yRightAxisTickLabelAlignment = _yRightAxisTickLabelAlignment;

@synthesize isShowXTopAxisTitle = _isShowXTopAxisTitle;
@synthesize isShowXBottomAxisTitle = _isShowXBottomAxisTitle;
@synthesize isShowYLeftAxisTitle = _isShowYLeftAxisTitle;
@synthesize isShowYRightAxisTitle = _isShowYRightAxisTitle;

- (Class)associatedType { return SCIChartSurface.class; }

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    _lblInfo = [[SCILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    
    for (SCIView *surface in @[self.surface, _lblInfo]) {
        surface.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:surface];
    }
    
    [self.view addConstraints:@[
        [_lblInfo.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:20],
        [_lblInfo.topAnchor constraintEqualToAnchor:self.view.topAnchor],
        [_lblInfo.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-20],
        [_lblInfo.heightAnchor constraintEqualToConstant:60],
        [_lblInfo.bottomAnchor constraintEqualToAnchor:self.surface.topAnchor],
        
        [self.surface.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [self.surface.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [self.surface.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor]
    ]];
    
    _lblInfo.text = @"Use the settings button top right to change the axis label alignments";
    _lblInfo.textColor = SCIColor.whiteColor;
    _lblInfo.numberOfLines = 0;
    _lblInfo.lineBreakMode = NSLineBreakByWordWrapping;
    _lblInfo.textAlignment = NSTextAlignmentLeft;
    _lblInfo.font = [SCIFont systemFontOfSize:17];
}


- (void)commonInit {
    _xAxisAlignments = @[@"Top", @"Center", @"Bottom"];
    _yAxisAlignments = @[@"Left", @"Center", @"Right"];
    
    _xTopAxisTickLabelAlignment = [self p_SCD_onXAxisTickLabelAlignmentChange:0];
    _xBottomAxisTickLabelAlignment = [self p_SCD_onXAxisTickLabelAlignmentChange:0];
    _yRightAxisTickLabelAlignment = [self p_SCD_onYAxisTickLabelAlignmentChange:0];
    _yLeftAxisTickLabelAlignment = [self p_SCD_onYAxisTickLabelAlignmentChange:2];
    
    _yLeftAxisSelectedIndex = 2;
    
    _isShowXTopAxisTitle = true;
    _isShowXBottomAxisTitle = true;
    _isShowYRightAxisTitle = true;
    _isShowYLeftAxisTitle = true;
}

 - (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
     __weak typeof(self) wSelf = self;
     
     SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
         [[SCDToolbarItem alloc] initWithTitle:@"ColourMap settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
     ]];
     settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
     
     return @[settingsToolbar];
 }

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    
    SCDToolbarPopupItem *xTopAxisAlignmentPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_xAxisAlignments selectedIndex:_xTopAxisSelectedIndex andAction:^(NSUInteger selectedIndex) {
        self->_xTopAxisSelectedIndex = selectedIndex;
        wSelf.xTopAxisTickLabelAlignment = [wSelf p_SCD_onXAxisTickLabelAlignmentChange:selectedIndex];
#if TARGET_OS_OSX
        wSelf.xTopAxis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:wSelf.xTopAxisTickLabelAlignment andMargins:NSEdgeInsetsZero];
#else
        wSelf.xTopAxis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:wSelf.xTopAxisTickLabelAlignment andMargins:UIEdgeInsetsZero];
#endif
        
    }];
    
    SCDToolbarPopupItem *xBottomAxisAlignmentPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_xAxisAlignments selectedIndex:_xBottomAxisSelectedIndex andAction:^(NSUInteger selectedIndex) {
        self->_xBottomAxisSelectedIndex = selectedIndex;
        wSelf.xBottomAxisTickLabelAlignment = [wSelf p_SCD_onXAxisTickLabelAlignmentChange:selectedIndex];
        
#if TARGET_OS_OSX
        wSelf.xBottomAxis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:wSelf.xBottomAxisTickLabelAlignment andMargins:NSEdgeInsetsZero];
#else
        wSelf.xBottomAxis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:wSelf.xBottomAxisTickLabelAlignment andMargins:UIEdgeInsetsZero];
#endif
        
    }];
    
    SCDToolbarPopupItem *yRightAxisAlignmentPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_yAxisAlignments selectedIndex:_yRightAxisSelectedIndex andAction:^(NSUInteger selectedIndex) {
        self->_yRightAxisSelectedIndex = selectedIndex;
        wSelf.yRightAxisTickLabelAlignment = [wSelf p_SCD_onYAxisTickLabelAlignmentChange:selectedIndex];
#if TARGET_OS_OSX
        wSelf.yRightAxis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:wSelf.yRightAxisTickLabelAlignment andMargins:NSEdgeInsetsZero];
#else
        wSelf.yRightAxis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:wSelf.yRightAxisTickLabelAlignment andMargins:UIEdgeInsetsZero];
#endif
        
    }];
    
    SCDToolbarPopupItem *yLeftAxisAlignmentPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_yAxisAlignments selectedIndex:_yLeftAxisSelectedIndex andAction:^(NSUInteger selectedIndex) {
        self->_yLeftAxisSelectedIndex = selectedIndex;
        wSelf.yLeftAxisTickLabelAlignment = [wSelf p_SCD_onYAxisTickLabelAlignmentChange:selectedIndex];
#if TARGET_OS_OSX
        wSelf.yLeftAxis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:wSelf.yLeftAxisTickLabelAlignment andMargins:NSEdgeInsetsZero];
#else
        wSelf.yLeftAxis.axisTickLabelStyle = [[SCIAxisTickLabelStyle alloc] initWithAlignment:wSelf.yLeftAxisTickLabelAlignment andMargins:UIEdgeInsetsZero];
#endif
        
    }];
    
    SCDSwitchItem *xTopAxisTitleSwitch = [[SCDSwitchItem alloc] initWithTitle:@"Show x Top Axis Title" isSelected:_isShowXTopAxisTitle andAction:^(BOOL showAxisTitle) {
        wSelf.isShowXTopAxisTitle = showAxisTitle;
        if (showAxisTitle) {
            wSelf.xTopAxis.axisTitle = wSelf.xTopAxisTitle;
        }
        else {
            wSelf.xTopAxis.axisTitle = @"";
        }
       
    }];
    
    SCDSwitchItem *xBottomAxisTitleSwitch = [[SCDSwitchItem alloc] initWithTitle:@"Show x Bottom Axis Title" isSelected:_isShowXBottomAxisTitle andAction:^(BOOL showAxisTitle) {
        wSelf.isShowXBottomAxisTitle = showAxisTitle;
        if (showAxisTitle) {
            wSelf.xBottomAxis.axisTitle = wSelf.xBottomAxisTitle;
        }
        else {
            wSelf.xBottomAxis.axisTitle = @"";
        }
       
    }];
    
    SCDSwitchItem *yRightAxisTitleSwitch = [[SCDSwitchItem alloc] initWithTitle:@"Show y Right Axis Title" isSelected:_isShowYRightAxisTitle andAction:^(BOOL showAxisTitle) {
        wSelf.isShowYRightAxisTitle = showAxisTitle;
        if (showAxisTitle) {
            wSelf.yRightAxis.axisTitle = wSelf.yRightAxisTitle;
        }
        else {
            wSelf.yRightAxis.axisTitle = @"";
        }
       
    }];
    
    SCDSwitchItem *yLeftAxisTitleSwitch = [[SCDSwitchItem alloc] initWithTitle:@"Show y Left Axis Title" isSelected:_isShowYLeftAxisTitle andAction:^(BOOL showAxisTitle) {
        wSelf.isShowYLeftAxisTitle = showAxisTitle;
        if (showAxisTitle) {
            wSelf.yLeftAxis.axisTitle = wSelf.yLeftAxisTitle;
        }
        else {
            wSelf.yLeftAxis.axisTitle = @"";
        }
       
    }];
    
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"X Top Axis Tick Label Alignment:" item:xTopAxisAlignmentPopupItem iOS_orientation:SCILayoutConstraintAxisVertical],
        xTopAxisTitleSwitch,
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"x Bottom Axis Tick Label Alignment:" item:xBottomAxisAlignmentPopupItem iOS_orientation:SCILayoutConstraintAxisVertical],
       xBottomAxisTitleSwitch,
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Y Right Axis Tick Label Alignment:" item:yRightAxisAlignmentPopupItem iOS_orientation:SCILayoutConstraintAxisVertical],
        yRightAxisTitleSwitch,
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Y Left Axis Tick Label Alignment:" item:yLeftAxisAlignmentPopupItem iOS_orientation:SCILayoutConstraintAxisVertical],
        yLeftAxisTitleSwitch
    ];
}

- (SCIAlignment)p_SCD_onYAxisTickLabelAlignmentChange:(NSUInteger)index {
    switch (index) {
        case 0:
            return SCIAlignment_Left;
            break;
        case 1:
            return SCIAlignment_Center;
            break;
        case 2:
            return SCIAlignment_Right;
            break;
        default:
            return SCIAlignment_Right;
            break;
    }
}

- (SCIAlignment)p_SCD_onXAxisTickLabelAlignmentChange:(NSUInteger)index {
    switch (index) {
        case 0:
            return SCIAlignment_Top;
            break;
        case 1:
            return SCIAlignment_Center;
            break;
        case 2:
            return SCIAlignment_Bottom;
            break;
        default:
            return SCIAlignment_Top;
            break;
    }
}

@end
