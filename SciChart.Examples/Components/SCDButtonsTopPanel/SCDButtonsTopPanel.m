//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDButtonsTopPanel.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDButtonsTopPanel.h"
#import "SCDPanelButton.h"
#import <SciChart/SCIEdgeInsets.h>

@implementation SCDButtonsTopPanel

- (instancetype)initWithToolbarItems:(NSArray<id<ISCDToolbarItemModel>> *)toolbarItems {
    NSMutableArray<SCIView *> *buttons = [NSMutableArray new];
    for (id<ISCDToolbarItemModel> item in toolbarItems) {
        SCDPanelButton *button = [[SCDPanelButton alloc] initWithTitle:item.title action:item.action];
        [buttons addObject:button];
    }
    
    return [self initWithButtons:buttons];
}

- (instancetype)initWithButtons:(NSArray<SCIView *> *)buttons {
    self = [super init];
    if (self) {
        self.spacing = 8;
        SCIEdgeInsets padding = (SCIEdgeInsets){ .left = 8, .top = 8, .right = 8, .bottom = 8 };
#if TARGET_OS_OSX
        self.edgeInsets = padding;
#elif TARGET_OS_IOS
        self.layoutMarginsRelativeArrangement = YES;
        self.layoutMargins = padding;
        self.distribution = UIStackViewDistributionFillProportionally;
#endif
        for (NSUInteger i = 0, count = buttons.count; i < count; i++) {
            [self addArrangedSubview:buttons[i]];
        }
    }
    return self;
}

@end
