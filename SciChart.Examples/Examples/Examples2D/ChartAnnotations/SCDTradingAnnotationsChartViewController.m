//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDTradingAnnotationsChartViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDTradingAnnotationsChartViewController.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDConstants.h"

@implementation SCDTradingAnnotationsChartViewController {
    SCDSettingsPresenter *_settingsPresenter;
    NSString *pitchforkInstruction;
    NSString *xabcdInstruction;
}

@synthesize xabcdCreationModifier = _xabcdCreationModifier;
@synthesize pitchforkCreationModifier = _pitchforkCreationModifier;
@synthesize selectedCreationModifier = _selectedCreationModifier;
@synthesize instructionAnnotation = _instructionAnnotation;

- (Class)associatedType { return SCIChartSurface.class; }

- (void)commonInit {
    _selectedCreationModifier = SCICreationModifier_Pitchfork;
    
    pitchforkInstruction = @"- Tap and drag your finger on the chart\nto position the pivot (starting point).\n- Lift your finger where you want to place\nthe first anchor point.\n- Drag your finger toward the desired location\nfor the second point, then lift your finger to place it.";
    
    xabcdInstruction = @"- Drag your finger from point X to form the XA line,\nthen lift your finger at the desired point A.\n- Drag your finger again from point A to form the AB line,\nand lift your finger when you reach point B.\n- Repeat the same step to draw from point B to point C\nand point c to point D.";
    
    _instructionAnnotation = [SCITextAnnotation new];
    _instructionAnnotation.text = pitchforkInstruction;
    
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
    SCDToolbarPopupItem *dragModePopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:@[@"Pitchfork annotation", @"xabcd Annotation"] selectedIndex:_selectedCreationModifier andAction:^(NSUInteger selectedCreationModifier) {
        [wSelf p_SCD_onDragModeChange:selectedCreationModifier];
    }];
    
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Annotation:" item:dragModePopupItem]
    ];
}

- (void)p_SCD_onDragModeChange:(SCICreationModifier)selectedCreationModifier {
    _selectedCreationModifier = selectedCreationModifier;
    [self.xabcdCreationModifier reset];
    [self.pitchforkCreationModifier reset];
    
    switch (_selectedCreationModifier) {
        case SCICreationModifier_Pitchfork:
            [self.surface.chartModifiers remove:_xabcdCreationModifier];
            [self.surface.chartModifiers add:_pitchforkCreationModifier];
            _instructionAnnotation.text = pitchforkInstruction;
            break;
        case SCICreationModifier_Xabcd:
            [self.surface.chartModifiers remove:_pitchforkCreationModifier];
            [self.surface.chartModifiers add:_xabcdCreationModifier];
            _instructionAnnotation.text = xabcdInstruction;
            break;
    }
}


@end
