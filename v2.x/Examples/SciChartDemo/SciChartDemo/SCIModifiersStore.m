//
//  SCIModifiersStore.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "SCIModifiersStore.h"
#import "SciModifierModel.h"
#import <SciChart/SciChart.h>

@implementation SCIModifiersStore

@synthesize sciModifiers;

+(id) SharedSCIModifiersStore{
    static SCIModifiersStore *sharedSCiModifiersStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSCiModifiersStore = [[self alloc] init];
    });
    return sharedSCiModifiersStore;
}

- (id)init {
    if (self = [super init]) {
        sciModifiers = [[NSMutableArray alloc]initWithObjects:
                        [[SciModifierModel alloc]initWithTitle:@"AxisDrag Modifier"
                                           ModifierDescription:@"Provides a tap drag to scale the axis. Scales the axis in a direction depending on which half of the axis the user starts the operation"
                                                          Icon:[UIImage imageNamed:@"AxisDragModifier"]
                                                     ClassName:@"SCIXAxisDragModifier"],
                        
                        [[SciModifierModel alloc]initWithTitle:@"PinchZoom Modifier"
                                           ModifierDescription:@"Zooms the chart via the Pinch-Zoom Multitouch Gesture"
                                                          Icon:[UIImage imageNamed:@""]
                                                     ClassName:@"SCIXAxisDragModifier"],
                        
                        [[SciModifierModel alloc]initWithTitle:@"ZoomExtents Modifier"
                                           ModifierDescription:@"Zooms the chart to the extents of the data, plus any X or Y Grow By fraction set on the X and Y Axes"
                                                          Icon:[UIImage imageNamed:@""]
                                                     ClassName:@"SCIXAxisDragModifier"],
                        nil];
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

@end
