//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDExampleTableCell.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleTableCell.h"

@interface SCDExampleTableCell ()

@property (strong, nonatomic, readonly) UIImageView *icon;
@property (strong, nonatomic, readonly) UILabel *title;
@property (strong, nonatomic, readonly) UILabel *subtitle;
@property (strong, nonatomic, readonly) UIView *container;

@end

@implementation SCDExampleTableCell

+ (NSString *)reuseId { return NSStringFromClass(SCDExampleTableCell.class); }

@synthesize icon = _icon;
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize container = _container;

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [UIImageView new];
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
//        _icon.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    }
    return _icon;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [UILabel new];
        _title.font = [UIFont fontWithName:@"Inter-Regular" size:16];
        _title.textColor = UIColor.whiteColor;
        _title.lineBreakMode = NSLineBreakByWordWrapping;
        _title.numberOfLines = 0;
        _title.translatesAutoresizingMaskIntoConstraints = NO;
        [_title setContentHuggingPriority:1001 forAxis:UILayoutConstraintAxisVertical];
    }
    return _title;
}
- (UIView *)container {
    if (_container == nil) {
        _container = [UIView new];
        _container.backgroundColor = [UIColor colorWithRed:(42/255.f) green:(56/255.f) blue:(82/255.f) alpha:1.0];
        _container.layer.cornerRadius = 12;
        _container.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _container;
}

- (UILabel *)subtitle {
    if (_subtitle == nil) {
        _subtitle = [UILabel new];
        _subtitle.font = [UIFont fontWithName:@"Montserrat-Light" size:13];
        _subtitle.textColor = [UIColor colorNamed:@"color.text.light"];
        _subtitle.translatesAutoresizingMaskIntoConstraints = NO;
        [_subtitle setContentHuggingPriority:1001 forAxis:UILayoutConstraintAxisVertical];
    }
    return _subtitle;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self p_SCD_setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self p_SCD_setupView];
    }
    return self;
}

- (void)p_SCD_setupView {
    self.insetsLayoutMarginsFromSafeArea = YES;
    self.backgroundColor = UIColor.clearColor;
    [self addSubview:self.container];
    [self addSubview:self.icon];
    [self addSubview:self.title];
    
    [self.container.topAnchor constraintEqualToAnchor:self.topAnchor constant: 20].active = YES;
    [self.container.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:0].active = YES;
    [self.container.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:20].active = YES;
    [self.container.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-20].active = YES;
    [self.container.heightAnchor constraintEqualToConstant:70].active = YES;
    
   
    UIStackView *stackViewT = [[UIStackView alloc] init];
    stackViewT.axis = UILayoutConstraintAxisHorizontal;
    stackViewT.distribution = UIStackViewDistributionFill;
    stackViewT.alignment = UIStackViewAlignmentCenter;
    stackViewT.spacing = 20;
    [stackViewT addArrangedSubview:self.icon];
    [stackViewT addArrangedSubview:self.title];
    
    stackViewT.translatesAutoresizingMaskIntoConstraints = false;
    [self.container addSubview:stackViewT];
    
    [self.icon.widthAnchor constraintEqualToConstant:50].active = YES;
    [self.icon.heightAnchor constraintEqualToConstant:50].active = YES;
    
    [stackViewT.centerYAnchor constraintEqualToAnchor:self.container.centerYAnchor].active = YES;
    [stackViewT.leadingAnchor constraintEqualToAnchor:self.container.leadingAnchor constant:20].active = YES;
    [stackViewT.trailingAnchor constraintEqualToAnchor:self.container.trailingAnchor constant:-20].active = YES;
}

- (void)updateWithMenuItem:(id<ISCDMenuItem>)menuItem {
    self.icon.image = menuItem.icon;
    self.icon.image = [menuItem.icon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.title.text = menuItem.title;
    self.subtitle.text = menuItem.subtitle;
}

@end
