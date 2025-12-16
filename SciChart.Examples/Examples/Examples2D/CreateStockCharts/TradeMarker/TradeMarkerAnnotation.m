//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2025. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TradeMarkerAnnotation.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************


#import "TradeMarkerAnnotation.h"

@implementation TradeMarkerAnnotation

- (instancetype)initWithIndex:(NSDate *)index
                        isBuy:(BOOL)isBuy
                        yPoint:(double)yPoint
                        price:(double)price {
    self = [super init];
    if (self) {
        [self setX1:index];
        [self setY1:@(yPoint)];

        self.verticalAnchorPoint = isBuy ? SCIVerticalAnchorPoint_Top
                                         : SCIVerticalAnchorPoint_Bottom;
        self.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
        
        SCIImageView *imgArrow = [[SCIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        imgArrow.image = [SCIImage imageNamed:(isBuy ? @"image.arrow.green" : @"image.arrow.red")];
        
#if TARGET_OS_OSX
        [imgArrow setWantsLayer:YES];
        imgArrow.layer.contentsGravity = kCAGravityResizeAspect;

#else
        imgArrow.contentMode = UIViewContentModeScaleAspectFit;
#endif
        
        self.isEditable = YES;
        self.userInfo = [[NSMutableArray alloc] init];
        [self.userInfo addObject:@{ @"isBuy": @(isBuy), @"price": @(price)}];
        
        self.customView = imgArrow;
    }
    return self;
}

- (void)onEvent:(SCIGestureModifierEventArgs *)args {
    CGPoint hitPoint = ToPointRelativeToBounds(args.location,
                                               self.annotationCoordinates.annotationsSurfaceBounds);

    if ([self isPointWithinBounds:hitPoint]) {
        if ([self.delegate respondsToSelector:@selector(didTradeAnnotationTapped:atPoint:)]) {
            [self.delegate didTradeAnnotationTapped:self atPoint:hitPoint];
        }
    }
}

@end
