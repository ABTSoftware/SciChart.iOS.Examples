//
//  ExampleListCellView.m
//  SciChartDemo.Mac
//
//  Created by Black Thornvision on 04.03.2020.
//  Copyright © 2020 SciChart Ltd. All rights reserved.
//

#import "ExampleListCellView.h"
#import "ExampleListLabel.h"

@interface ExampleListCellView ()

@property (strong, nonatomic, readonly) NSImageView *icon;
@property (strong, nonatomic, readonly) ExampleListLabel *title;
@property (strong, nonatomic, readonly) ExampleListLabel *subtitle;

@end

@implementation ExampleListCellView

@synthesize icon = _icon;
@synthesize title = _title;
@synthesize subtitle = _subtitle;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_SCD_setupView];
    }
    return self;
}

- (NSImageView *)icon {
    if (_icon == nil) {
        _icon = [NSImageView new];
        _icon.translatesAutoresizingMaskIntoConstraints = NO;
        [NSLayoutConstraint activateConstraints:@[
            [_icon.widthAnchor constraintEqualToConstant:30],
            [_icon.heightAnchor constraintEqualToAnchor:_icon.widthAnchor multiplier:1],
        ]];
    }
    return _icon;
}

- (NSTextField *)title {
    if (_title == nil) {
        _title = [[ExampleListLabel alloc] initWithFontSize:13];
    }
    return _title;
}

- (NSTextField *)subtitle {
    if (_subtitle == nil) {
        _subtitle = [[ExampleListLabel alloc] initWithFontSize:10];
    }
    return _subtitle;
}

- (void)p_SCD_setupView {
    self.wantsLayer = YES;
    self.layer.backgroundColor = NSColor.clearColor.CGColor;
    
    NSStackView *textStackView = [NSStackView stackViewWithViews:@[self.title, self.subtitle]];
    textStackView.distribution = NSStackViewDistributionFillProportionally;
    textStackView.alignment = NSLayoutAttributeLeading;
    textStackView.orientation = NSUserInterfaceLayoutOrientationVertical;
    textStackView.spacing = -4;

    NSStackView *stackView = [NSStackView stackViewWithViews:@[self.icon, textStackView]];
    stackView.orientation = NSUserInterfaceLayoutOrientationHorizontal;
    stackView.spacing = 4;

    [self addSubview:stackView];

    [NSLayoutConstraint activateConstraints:@[
        [stackView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:4],
        [stackView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-4],
        [stackView.topAnchor constraintEqualToAnchor:self.topAnchor constant:4],
        [stackView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-4]
    ]];
}

- (void)updateWithExampleItem:(SCDExampleItem *)menuItem {
    self.icon.image = menuItem.icon;
    self.title.stringValue = menuItem.title;
    self.subtitle.stringValue = menuItem.subtitle;
    
    self.toolTip = self.subtitle.stringValue;
}

@end
