//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDGradientView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDGradientView.h"

@implementation SCDGradientView

+ (Class)layerClass {
    return CAGradientLayer.class;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupLayer];
    }
    return self;
}

- (void)setupLayer {
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    UIColor *start = [UIColor colorWithRed:0x15/255.f green:0x15/255.f blue:0x15/255.f alpha:1.f];
    UIColor *end = [UIColor colorWithRed:0x28/255.f green:0x29/255.f blue:0x29/255.f alpha:1.f];
    gradientLayer.colors = @[(id)start.CGColor, (id)end.CGColor];
}

@end
