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
        _title.font = [UIFont fontWithName:@"Montserrat-SemiBold" size:17];
        _title.textColor = [UIColor colorNamed:@"color.primary.green"];
        _title.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _title;
}

- (UILabel *)subtitle {
    if (_subtitle == nil) {
        _subtitle = [UILabel new];
        _subtitle.font = [UIFont fontWithName:@"Montserrat-Light" size:17];
        _subtitle.textColor = [UIColor colorNamed:@"color.text.light"];
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
    [self.container.leadingAnchor constraintGreaterThanOrEqualToAnchor:self.leadingAnchor].active = YES;
    [self.container.trailingAnchor constraintLessThanOrEqualToAnchor:self.trailingAnchor].active = YES;
    
    [self.container addSubview:self.icon];
    [self.icon.centerXAnchor constraintEqualToAnchor:_container.centerXAnchor].active = YES;
    [self.icon.topAnchor constraintEqualToAnchor:_container.topAnchor].active = YES;
    [self.icon.widthAnchor constraintEqualToConstant:100].active = YES;
    [self.icon.heightAnchor constraintEqualToConstant:100].active = YES;
    
    [self.container addSubview:self.title];
    [self.title.topAnchor constraintEqualToAnchor:self.icon.bottomAnchor constant:16].active = YES;
    [self.title.centerXAnchor constraintEqualToAnchor:self.container.centerXAnchor].active = YES;
    
    [self.container addSubview:self.subtitle];
    [self.subtitle.leadingAnchor constraintEqualToAnchor:self.container.leadingAnchor].active = YES;
    [self.subtitle.topAnchor constraintEqualToAnchor:self.title.bottomAnchor].active = YES;
    [self.subtitle.trailingAnchor constraintEqualToAnchor:self.container.trailingAnchor].active = YES;
    [self.subtitle.bottomAnchor constraintEqualToAnchor:self.container.bottomAnchor].active = YES;
}

- (void)updateWithMenuItem:(id<ISCDMenuItem>)menuItem {
    self.icon.image = menuItem.icon;
    self.title.text = menuItem.title;
    self.subtitle.text = menuItem.subtitle;
}

@end
