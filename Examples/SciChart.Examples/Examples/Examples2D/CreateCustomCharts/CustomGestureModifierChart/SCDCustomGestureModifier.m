//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDCustomGestureModifier.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

/*
#import "SCDCustomGestureModifier.h"
#import <SciChart/SCIGestureModifierBase+Protected.h>
#import "SCDDoubleTouchDownGestureRecognizer.h"

@implementation SCDCustomGestureModifier {
    SCDDoubleTouchDownGestureRecognizer *_doubleTapGesture;
    CGPoint _initialLocation;
    CGFloat _scaleFactor;
    BOOL _canPan;
}

- (void)attachTo:(id<ISCIServiceContainer>)services {
    [super attachTo:services];
    
    _initialLocation = CGPointZero;
    _scaleFactor = -50.0;
    _canPan = NO;
    
    _doubleTapGesture = [[SCDDoubleTouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    
    if ([self.parentSurface isKindOfClass:[UIView class]]) {
        UIView *surfaceView = (UIView *)self.parentSurface;
        [surfaceView addGestureRecognizer:_doubleTapGesture];
    }
}

- (UIGestureRecognizer *)createGestureRecognizer {
    return [UIPanGestureRecognizer new];
}

- (void)internalHandleGesture:(UIGestureRecognizer *)gestureRecognizer {
    if (!_canPan) return;
    
    UIPanGestureRecognizer *gesture = (UIPanGestureRecognizer *)gestureRecognizer;
    UIView *parentView = self.parentSurface.modifierSurface.view;
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            _initialLocation = [gestureRecognizer locationInView:parentView];
            break;
        case UIGestureRecognizerStateChanged:
            [self performZoom:_initialLocation yScaleFactor:[gesture translationInView:parentView].y];
            [gesture setTranslation:CGPointZero inView:parentView];
            break;
        default:
            _canPan = NO;
            break;
    }
}

- (void)performZoom:(CGPoint)point yScaleFactor:(CGFloat)yScaleFactor {
    CGFloat fraction = yScaleFactor / _scaleFactor;
    for (int i = 0; i < self.xAxes.count; i++) {
        [self growAxis:self.xAxes[i] atPoint:point byFraction:fraction];
    }
}

- (void)growAxis:(id<ISCIAxis>)axis atPoint:(CGPoint)point byFraction:(CGFloat)fraction {
    CGFloat width = axis.layoutSize.width;
    CGFloat coord = width - point.x;
    
    double minFraction = (coord / width) * fraction;
    double maxFraction = (1 - coord / width) * fraction;
    
    [axis zoomByFractionMin:minFraction max:maxFraction];
}

- (void)handleDoubleTapGesture:(UILongPressGestureRecognizer *)gesture {
    _canPan = YES;
}

@end
*/
