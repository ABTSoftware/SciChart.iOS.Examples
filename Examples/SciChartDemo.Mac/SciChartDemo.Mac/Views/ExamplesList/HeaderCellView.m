//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// HeaderCellView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "HeaderCellView.h"
#import "ExampleListLabel.h"

@interface HeaderCellView ()

@property (strong, nonatomic, readonly) ExampleListLabel *title;

@end

@implementation HeaderCellView

@synthesize title = _title;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_SCD_setupView];
    }
    return self;
}

- (NSTextField *)title {
    if (_title == nil) {
        _title = [[ExampleListLabel alloc] initWithFont:[NSFont fontWithName:@"Montserrat-SemiBold" size:13]];
    }
    return _title;
}

- (void)p_SCD_setupView {
    [self addSubview:self.title];
    self.title.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.title.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:4],
        [self.title.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:4],
        [self.title.topAnchor constraintEqualToAnchor:self.topAnchor constant:4],
        [self.title.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4]
    ]];
}

- (void)updateWithTitle:(NSString *)title {
    self.title.stringValue = title;
}

@end
