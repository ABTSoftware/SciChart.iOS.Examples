//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDBrushModifierChartViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDBrushModifierChartViewController.h"
#import "SCDSettingsPresenter.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarItem.h"
#import "SCDToolbarPopupItem.h"
#import "SCDLabeledSettingsItem.h"
#import "SCDConstants.h"
#import "SCISlider.h"

@implementation SCDBrushModifierChartViewController {
    SCDSettingsPresenter *_settingsPresenter;
    SCIView *_topView;
    SCIStackView *topStackView;
    NSArray *colors;
    
    NSLayoutConstraint *_topViewHeightAnchorPortrait;
    NSLayoutConstraint *_topViewWidthAnchorLandscape;
    BOOL isPortrait;
}

@synthesize brushModifier = _brushModifier;
@synthesize zoomPanModifier = _zoomPanModifier;

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    isPortrait = YES;
    _topView = [[SCIView alloc] init];
    
#if TARGET_OS_IOS
    isPortrait = UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation);
    _topView.backgroundColor = [SCIColor fromARGBColorCode:0xFF000000];

#elif TARGET_OS_OSX
    isPortrait = NO;
    _topView.wantsLayer = YES;
    _topView.layer.backgroundColor = [[SCIColor fromARGBColorCode:0xFF000000] CGColor];

#endif
    _topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_topView];
    
    [self p_SCD_createTopView];
    
    _surface = [[self.associatedType alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _surface.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_surface];
    
    [self p_SCD_updateConstraints];
}

- (void)p_SCD_updateConstraints {
    [self p_SCD_removeAllConstraints];
    [self p_SCD_updateStackViewsAxis];
    
#if TARGET_OS_OSX
    id layoutGuide = self.view;
#else
    id layoutGuide = self.view.safeAreaLayoutGuide;
#endif
    
    
//#if TARGET_OS_OSX
//    [_topView.leadingAnchor constraintEqualToAnchor:[layoutGuide leadingAnchor]].active = YES;
//    [_surface.topAnchor constraintEqualToAnchor:_topView.bottomAnchor].active = YES;
//    [_surface.trailingAnchor constraintEqualToAnchor:[layoutGuide trailingAnchor]].active = YES;
//    [_surface.bottomAnchor constraintEqualToAnchor:[layoutGuide bottomAnchor]].active = YES;
//#else
//    
//    [_topView.leadingAnchor constraintEqualToAnchor:[self.view leadingAnchor]].active = YES;
//    [_surface.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
//    [_surface.trailingAnchor constraintEqualToAnchor:[self.view trailingAnchor]].active = YES;
//    [_surface.bottomAnchor constraintEqualToAnchor:[self.view bottomAnchor]].active = YES;
//#endif
    
    [_topView.leadingAnchor constraintEqualToAnchor:[self.view leadingAnchor]].active = YES;
    [_surface.topAnchor constraintEqualToAnchor:_topView.bottomAnchor].active = YES;
    [_surface.trailingAnchor constraintEqualToAnchor:[self.view trailingAnchor]].active = YES;
    [_surface.bottomAnchor constraintEqualToAnchor:[self.view bottomAnchor]].active = YES;
    
    //Common
    [_topView.topAnchor constraintEqualToAnchor:[layoutGuide topAnchor]].active = YES;
    [_topView.trailingAnchor constraintEqualToAnchor:[self.view trailingAnchor]].active = YES;
    [_surface.leadingAnchor constraintEqualToAnchor:[self.view leadingAnchor]].active = YES;
}

- (void)p_SCD_removeAllConstraints {
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if (constraint != nil) {
            [self.view removeConstraint:constraint];
        }
    }
    
    if (_topViewHeightAnchorPortrait != nil) {
        [_topView removeConstraint:_topViewHeightAnchorPortrait];
    }
    
    if (_topViewWidthAnchorLandscape != nil) {
        [_topView removeConstraint:_topViewWidthAnchorLandscape];
    }
}

- (void)p_SCD_updateStackViewsAxis {
    topStackView.axis = [self p_SCD_getStackViewConstraintAxis];
}

- (SCILayoutConstraintAxis)p_SCD_getStackViewConstraintAxis {
    return SCILayoutConstraintAxisVertical;
//    return isPortrait ? SCILayoutConstraintAxisHorizontal : SCILayoutConstraintAxisVertical;
}

- (void)p_SCD_createTopView {
    
    SCIButton *btnDel = [SCIButton new];

    #if TARGET_OS_OSX
        btnDel.wantsLayer = YES;
        btnDel.layer.backgroundColor = [SCIColor fromABGRColorCode:0xFF2C2E32].CGColor;
        [btnDel setTitle:@"DEL"];
        btnDel.target = self;
        btnDel.action = @selector(btnDeleteAction:);
    #else
        btnDel.backgroundColor = [SCIColor fromABGRColorCode:0xFF2C2E32];
        btnDel.tintColor = [SCIColor whiteColor];
        [btnDel setTitle:@"DEL" forState:UIControlStateNormal];
        [btnDel addTarget:self action:@selector(btnDeleteAction:) forControlEvents:UIControlEventTouchUpInside];
    #endif

    btnDel.translatesAutoresizingMaskIntoConstraints = NO;
    [_topView addSubview:btnDel];
    
    // Draw label
    SCILabel *drawLabel = [[SCILabel alloc] init];
    drawLabel.text = @"Draw";
    drawLabel.textColor = [SCIColor whiteColor];
    
    // Draw switch
    SCISwitch *drawSwitch = [[SCISwitch alloc] init];

    #if TARGET_OS_OSX
        drawSwitch.target = self;
        drawSwitch.action = @selector(drawSwitchAction:);
        drawSwitch.state = NSControlStateValueOn;
    #else
        [drawSwitch addTarget:self action:@selector(drawSwitchAction:) forControlEvents:UIControlEventTouchUpInside];
        [drawSwitch setOn:YES];
    #endif
    
    SCIStackView *drawStack = [[SCIStackView alloc] initWithArrangedSubviews:@[drawLabel, drawSwitch]];
    drawStack.axis = SCILayoutConstraintAxisHorizontal;
    drawStack.spacing = 10;
    
    // Thickness label
    SCILabel *thicknessLabel = [[SCILabel alloc] init];
    thicknessLabel.text = @"Thickness:";
    thicknessLabel.textColor = [SCIColor whiteColor];
    
    // Slider
    SCISlider *slider = [[SCISlider alloc] init];

    #if TARGET_OS_OSX
        slider.minValue = 1;
        slider.maxValue = 10;
        slider.doubleValue = 5;
        slider.target = self;
        slider.action = @selector(thicknessChanged:);
    #else
        slider.minimumValue = 1;
        slider.maximumValue = 10;
        slider.value = 5;
        slider.tintColor = [SCIColor cyanColor];
        [slider addTarget:self action:@selector(thicknessChanged:) forControlEvents:UIControlEventValueChanged];
    #endif
    
    SCIStackView *thicknessStack = [[SCIStackView alloc] initWithArrangedSubviews:@[thicknessLabel, slider]];
    thicknessStack.axis = SCILayoutConstraintAxisHorizontal;
    thicknessStack.spacing = 10;
    
#if TARGET_OS_OSX
    drawStack.alignment = NSLayoutAttributeCenterY;
    thicknessStack.alignment = NSLayoutAttributeCenterY;
#else
    drawStack.alignment = UIStackViewAlignmentCenter;
    thicknessStack.alignment = UIStackViewAlignmentCenter;
#endif
    
    // Color buttons
    colors = @[
        @0xFFD3D3D3, @0xFFFF0000, @0xFF00FF00, @0xFF0000FF
    ];
    
    SCIStackView *colorStack = [[SCIStackView alloc] init];
    colorStack.axis = SCILayoutConstraintAxisHorizontal;
    colorStack.spacing = 10;
    
    self.colorButtons = [[NSMutableArray alloc] init];
    
    for (int i=0; i<(int)colors.count; i++) {
        unsigned int color = [colors[i] unsignedIntValue];
        
        SCIButton *btn;

        #if TARGET_OS_OSX
            btn = [SCIButton new];
            btn.wantsLayer = YES;
            btn.layer.backgroundColor = [self colorFromARGB:color].CGColor;
            btn.target = self;
            btn.action = @selector(btnColorAction:);
        btn.title = @"";
        #else
            btn = [SCIButton buttonWithType:UIButtonTypeSystem];
            btn.backgroundColor = [self colorFromARGB:color];
            [btn addTarget:self action:@selector(btnColorAction:) forControlEvents:UIControlEventTouchUpInside];
        #endif
        
        btn.layer.cornerRadius = 6;
        btn.translatesAutoresizingMaskIntoConstraints = NO;
        
        [btn.widthAnchor constraintEqualToConstant:40].active = YES;
        [btn.heightAnchor constraintEqualToConstant:40].active = YES;
        
        btn.tag = i;
        [colorStack addArrangedSubview:btn];
        
        [self.colorButtons addObject:btn];
        
        if (i == 0) {
            btn.layer.borderColor = SCIColor.redColor.CGColor;
            btn.layer.borderWidth = 1.5;
            _strokeColor = color;
        }
    }
    
    // Main stack
    SCIStackView *upperStack = [SCIStackView new];
#if TARGET_OS_OSX
    upperStack = [[SCIStackView alloc] initWithArrangedSubviews:@[
        btnDel,
        drawStack,
        colorStack
    ]];
#else
    if (isPortrait) {
        upperStack = [[SCIStackView alloc] initWithArrangedSubviews:@[
            drawStack,
            colorStack
        ]];
    }
    else {
        upperStack = [[SCIStackView alloc] initWithArrangedSubviews:@[
            btnDel,
            drawStack,
            colorStack
        ]];
    }
#endif
    
    
    
    upperStack.axis = SCILayoutConstraintAxisHorizontal;
    upperStack.spacing = 20;
    upperStack.translatesAutoresizingMaskIntoConstraints = NO;
#if TARGET_OS_OSX
    upperStack.distribution = NSStackViewDistributionEqualSpacing;
#else
    upperStack.distribution = UIStackViewDistributionEqualSpacing;
#endif
    
    SCIStackView *mainStack = [[SCIStackView alloc] initWithArrangedSubviews:@[
        upperStack,
        thicknessStack
    ]];
    
    mainStack.axis = SCILayoutConstraintAxisVertical;
    mainStack.spacing = 20;
    mainStack.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_topView addSubview:mainStack];
    
#if TARGET_OS_OSX
    _thickness = slider.doubleValue;
    
    [_topView addConstraints:@[
        [btnDel.widthAnchor constraintEqualToConstant:100],
        [mainStack.topAnchor constraintEqualToAnchor:_topView.topAnchor constant:10],
        [mainStack.leadingAnchor constraintEqualToAnchor:_topView.leadingAnchor constant:10],
        [mainStack.trailingAnchor constraintEqualToAnchor:_topView.trailingAnchor constant:-10],
        [mainStack.bottomAnchor constraintEqualToAnchor:_topView.bottomAnchor constant:-10]
    ]];
    
#else
    _thickness = slider.value;
    
    if (isPortrait) {
        [_topView addConstraints:@[
            [btnDel.leadingAnchor constraintEqualToAnchor:_topView.leadingAnchor constant:10],
            [btnDel.widthAnchor constraintEqualToConstant:100],
            [btnDel.bottomAnchor constraintEqualToAnchor:mainStack.topAnchor constant:-10],
            [btnDel.topAnchor constraintEqualToAnchor:_topView.topAnchor constant:10],
            [mainStack.leadingAnchor constraintEqualToAnchor:_topView.leadingAnchor constant:10],
            [mainStack.trailingAnchor constraintEqualToAnchor:_topView.trailingAnchor constant:-10],
            [mainStack.bottomAnchor constraintEqualToAnchor:_topView.bottomAnchor constant:-10]
        ]];
    }
    else {
        [_topView addConstraints:@[
            [btnDel.widthAnchor constraintEqualToConstant:100],
            [mainStack.topAnchor constraintEqualToAnchor:_topView.topAnchor constant:10],
            [mainStack.leadingAnchor constraintEqualToAnchor:_topView.leadingAnchor constant:10],
            [mainStack.trailingAnchor constraintEqualToAnchor:_topView.trailingAnchor constant:-70],
            [mainStack.bottomAnchor constraintEqualToAnchor:_topView.bottomAnchor constant:-10]
        ]];
    }
#endif
}

- (void)thicknessChanged:(SCISlider *)sender {
#if TARGET_OS_OSX
    _thickness = sender.doubleValue;
#else
    _thickness = sender.value;
#endif
    self.brushModifier.stroke = [[SCISolidPenStyle alloc] initWithColorCode:_strokeColor thickness:_thickness];
}

-(IBAction)drawSwitchAction:(SCISwitch*)sender {
#if TARGET_OS_OSX
    BOOL isOn = sender.state == NSControlStateValueOn;
#else
    BOOL isOn = sender.on;
#endif

    _brushModifier.isEnabled = isOn;
    _zoomPanModifier.isEnabled = !isOn;
}

-(IBAction)btnDeleteAction:(SCIButton*)sender {
    [self.brushModifier deleteSelectedAnnotations];
}

-(IBAction)btnColorAction:(SCIButton*)sender {
    
    for (SCIButton *btn in _colorButtons) {
        btn.layer.borderColor = SCIColor.clearColor.CGColor;
        btn.layer.borderWidth = 0;
    }
    
    sender.layer.borderColor = SCIColor.redColor.CGColor;
    sender.layer.borderWidth = 1.5;
    _strokeColor = [colors[sender.tag] unsignedIntValue];
    self.brushModifier.stroke = [[SCISolidPenStyle alloc] initWithColorCode:_strokeColor thickness:_thickness];
}

- (SCIColor *)colorFromARGB:(unsigned int)color {
    CGFloat a = ((color >> 24) & 0xFF) / 255.0;
    CGFloat r = ((color >> 16) & 0xFF) / 255.0;
    CGFloat g = ((color >> 8) & 0xFF) / 255.0;
    CGFloat b = (color & 0xFF) / 255.0;

    return [SCIColor colorWithRed:r green:g blue:b alpha:a];
}

@end
