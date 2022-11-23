//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDExampleListTableHeaderView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDExampleListTableHeaderView.h"

@implementation SCDExampleListTableHeaderView

+ (NSString *)reuseId { return @"SCDExampleTableHeader"; }

@synthesize label = _label;
@synthesize seperatorView = _seperatorView;

- (UILabel *)label {
    if (_label == nil) {
        _label = [UILabel new];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.textColor = [UIColor colorNamed:@"color.text.light"];
    }
    return _label;
}

- (UIView *)seperatorView {
    if (_seperatorView == nil) {
        _seperatorView = [UIView new];
        _seperatorView.backgroundColor = [UIColor colorWithRed:(76/255.f) green:(81/255.f) blue:(86/255.f) alpha:0.3];
        _seperatorView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _seperatorView;
}


- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.label];
        [self addSubview:self.seperatorView];
        
        self.backgroundView = [UIView new];
//      self.backgroundView.backgroundColor = [UIColor colorNamed:@"color.tableview.background"];

        [self.label.centerYAnchor constraintEqualToAnchor:self.centerYAnchor].active = YES;
        [self.label.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
        [self.label.heightAnchor constraintEqualToConstant:40].active =YES;
        
        [self.seperatorView.topAnchor constraintEqualToAnchor:self.label.bottomAnchor].active = YES;
        [self.seperatorView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
        [self.seperatorView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:20].active = YES;
        [self.seperatorView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-20].active = YES;
        [self.seperatorView.heightAnchor constraintEqualToConstant:1].active =YES;
        
    }
    
    return self;
}

@end
