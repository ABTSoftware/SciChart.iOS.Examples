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

@end

@implementation SCDExampleTableCell

+ (NSString *)reuseId { return NSStringFromClass(SCDExampleTableCell.class); }

@synthesize icon = _icon;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (UIImageView *)icon {
    if (_icon == nil) {
        _icon = [UIImageView new];
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _icon;
}

- (UILabel *)title {
    if (_title == nil) {
        _title = [UILabel new];
        _title.font = [UIFont fontWithName:@"Montserrat-Light" size:17];
        _title.textColor = [UIColor colorNamed:@"color.text.light"];
        _title.translatesAutoresizingMaskIntoConstraints = NO;
        [_title setContentHuggingPriority:1001 forAxis:UILayoutConstraintAxisVertical];
    }
    return _title;
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
    self.tintColor = [UIColor colorNamed:@"color.text.light"];
    self.backgroundColor = [UIColor colorNamed:@"color.tableitem.background"];
        
    [self addSubview:self.icon];
    [self addSubview:self.title];
    [self addSubview:self.subtitle];
    
    [self.icon.topAnchor constraintEqualToAnchor:self.title.topAnchor constant:-4].active = YES;
    [self.icon.bottomAnchor constraintEqualToAnchor:self.subtitle.bottomAnchor constant:4].active = YES;
    [self.icon.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor constant:17].active = YES;
    [self.icon.widthAnchor constraintEqualToAnchor:self.icon.heightAnchor multiplier:1].active = YES;
    
    [self.title.topAnchor constraintEqualToAnchor:self.topAnchor constant:8].active = YES;
    [self.title.leadingAnchor constraintEqualToAnchor:self.icon.trailingAnchor constant:4].active = YES;
    [self.title.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-17].active = YES;
    
    [self.subtitle.topAnchor constraintEqualToAnchor:self.title.bottomAnchor].active = YES;
    [self.subtitle.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8].active = YES;
    [self.subtitle.leadingAnchor constraintEqualToAnchor:self.icon.trailingAnchor constant:4].active = YES;
    [self.subtitle.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor constant:-17].active = YES;
}

- (void)updateWithMenuItem:(id<ISCDMenuItem>)menuItem {
    self.icon.image = menuItem.icon;
    self.title.text = menuItem.title;
    self.subtitle.text = menuItem.subtitle;
}

@end
