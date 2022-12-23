//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMenuItemCell.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMenuItemCell.h"

@interface SCDMenuItemCell ()

@property (strong, nonatomic, readonly) UIView *container;
@property (strong, nonatomic, readonly) UIImageView *icon;
@property (strong, nonatomic, readonly) UILabel *title;
@property (strong, nonatomic, readonly) UILabel *subtitle;

@end

@implementation SCDMenuItemCell

+ (NSString *)reuseId { return NSStringFromClass(SCDMenuItem.class); }

@synthesize container = _container;
@synthesize icon = _icon;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (UIView *)container {
    if (_container == nil) {
        _container = [UIView new];
        _container.backgroundColor = [UIColor colorWithRed:(23/255.f) green:(36/255.f) blue:(61/255.f) alpha:0.7];
        _container.layer.cornerRadius = 12;
        _container.layer.borderWidth = 1;
        _container.layer.borderColor = [UIColor colorWithRed:(76/255.f) green:(81/255.f) blue:(86/255.f) alpha:0.7].CGColor;
        _container.layer.shadowOpacity = 0.7;
        _container.layer.shadowRadius = 1;
        _container.layer.shadowColor = [UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:0.16].CGColor;
        _container.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _container;
}

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [UIImageView new];
        _icon.tintColor = UIColor.whiteColor;
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _icon;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [UILabel new];
        _title.font = [UIFont fontWithName:@"Inter-Bold" size:16];
        _title.textColor = [UIColor colorWithRed:(71/255.f) green:(189/255.f) blue:(230/255.f) alpha:1.0];
        _title.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _title;
}

- (UILabel *)subtitle {
    if (_subtitle == nil) {
        _subtitle = [UILabel new];
        _subtitle.font = [UIFont fontWithName:@"Lato-Light" size:12];
        _subtitle.textColor = [UIColor colorWithRed:(255/255.f) green:(255/255.f) blue:(255/255.f) alpha:1.0];
        _subtitle.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _subtitle;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self p_SCD_setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_SCD_setupView];
    }
    return self;
}

- (void)p_SCD_setupView {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    
    [self addSubview:self.container];
    [self.container.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.container.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
    [self.container.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16].active = YES;
    [self.container.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16].active = YES;
    [self.container.heightAnchor constraintEqualToConstant:150].active = YES;

    [self updateCell];
}

-(void)updateCell {
    
    [self.container addSubview:self.icon];
//    [self.icon.widthAnchor constraintEqualToConstant:100].active = YES;
//    [self.icon.heightAnchor constraintEqualToConstant:100].active = YES;

    [self.container addSubview:self.title];
    [self.container addSubview:self.subtitle];
    
    UIStackView *stackView = [[UIStackView alloc] init];
    UIStackView *stackViewT = [[UIStackView alloc] init];
    
    if (UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation)) {
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentLeading;
        stackView.spacing = 4;
        [stackView addArrangedSubview:self.title];
        [stackView addArrangedSubview:self.subtitle];
        
        stackViewT.axis = UILayoutConstraintAxisHorizontal;
        stackViewT.distribution = UIStackViewDistributionEqualSpacing;
        stackViewT.alignment = UIStackViewAlignmentCenter;
        stackViewT.spacing = 20;
        [stackViewT addArrangedSubview:self.icon];
        [stackViewT addArrangedSubview:stackView];
        
        
    }else {
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.distribution = UIStackViewDistributionEqualSpacing;
        stackView.alignment = UIStackViewAlignmentCenter;
        stackView.spacing = 8;
        [stackView addArrangedSubview:self.title];
        [stackView addArrangedSubview:self.subtitle];
       
        stackViewT.axis = UILayoutConstraintAxisVertical;
        stackViewT.distribution = UIStackViewDistributionEqualSpacing;
        stackViewT.alignment = UIStackViewAlignmentCenter;
        stackViewT.spacing = 5;
        [stackViewT addArrangedSubview:self.icon];
        [stackViewT addArrangedSubview:stackView];
        
    }
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    [stackViewT addSubview:stackView];

    stackViewT.translatesAutoresizingMaskIntoConstraints = NO;
    [self.container addSubview:stackViewT];
    
    [stackViewT.centerYAnchor constraintEqualToAnchor:self.container.centerYAnchor].active = YES;
    [stackViewT.centerXAnchor constraintEqualToAnchor:self.container.centerXAnchor].active = YES;

}

- (void)updateWithMenuItem:(id<ISCDMenuItem>)menuItem {
    self.icon.image = menuItem.icon;
    self.title.text = menuItem.title;
    self.subtitle.text = menuItem.subtitle;
   
}

@end
