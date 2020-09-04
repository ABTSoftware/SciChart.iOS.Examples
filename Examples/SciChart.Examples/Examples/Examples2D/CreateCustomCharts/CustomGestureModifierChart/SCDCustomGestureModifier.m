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

#import "SCDCustomGestureModifier.h"
#import <SciChart/SCIGestureModifierBase+Protected.h>
#import "SCDDoubleTouchDownGestureRecognizer.h"

@implementation SCDCustomGestureModifier {
#if TARGET_OS_IOS
    SCDDoubleTouchDownGestureRecognizer *_doubleTapGesture;
#endif
    CGPoint _initialLocation;
    CGFloat _scaleFactor;
    BOOL _canPan;
}

- (void)attachTo:(id<ISCIServiceContainer>)services {
    [super attachTo:services];
    
    _initialLocation = CGPointZero;
    _scaleFactor = -50.0;
#if TARGET_OS_OSX
    _canPan = YES;
#elif TARGET_OS_IOS
    _canPan = NO;
    _doubleTapGesture = [[SCDDoubleTouchDownGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTapGesture:)];
    
    if ([self.parentSurface isKindOfClass:[SCIView class]]) {
        SCIView *surfaceView = (SCIView *)self.parentSurface;
        [surfaceView addGestureRecognizer:_doubleTapGesture];
    }
#endif
}

#if TARGET_OS_IOS
- (void)onGestureEndedWithArgs:(SCIGestureModifierEventArgs *)args {
    _canPan = NO;
}

- (void)onGestureCancelledWithArgs:(SCIGestureModifierEventArgs *)args {
    _canPan = NO;
}

- (void)handleDoubleTapGesture:(SCDDoubleTouchDownGestureRecognizer *)gesture {
    _canPan = YES;
}
#endif

- (void)onGestureBeganWithArgs:(SCIGestureModifierEventArgs *)args {
    if (!_canPan) return;
    
    SCIPanGestureRecognizer *gesture = (SCIPanGestureRecognizer *)args.gestureRecognizer;
    SCIView *parentView = self.parentSurface.modifierSurface.view;
    
    _initialLocation = [gesture locationInView:parentView];
}

- (void)onGestureChangedWithArgs:(SCIGestureModifierEventArgs *)args {
    if (!_canPan) return;
    
    SCIPanGestureRecognizer *gesture = (SCIPanGestureRecognizer *)args.gestureRecognizer;
    SCIView *parentView = self.parentSurface.modifierSurface.view;
     
    CGFloat translationY = [gesture translationInView:parentView].y;
    [self p_SCD_performZoom:_initialLocation yScaleFactor:translationY];
    [gesture setTranslation:CGPointZero inView:parentView];
}

- (SCIGestureRecognizer *)createGestureRecognizer {
    return [SCIPanGestureRecognizer new];
}

- (void)p_SCD_performZoom:(CGPoint)point yScaleFactor:(CGFloat)yScaleFactor {
    CGFloat fraction = yScaleFactor / _scaleFactor;
    for (NSUInteger i = 0, count = self.xAxes.count; i < count; i++) {
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

@end
