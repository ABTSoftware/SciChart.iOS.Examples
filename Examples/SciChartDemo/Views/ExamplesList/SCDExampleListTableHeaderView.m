//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

- (UILabel *)label {
    if (_label == nil) {
        _label = [UILabel new];
        _label.translatesAutoresizingMaskIntoConstraints = NO;
        _label.textColor = [UIColor colorNamed:@"color.text.light"];
    }
    return _label;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.label];
        
        self.backgroundView = [UIView new];
        self.backgroundView.backgroundColor = [UIColor colorNamed:@"color.tableview.background"];
        [self.label.topAnchor constraintEqualToAnchor:self.topAnchor constant:8].active = YES;
        [self.label.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-8].active = YES;
        [self.label.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:17].active = YES;
        [self.label.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-17].active = YES;
    }
    
    return self;
}

@end
