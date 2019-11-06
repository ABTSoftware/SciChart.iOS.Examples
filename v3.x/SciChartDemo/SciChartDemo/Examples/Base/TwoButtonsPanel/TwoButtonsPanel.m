//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TwoButtonsPanel.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "TwoButtonsPanel.h"

@interface TwoButtonsPanel()

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation TwoButtonsPanel


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    [[NSBundle mainBundle] loadNibNamed:@"TwoButtonsPanel" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake(UIScreen.mainScreen.bounds.size.width, 64.0);
}

@end
