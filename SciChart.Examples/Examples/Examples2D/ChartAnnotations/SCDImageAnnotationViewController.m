//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2024. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDImageAnnotationViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDImageAnnotationViewController.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDSwitchItem.h"
#import "SCDConstants.h"
#import "SCDToolbarSliderItem.h"

@interface SCDImageAnnotationViewController()

@end

@implementation SCDImageAnnotationViewController {
    SCDSettingsPresenter *_settingsPresenter;
    NSUInteger _contentModeSelectionIndex;
    
    NSArray<NSString *> *_contentModeTitle;
}

@synthesize imageAnnotationContentMode = _imageAnnotationContentMode;

- (Class)associatedType { return SCIChartSurface.class; }

- (void)commonInit {
    _contentModeTitle = @[@"Aspect Fit", @"Scale to Fill", @"Aspect Fill"];
    _imageAnnotationContentMode = [self p_SCD_onXAxisTickLabelAlignmentChange:1];
    _contentModeSelectionIndex = 1;
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
    SCDToolbarPopupItem *xBottomAxisAlignmentPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_contentModeTitle selectedIndex:_contentModeSelectionIndex andAction:^(NSUInteger selectedIndex) {
        self->_contentModeSelectionIndex = selectedIndex;
        wSelf.imageAnnotationContentMode = [wSelf p_SCD_onXAxisTickLabelAlignmentChange:selectedIndex];
        wSelf.imageAnnotation.contentMode = wSelf.imageAnnotationContentMode;
    }];
    
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Image annotation content mode" item:xBottomAxisAlignmentPopupItem iOS_orientation:SCILayoutConstraintAxisVertical]
    ];
}

- (SCIContentModeEnum)p_SCD_onXAxisTickLabelAlignmentChange:(NSUInteger)index {
    switch (index) {
        case 0:
            return SCIContentMode_AspectFit;
            break;
        case 1:
            return SCIContentMode_ScaleToFill;
            break;
        case 2:
            return SCIContentMode_AspectFill;
            break;
        default:
            return SCIContentMode_ScaleToFill;
            break;
    }
}

@end
