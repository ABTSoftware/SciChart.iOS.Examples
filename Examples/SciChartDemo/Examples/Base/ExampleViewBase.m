//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ExampleViewBase.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
#import "ExampleViewBase.h"
#import "SingleChartLayout.h"

@implementation ExampleViewBase

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setubXib];
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setubXib];
        [self commonInit];
    }
    return self;
}

- (Class)exampleViewType {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)] userInfo:nil];
}

- (void)setubXib {
    Class class = self.exampleViewType;
    NSString * str = NSStringFromClass(class);
    NSArray * nibs = [NSBundle.mainBundle loadNibNamed:str owner:self options:nil];
    UIView * view = [nibs objectAtIndex:0];
    view.frame = self.bounds;
    [self addSubview:view];
    
    [self initExample];
}

- (void)commonInit { }

- (void)initExample {
    [NSException raise:NSInternalInconsistencyException format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if (_needsHideSideBarMenu) {
        _needsHideSideBarMenu([touches anyObject].view);
    }
}

+ (SCIModifierGroup *)createDefaultModifiers {
    SCIZoomPanModifier *zoomPan = [SCIZoomPanModifier new];
    zoomPan.receiveHandledEvents = YES;
    
    SCIModifierGroup *modifierGroup = [SCIModifierGroup new];
    [modifierGroup.childModifiers add:[SCIPinchZoomModifier new]];
    [modifierGroup.childModifiers add:zoomPan];
    [modifierGroup.childModifiers add:[SCIZoomExtentsModifier new]];
    
    return modifierGroup;
}

+ (SCIModifierGroup3D *)createDefault3DModifiers {
    SCIModifierGroup3D *modifierGroup3D = [SCIModifierGroup3D new];
    [modifierGroup3D.childModifiers add:[SCIPinchZoomModifier3D new]];
    [modifierGroup3D.childModifiers add:[[SCIFreeLookModifier3D alloc] initWithDefaultNumberOfTouches:2]];
    [modifierGroup3D.childModifiers add:[SCIZoomExtentsModifier3D new]];
    [modifierGroup3D.childModifiers add:[SCIOrbitModifier3D new]];
    
    return modifierGroup3D;
}

@end
