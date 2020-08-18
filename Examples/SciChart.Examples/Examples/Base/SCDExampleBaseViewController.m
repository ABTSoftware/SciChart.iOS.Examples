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

#import "SCDExampleBaseViewController.h"
#import "SCDSingleChartViewController.h"
#import "SCDToolbarButtonsGroup.h"
#import "SCDToolbarButton.h"
#import "SCDConstants.h"
#import "SCDFlipAxesCoordsChartModifier.h"
#import "SCDCustomRotateChartModifier.h"
#import <SciChart/NSObject+ExceptionUtil.h>
#import <SciChart/ISCIChartSurface.h>
#import <SciChart/ISCIChartController.h>

@interface SCDExampleBaseViewController()
@property (strong, nonatomic, readonly) SCIView *surface;
@end

@implementation SCDExampleBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self commonInit];
#if TARGET_OS_IOS
        self.viewRespectsSystemMinimumLayoutMargins = NO;
#endif
    }
    return self;
}

- (void)loadView { }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.platformBackgroundColor = [SCIColor fromABGRColorCode:0xFF1C1C1C];
#if TARGET_OS_IOS
    self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
    
    [self initExample];
}

- (void)commonInit { }

- (void)initExample {
    @throw [self notImplementedExceptionFor:_cmd];
}

+ (SCIModifierGroup *)createDefaultModifiers {
    SCIZoomPanModifier *zoomPan = [SCIZoomPanModifier new];
//    zoomPan.buttonMask = SCIButtonMask_Other;
    
    SCIZoomExtentsModifier *zoomExtents = [SCIZoomExtentsModifier new];
//    zoomExtents.buttonMask = SCIButtonMask_Right;
    
    SCIModifierGroup *modifierGroup = [[SCIModifierGroup alloc] initWithChildModifiers:@[
        [SCIPinchZoomModifier new],
        zoomPan,
        zoomExtents
    ]];
    
    return modifierGroup;
}

+ (SCIModifierGroup3D *)createDefaultModifiers3D {
    SCIOrbitModifier3D *orbit = [SCIOrbitModifier3D new];
//    orbit.buttonMask = SCIButtonMask_Other;
//    orbit.gestureRecognizer.buttonMask = SCIMouseButtonMask_Right;
    
    SCIZoomExtentsModifier3D *zoomExtents = [SCIZoomExtentsModifier3D new];
//    zoomExtents.buttonMask = SCIButtonMask_Right;
    
    SCIModifierGroup3D *modifierGroup3D = [[SCIModifierGroup3D alloc] initWithChildModifiers:@[
//        [[SCIFreeLookModifier3D alloc] initWithDefaultNumberOfTouches:2]
        [SCIPinchZoomModifier3D new],
        orbit,
        zoomExtents
    ]];
    return modifierGroup3D;
}

- (BOOL)showDefaultModifiersInToolbar {
    if ([self.surface isKindOfClass:SCIChartSurface3D.class] || !self.surface) return NO;
    
    return YES;
}

- (NSArray<id<ISCDToolbarItem>> *)generateToolbarItems {
    NSMutableArray<id<ISCDToolbarItem>> *toolbarItems = [NSMutableArray new];
    
    [self p_SCD_addToolbarItems:[self provideExampleSpecificToolbarItems] to:toolbarItems];
    if (self.showDefaultModifiersInToolbar) {
        [toolbarItems addObjectsFromArray:[self p_SCD_getDefaultModifiers]];
    }
    
    [toolbarItems addObject:[self p_SCD_createDevSettingsItem]];
    
    return toolbarItems;
}

- (void)p_SCD_addToolbarItems:(NSArray<id<ISCDToolbarItem>> *)items to:(NSMutableArray<id<ISCDToolbarItem>> *)collection {
    for (NSUInteger i = 0, count = items.count; i < count; i++) {
        id<ISCDToolbarItem> toolbarItem = items[i];
        if (toolbarItem.identifier == nil) {
            toolbarItem.identifier = [NSString stringWithFormat:@"%@ - %d", TOOLBAR_EXAMPLE_SPECIFIC, (int)i];
        }
        [collection addObject:toolbarItem];
    }
}

- (NSArray<id<ISCDToolbarItem>> *)provideExampleSpecificToolbarItems {
    return @[];
}

- (NSArray<id<ISCDToolbarItem>> *)p_SCD_getDefaultModifiers {
    SCDFlipAxesCoordsChartModifier *flipCoordinateModifier = [SCDFlipAxesCoordsChartModifier new];
    SCDCustomRotateChartModifier *rotateChartModifier = [SCDCustomRotateChartModifier new];
    
    [((id<ISCIChartSurface>)self.surface).chartModifiers addAll:flipCoordinateModifier, rotateChartModifier, nil];

    id<ISCDToolbarItem> item = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarButton alloc] initWithTitle:@"Zoom extents" image:[SCIImage imageNamed:@"chart.modifier.zoomextents"] andAction:^{
            [(id<ISCIChartController>)self.surface animateZoomExtentsWithDuration:SCI_DEFAULT_ANIMATION_DURATION];
        }],
        [[SCDToolbarButton alloc] initWithTitle:@"Flip Axes X" image:[SCIImage imageNamed:@"chart.modifier.flipX"] andAction:^{
            [flipCoordinateModifier flipXAxes];
        }],
        [[SCDToolbarButton alloc] initWithTitle:@"Flip Axes Y" image:[SCIImage imageNamed:@"chart.modifier.flipY"] andAction:^{
            [flipCoordinateModifier flipYAxes];
        }],
        [[SCDToolbarButton alloc] initWithTitle:@"Rotate" image:[SCIImage imageNamed:@"chart.modifier.rotate"] andAction:^{
            [rotateChartModifier rotateChart];
        }],
    ]];
    item.identifier = TOOLBAR_EXAMPLE_DEFAULT;
        
    return @[item];
}

- (id<ISCDToolbarItem>)p_SCD_createDevSettingsItem {
    __weak typeof(self) wSelf = self;
    
    SCDToolbarButtonsGroup *settingsToolbar = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarItem alloc] initWithTitle:@"Developer settings" image:[SCIImage imageNamed:@"icon.hammer"] andAction:^{ [wSelf openDevSettings]; }]
    ]];
    settingsToolbar.identifier = TOOLBAR_DEV_SETTINGS;
    
    return settingsToolbar;
}

- (void)openDevSettings {
    // Stub for opening Developer Settings
}

@end
