//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDVitalSignsLayoutViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDVitalSignsLayoutViewController.h"
#import "SCIStackView.h"

@implementation SCDVitalSignsLayoutViewController {
    SCIView *_topView;
    SCIStackView *topStackView;
    
    SCIView *_bottomView;
    SCIStackView *bottomStackView;
    
    BOOL isPortrait;
    
    NSLayoutConstraint *_topViewHeightAnchorPortrait;
    NSLayoutConstraint *_topViewWidthAnchorLandscape;
    
    SCD_ECGView *_ecgView;
    SCD_NIBPView *_nibpView;
    SCD_SVView *_svView;
    SCD_SPO2View *_spo2View;
}

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    [SCIThemeManager applyTheme:theme toThemeable:self.surface];
}

- (void)loadView {
    [super loadView];
    
    self.view = [SCIView new];
    self.view.autoresizingMask = SCIAutoresizingFlexible;
    
    _topView = [self p_SCD_createTopView];
    _topView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_topView];
    
    _bottomView = [self p_SCD_createBottomView];
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_bottomView];
    
    _surface = [[self.associatedType alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _surface.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_surface];
    
#if TARGET_OS_OSX
    isPortrait = NO;
#elif TARGET_OS_IOS
    isPortrait = UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation);
#endif
    
    [self p_SCD_updateConstraints];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.platformBackgroundColor = _surface.backgroundBrushStyle.color;
}

#if TARGET_OS_IOS
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    isPortrait = size.height > size.width;
    
    [self p_SCD_updateConstraints];
}
#endif

- (SCIImageView *)heartImageView {
    return _ecgView.heartImageView;
}

- (SCILabel *)bpmValueLabel {
    return _ecgView.bpmValueLabel;
}

- (SCDStepProgressBar *)bpBar {
    return _nibpView.bpBar;
}

- (SCILabel *)bpValueLabel {
    return _nibpView.bpValueLabel;
}

- (SCILabel *)bvValueLabel {
    return _svView.bvValueLabel;
}

- (SCDStepProgressBar *)svBar1 {
    return _svView.svBar1;
}

- (SCDStepProgressBar *)svBar2 {
    return _svView.svBar2;
}

- (SCILabel *)spoClockValueLabel {
    return _spo2View.spoClockValueLabel;
}

- (SCILabel *)spoValueLabel {
    return _spo2View.spoValueLabel;
}

- (void)p_SCD_updateConstraints {
    [self p_SCD_removeAllConstraints];
    [self p_SCD_updateStackViewsAxis];
    
    //Portrait
    _topViewHeightAnchorPortrait = [_topView.heightAnchor constraintEqualToConstant:131];
    _topViewHeightAnchorPortrait.active = isPortrait;
    
    [_topView.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = isPortrait;
    [_surface.topAnchor constraintEqualToAnchor:_topView.bottomAnchor].active = isPortrait;
    [_surface.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = isPortrait;
    [_surface.bottomAnchor constraintEqualToAnchor:_bottomView.topAnchor].active = isPortrait;
    
    //Landscape
    _topViewWidthAnchorLandscape = [_topView.widthAnchor constraintEqualToConstant:200];
    _topViewWidthAnchorLandscape.active = !isPortrait;
    
    [_surface.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = !isPortrait;
    [_surface.trailingAnchor constraintEqualToAnchor:_topView.leadingAnchor].active = !isPortrait;
    [_surface.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = !isPortrait;
    [_bottomView.topAnchor constraintEqualToAnchor:_topView.bottomAnchor].active = !isPortrait;
    
    //Common
    [_topView.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [_topView.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [_surface.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [_bottomView.heightAnchor constraintEqualToAnchor:_topView.heightAnchor].active = YES;
    [_bottomView.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor].active = YES;
    [_bottomView.trailingAnchor constraintEqualToAnchor:_topView.trailingAnchor].active = YES;
    [_bottomView.leadingAnchor constraintEqualToAnchor:_topView.leadingAnchor].active = YES;
}

- (void)p_SCD_updateStackViewsAxis {
    topStackView.axis = [self p_SCD_getStackViewConstraintAxis];
    bottomStackView.axis = [self p_SCD_getStackViewConstraintAxis];
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

- (SCIView *)p_SCD_createTopView {
    _ecgView = [self p_SCD_createECGView];
    _nibpView = [self p_SCD_createNIBPView];
    
    topStackView = [SCIStackView new];
    [topStackView addArrangedSubview:_ecgView];
    [topStackView addArrangedSubview:_nibpView];

    return [self createContainerViewWithStackView:topStackView];
}

- (SCIView *)p_SCD_createBottomView {
    _svView = [self p_SCD_createSVView];
    _spo2View = [self p_SCD_createSPO2View];
    
    bottomStackView = [SCIStackView new];
    [bottomStackView addArrangedSubview:_svView];
    [bottomStackView addArrangedSubview:_spo2View];

    return [self createContainerViewWithStackView:bottomStackView];
}

- (SCD_ECGView *)p_SCD_createECGView {
    SCIColor *color = [SCIColor fromARGBColorCode:0xFF42B649];
    
    SCILabel *ecgLabel = [SCILabel new];
    ecgLabel.text = @"ECG";
    ecgLabel.textColor = color;
    ecgLabel.font = [SCIFont systemFontOfSize:18];
    
    SCIImage *image = [SCIImage imageNamed:@"icon.heart" inBundleWithIdentifier:@"com.scichart.examples.sources"];
    SCIImageView *heartImageView = [SCIImageView imageViewWithImage:image];
    heartImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [heartImageView addConstraints:@[
        [heartImageView.widthAnchor constraintEqualToConstant:24],
        [heartImageView.heightAnchor constraintEqualToConstant:24],
    ]];
    
    SCILabel *bottomLeftLabel = [SCILabel new];
    bottomLeftLabel.numberOfLines = 0;
    bottomLeftLabel.text = @"V1- 1.4MM\nST |+ 0.6 ||+ 0.9";
    bottomLeftLabel.textColor = color;
    bottomLeftLabel.font = [SCIFont systemFontOfSize:10];
    
    SCILabel *bottomRightLabel = [SCILabel new];
    bottomRightLabel.text = @"87";
    bottomRightLabel.textColor = color;
    bottomRightLabel.font = [SCIFont italicSystemFontOfSize:36];
    
    return [[SCD_ECGView alloc] initWithTopLeftView:ecgLabel topRightView:heartImageView bottomLeftView:bottomLeftLabel bottomRightView:bottomRightLabel];
}

- (SCD_NIBPView *)p_SCD_createNIBPView {
    SCIColor *color = [SCIColor fromARGBColorCode:0xFFFFFF00];
    
    SCILabel *topLeftLabel = [SCILabel new];
    topLeftLabel.text = @"NIBP";
    topLeftLabel.textColor = color;
    topLeftLabel.font = [SCIFont systemFontOfSize:18];
    
    SCILabel *topRightLabel = [SCILabel new];
    topRightLabel.numberOfLines = 0;
    topRightLabel.text = @"AUTO\n145/95";
    topRightLabel.textColor = color;
    topRightLabel.font = [SCIFont systemFontOfSize:18];
    
    SCDStepProgressBar *bpBar = [SCDStepProgressBar new];
    bpBar.translatesAutoresizingMaskIntoConstraints = NO;
    [bpBar addConstraints:@[
        [bpBar.heightAnchor constraintEqualToConstant:20],
    ]];
    
    SCILabel *bottomRightLabel = [SCILabel new];
    bottomRightLabel.text = @"87";
    bottomRightLabel.textColor = color;
    bottomRightLabel.font = [SCIFont italicSystemFontOfSize:36];
    
    return [[SCD_NIBPView alloc] initWithTopLeftView:topLeftLabel topRightView:topRightLabel bottomLeftView:bpBar bottomRightView:bottomRightLabel];
}

- (SCD_SVView *)p_SCD_createSVView {
    SCIColor *color = [SCIColor fromARGBColorCode:0xFFB0C4DE];
    
    SCILabel *topLeftLabel = [SCILabel new];
    topLeftLabel.text = @"SV";
    topLeftLabel.textColor = color;
    topLeftLabel.font = [SCIFont systemFontOfSize:18];
    
    SCILabel *topRightLabel = [SCILabel new];
    topRightLabel.numberOfLines = 0;
    topRightLabel.text = @"ML    100\n%*****  55";
    topRightLabel.textColor = color;
    topRightLabel.font = [SCIFont systemFontOfSize:18];
    
    SCDStepProgressBar *svBar1 = [SCDStepProgressBar new];
    svBar1.translatesAutoresizingMaskIntoConstraints = NO;
    [svBar1 addConstraints:@[
        [svBar1.widthAnchor constraintEqualToConstant:20]
    ]];
    
    SCDStepProgressBar *svBar2 = [SCDStepProgressBar new];
    svBar2.translatesAutoresizingMaskIntoConstraints = NO;
    [svBar2 addConstraints:@[
        [svBar2.widthAnchor constraintEqualToConstant:20]
    ]];
    
    SCIStackView *stackView = [SCIStackView new];
    stackView.axis = SCILayoutConstraintAxisHorizontal;
    stackView.distribution = SCIStackViewDistributionFillEqually;
    stackView.spacing = 3;
    [stackView addArrangedSubview:svBar1];
    [stackView addArrangedSubview:svBar2];
    
    SCILabel *bottomRightLabel = [SCILabel new];
    bottomRightLabel.text = @"87";
    bottomRightLabel.textColor = color;
    bottomRightLabel.font = [SCIFont italicSystemFontOfSize:36];
    
    return [[SCD_SVView alloc] initWithTopLeftView:topLeftLabel topRightView:topRightLabel bottomLeftView:stackView bottomRightView:bottomRightLabel];
}

- (SCD_SPO2View *)p_SCD_createSPO2View {
    SCIColor *color = [SCIColor fromARGBColorCode:0xFF6495ED];
    
    SCILabel *topLeftLabel = [SCILabel new];
    topLeftLabel.text = @"SPO2";
    topLeftLabel.textColor = color;
    topLeftLabel.font = [SCIFont systemFontOfSize:18];
    
    SCILabel *topRightLabel = [SCILabel new];
    topRightLabel.text = @"14:35";
    topRightLabel.textColor = color;
    topRightLabel.font = [SCIFont systemFontOfSize:14];
    
    SCILabel *bottomLeftLabel = [SCILabel new];
    bottomLeftLabel.numberOfLines = 0;
    bottomLeftLabel.text = @"71-\nRESP";
    bottomLeftLabel.textColor = color;
    bottomLeftLabel.font = [SCIFont systemFontOfSize:10];
    
    SCILabel *bottomRightLabel = [SCILabel new];
    bottomRightLabel.text = @"87";
    bottomRightLabel.textColor = color;
    bottomRightLabel.font = [SCIFont italicSystemFontOfSize:36];
    
    return [[SCD_SPO2View alloc] initWithTopLeftView:topLeftLabel topRightView:topRightLabel bottomLeftView:bottomLeftLabel bottomRightView:bottomRightLabel];
}

- (SCILayoutConstraintAxis)p_SCD_getStackViewConstraintAxis {
    return isPortrait ? SCILayoutConstraintAxisHorizontal : SCILayoutConstraintAxisVertical;
}

- (SCIView *)createContainerViewWithStackView:(SCIStackView *)stackView {
    stackView.distribution = SCIStackViewDistributionFillEqually;
    stackView.axis = SCILayoutConstraintAxisHorizontal;
    stackView.spacing = 0;
    
    SCIView *container = [SCIView new];
    
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [container addSubview:stackView];
    [container addConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:container.leadingAnchor],
        [stackView.topAnchor constraintEqualToAnchor:container.topAnchor],
        [stackView.trailingAnchor constraintEqualToAnchor:container.trailingAnchor],
        [stackView.bottomAnchor constraintEqualToAnchor:container.bottomAnchor]
    ]];
    
    return container;
}

@end
