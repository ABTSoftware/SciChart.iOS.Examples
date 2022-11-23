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

static SCIChartTheme _chartTheme = SCIChartThemeNavy;

+ (SCIChartTheme)chartTheme {
    return _chartTheme;
}

+ (void)setChartTheme:(SCIChartTheme)chartTheme {
    _chartTheme = chartTheme;
}

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

- (void)commonInit {
    // Could be overriden in derived classes, to initialize common, non-chart things.
}

- (void)loadView { }

- (void)viewDidLoad {
    [super viewDidLoad];
    
#if TARGET_OS_IOS
    self.edgesForExtendedLayout = UIRectEdgeNone;
#endif
    
    [self initExample];
    [self tryUpdateChartTheme:_chartTheme];
}

- (void)initExample {
    @throw [self notImplementedExceptionFor:_cmd];
}

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    // Also, should be overriden in specific examples, to reflect theme changes.
}

+ (SCIModifierGroup *)createDefaultModifiers {
    SCIModifierGroup *modifierGroup = [[SCIModifierGroup alloc] initWithChildModifiers:@[
        [SCIPinchZoomModifier new],
        [SCIZoomPanModifier new],
        [SCIZoomExtentsModifier new]
    ]];
    
    return modifierGroup;
}

+ (SCIModifierGroup3D *)createDefaultModifiers3D {
    SCIModifierGroup3D *modifierGroup3D = [[SCIModifierGroup3D alloc] initWithChildModifiers:@[
#if TARGET_OS_IOS
        [[SCIFreeLookModifier3D alloc] initWithDefaultNumberOfTouches:2],
#endif
        [SCIPinchZoomModifier3D new],
        [SCIOrbitModifier3D new],
        [SCIZoomExtentsModifier3D new]
    ]];
    return modifierGroup3D;
}

- (BOOL)showDefaultModifiersInToolbar {
    BOOL result = YES;
    if ([self.surface isKindOfClass:SCIChartSurface3D.class] || !self.surface) {
        result = NO;
    }
    
    return result;
}

- (NSArray<id<ISCDToolbarItem>> *)generateToolbarItems {
    NSMutableArray<id<ISCDToolbarItem>> *toolbarItems = [NSMutableArray new];
    
    [self p_SCD_addToolbarItems:[self provideExampleSpecificToolbarItems] to:toolbarItems];
    if (self.showDefaultModifiersInToolbar) {
        [toolbarItems addObjectsFromArray:[self p_SCD_getDefaultModifiers]];
    }
    
//    [toolbarItems addObject:[self p_SCD_createDevSettingsItem]];
    
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

    __weak typeof(self) wSelf = self;
    
    id<ISCDToolbarItem> item = [[SCDToolbarButtonsGroup alloc] initWithToolbarItems:@[
        [[SCDToolbarButton alloc] initWithTitle:@"Zoom extents" image:[SCIImage imageNamed:@"chart.modifier.zoomextents"] andAction:^{
            [(id<ISCIChartController>)wSelf.surface animateZoomExtentsWithDuration:SCI_DEFAULT_ANIMATION_DURATION];
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
