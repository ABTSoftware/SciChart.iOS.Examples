//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2024. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDChartInsideScrollLayoutViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDChartInsideScrollLayoutViewController.h"

@interface SCDChartInsideScrollLayoutViewController ()

@end

@implementation SCDChartInsideScrollLayoutViewController {
    
    SCIView *_topView;
    SCILabel *_lblSwitchTitle;
    SCISwitch *_switchControl;
    SCIScrollView *_scrollView;
    SCIView *_containerView;
    SCIMultiLineLabel *_lblText;
    SCIMultiLineLabel *_lblBottomText;
    
}
- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    [SCIThemeManager applyTheme:theme toThemeable:self.surface];
    self.view.platformBackgroundColor = self.surface.backgroundBrushStyle.color;
}

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    _topView = [SCIView new];
    _topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self p_SCD_createTopView];
    [self.view addSubview:_topView];
    
    _scrollView = [SCIScrollView new];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_scrollView];
    
    _containerView = [SCIView new];
    _containerView.translatesAutoresizingMaskIntoConstraints = NO;
   
#if TARGET_OS_OSX
    [_scrollView setHasVerticalScroller:YES];
    [_scrollView setDocumentView:_containerView];
#elif TARGET_OS_IOS
    [_scrollView addSubview:_containerView];
#endif

    [self p_SCD_createContainerView];
    [self p_SCD_updateConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.platformBackgroundColor = _surface.backgroundBrushStyle.color;
}

//MARK: Functions
- (void)p_SCD_updateConstraints {
    
    [_topView.heightAnchor constraintEqualToConstant:50].active = YES;
    [_topView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [_topView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_topView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor].active = YES;
    
    [_lblSwitchTitle.leadingAnchor constraintEqualToAnchor:_topView.leadingAnchor constant:10].active = YES;
    [_lblSwitchTitle.centerYAnchor constraintEqualToAnchor:_topView.centerYAnchor].active = YES;
    
    [_switchControl.trailingAnchor constraintEqualToAnchor:_topView.trailingAnchor constant:-10].active = YES;
    [_switchControl.centerYAnchor constraintEqualToAnchor:_topView.centerYAnchor].active = YES;
    
    [_scrollView.leadingAnchor constraintEqualToAnchor:_topView.leadingAnchor].active = YES;
    [_scrollView.trailingAnchor constraintEqualToAnchor:_topView.trailingAnchor].active = YES;
    [_scrollView.topAnchor constraintEqualToAnchor:_topView.bottomAnchor].active = YES;
    [_scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor].active = YES;
    
    [_containerView.leadingAnchor constraintEqualToAnchor:_scrollView.leadingAnchor].active = YES;
    [_containerView.trailingAnchor constraintEqualToAnchor:_scrollView.trailingAnchor].active = YES;
    [_containerView.widthAnchor constraintEqualToAnchor:_scrollView.widthAnchor].active = YES;
    
    [_lblText.leadingAnchor constraintEqualToAnchor:_containerView.leadingAnchor].active = YES;
    [_lblText.trailingAnchor constraintEqualToAnchor:_containerView.trailingAnchor].active = YES;
    [_lblText.topAnchor constraintEqualToAnchor:_containerView.topAnchor].active = YES;
    
    [_surface.leadingAnchor constraintEqualToAnchor:_containerView.leadingAnchor].active = YES;
    [_surface.topAnchor constraintEqualToAnchor:_lblText.bottomAnchor].active = YES;
    [_surface.trailingAnchor constraintEqualToAnchor:_containerView.trailingAnchor].active = YES;
    
    [_lblBottomText.leadingAnchor constraintEqualToAnchor:_containerView.leadingAnchor].active = YES;
    [_lblBottomText.trailingAnchor constraintEqualToAnchor:_containerView.trailingAnchor].active = YES;
    [_lblBottomText.topAnchor constraintEqualToAnchor:_surface.bottomAnchor].active = YES;
    [_lblBottomText.bottomAnchor constraintEqualToAnchor:_containerView.bottomAnchor].active = YES;
    
#if TARGET_OS_OSX
    [_surface.heightAnchor constraintEqualToConstant:800].active = YES;
    [_lblText.heightAnchor constraintEqualToConstant:200].active = YES;
    [_lblBottomText.heightAnchor constraintEqualToConstant:180].active = YES;
#elif TARGET_OS_IOS
    [_surface.heightAnchor constraintEqualToConstant:600].active = YES;
    [_lblText.heightAnchor constraintEqualToConstant:400].active = YES;
    [_lblBottomText.heightAnchor constraintEqualToConstant:180].active = YES;
    
    [_containerView.topAnchor constraintEqualToAnchor:_scrollView.topAnchor].active = YES;
    [_containerView.bottomAnchor constraintEqualToAnchor:_scrollView.bottomAnchor].active = YES;
#endif
}

- (void)p_SCD_createTopView {
    _lblSwitchTitle = [[SCILabel alloc] init];
    _lblSwitchTitle.text = @"Enable scroll in SciChart";
    _lblSwitchTitle.translatesAutoresizingMaskIntoConstraints = NO;
    _lblSwitchTitle.textColor = [SCIColor whiteColor];
    [_topView addSubview:_lblSwitchTitle];
    
    _switchControl = [[SCISwitch alloc] init];
    _switchControl.translatesAutoresizingMaskIntoConstraints = NO;
#if TARGET_OS_OSX
    [_switchControl setTarget:self];
    [_switchControl setAction:@selector(switchChanged:)];
    _switchControl.state = NSControlStateValueOn;
#elif TARGET_OS_IOS
    [_switchControl addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    [_switchControl setOn:YES];
#endif
    [_topView addSubview:_switchControl];
}

- (void)p_SCD_createContainerView {
    _lblText = [[SCIMultiLineLabel alloc] init];
    NSString *strText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet mauris commodo quis. Eget velit aliquet sagittis id consectetur. Sit amet facilisis magna etiam tempor orci eu lobortis. Pellentesque sit amet porttitor eget dolor morbi non arcu risus. Praesent elementum facilisis leo vel fringilla. Nunc sed blandit libero volutpat sed cras ornare arcu dui. Aliquam purus sit amet luctus venenatis lectus. Nisl vel pretium lectus quam id leo in. Ac ut consequat semper viverra nam libero justo laoreet. In est ante in nibh mauris cursus mattis molestie. Ante in nibh mauris cursus mattis molestie a iaculis at. Donec adipiscing tristique risus nec. Sit amet facilisis magna etiam tempor orci eu. Donec et odio pellentesque diam volutpat commodo. At volutpat diam ut venenatis tellus in metus vulputate eu.";
    [self prepareLabel:_lblText withText:strText];
    [_containerView addSubview:_lblText];
    
    _surface = [[self.associatedType alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _surface.translatesAutoresizingMaskIntoConstraints = NO;
    [_containerView addSubview:_surface];
    
    _lblBottomText = [[SCIMultiLineLabel alloc] init];
    NSString *strBottomText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sit amet mauris commodo quis. Eget velit aliquet sagittis id consectetur. Sit amet facilisis magna etiam tempor orci eu lobortis. Pellentesque sit amet porttitor eget dolor morbi non arcu risus. Praesent elementum facilisis leo vel fringilla.";
    [self prepareLabel:_lblBottomText withText:strBottomText];
    [_containerView addSubview:_lblBottomText];
    
}

-(void)prepareLabel:(SCIMultiLineLabel*)lbl withText:(NSString*)text {
    lbl.translatesAutoresizingMaskIntoConstraints = NO;
    
#if TARGET_OS_OSX
    lbl.text = text;
    [lbl setDrawsBackground:YES];
    [lbl setEditable:NO];
    [lbl setSelectable:NO];
#elif TARGET_OS_IOS
    lbl.text = text;
    [lbl setNumberOfLines:0];
#endif
    lbl.backgroundColor = [SCIColor blackColor];
    lbl.textColor = [SCIColor whiteColor];
}

//MARK: Button Action
- (void)switchChanged:(id)sender {
#if TARGET_OS_OSX
    NSControlStateValue state = [sender state];
    if (state == NSControlStateValueOn) {
        [self.surface setDisableTouchEvent:NO];
    } else {
        [self.surface setDisableTouchEvent:YES];
    }
#elif TARGET_OS_IOS
    BOOL state = [sender isOn];
    [self.surface setDisableTouchEvent:!state];
#endif
}

@end
