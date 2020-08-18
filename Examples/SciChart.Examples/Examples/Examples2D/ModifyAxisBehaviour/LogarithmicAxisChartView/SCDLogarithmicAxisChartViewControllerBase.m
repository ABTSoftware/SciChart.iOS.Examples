//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDLogarithmicAxisChartViewControllerBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDLogarithmicAxisChartViewControllerBase.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDSwitchItem.h"
#import "SCDSettingsItemsGroup.h"
#import "SCDConstants.h"

@implementation SCDLogarithmicAxisChartViewControllerBase {
    NSArray<NSString *> *_logBaseValues;
    SCDSettingsPresenter *_settingsPresenter;
    
    NSUInteger _selectedLogBaseIndex;
    double _selectedLogBase;
    BOOL _isXLogAxis;
    BOOL _isYLogAxis;
}

@synthesize xAxis = _xAxis;
@synthesize yAxis = _yAxis;

- (Class)associatedType { return SCIChartSurface.class; }

- (void)commonInit {
    _selectedLogBase = 10;
    _selectedLogBaseIndex = 2;
    _isXLogAxis = YES;
    _isYLogAxis = YES;
    
    _logBaseValues = @[@"2", @"5", @"10", @"E"];
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    __weak typeof(self) wSelf = self;
    
    SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"Logarithmic axis settings" image:[SCIImage imageNamed:@"chart.settings"] andAction:^{ [wSelf p_SCD_openSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_MODIFIERS_SETTINGS;
    
    return @[settingsToolbar];
}

- (void)p_SCD_openSettings {
    _settingsPresenter = [[SCDSettingsPresenter alloc] initWithSettingsItems:[self p_SCD_createSettingsItems] andIdentifier:TOOLBAR_MODIFIERS_SETTINGS];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_createSettingsItems {
    __weak typeof(self) wSelf = self;
    SCDSettingsItemsGroup *useLogarithmicItemsGroup = [[SCDSettingsItemsGroup alloc] initWithItems:@[
        [[SCDSwitchItem alloc] initWithTitle:@"X-Axis" isSelected:_isXLogAxis andAction:^(BOOL isXLogAxis) {
            [wSelf p_SCD_onIsXLogAxisChange:isXLogAxis];
        }],
        [[SCDSwitchItem alloc] initWithTitle:@"Y-Axis" isSelected:_isXLogAxis andAction:^(BOOL isYLogAxis) {
            [wSelf p_SCD_onIsYLogAxisChange:isYLogAxis];
        }]
    ]];
    SCDToolbarPopupItem *logarithmicPopupItem = [[SCDToolbarPopupItem alloc] initWithTitles:_logBaseValues selectedIndex:_selectedLogBaseIndex andAction:^(NSUInteger selectedIndex) {
        [wSelf p_SCD_onSelectedLogBaseChange:selectedIndex];
    }];
    
    return @[
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Use Logarithmic on:" item:useLogarithmicItemsGroup iOS_orientation:SCILayoutConstraintAxisVertical],
        [[SCDLabeledSettingsItem alloc] initWithLabelText:@"Logarithmic base:" item:logarithmicPopupItem]
    ];
}

- (void)p_SCD_onSelectedLogBaseChange:(NSUInteger)index {
    _selectedLogBaseIndex = index;
    
    switch (_selectedLogBaseIndex) {
        case 0: _selectedLogBase = 2; break;
        case 1: _selectedLogBase = 5; break;
        case 2: _selectedLogBase = 10; break;
        case 3: _selectedLogBase = M_E; break;
            
        default:
            break;
    }
    
    [self p_SCD_trySetLogBase:_selectedLogBase forAxis:_xAxis];
    [self p_SCD_trySetLogBase:_selectedLogBase forAxis:_yAxis];
}

- (void)p_SCD_trySetLogBase:(double)logBase forAxis:(id<ISCIAxis>)axis {
    if ([axis conformsToProtocol:@protocol(ISCILogarithmicNumericAxis)]) {
        ((id<ISCILogarithmicNumericAxis>)axis).logarithmicBase = logBase;
    }
}

- (void)p_SCD_onIsXLogAxisChange:(BOOL)isXLogAxis {
    _isXLogAxis = isXLogAxis;
    _xAxis = _isXLogAxis ? [self generateLogarithmicAxis] : [self generateLinearAxis];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes clear];
        [self.surface.xAxes add:self->_xAxis];
    }];
}

- (void)p_SCD_onIsYLogAxisChange:(BOOL)isYLogAxis {
    _isYLogAxis = isYLogAxis;
    _yAxis = _isYLogAxis ? [self generateLogarithmicAxis] : [self generateLinearAxis];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.yAxes clear];
        [self.surface.yAxes add:self->_yAxis];
    }];
}

- (id<ISCIAxis>)generateLogarithmicAxis {
    SCILogarithmicNumericAxis *axis = [SCILogarithmicNumericAxis new];
    axis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    axis.scientificNotation = SCIScientificNotation_LogarithmicBase;
    axis.textFormatting = @"#.#E+0";
    axis.drawMajorBands = NO;
    axis.logarithmicBase = _selectedLogBase;
    
    return axis;
}

- (id<ISCIAxis>)generateLinearAxis {
    SCINumericAxis *axis = [SCINumericAxis new];
    axis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    axis.scientificNotation = SCIScientificNotation_Normalized;
    axis.textFormatting = @"#.#E+0";
    axis.drawMajorBands = NO;
    
    return axis;
}

@end
