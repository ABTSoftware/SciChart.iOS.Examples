//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDToolbarButtonsGroupItem.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************


#import "SCDToolbarButtonsGroup.h"

#if TARGET_OS_OSX
#import <AppKit/NSSegmentedControl.h>
#elif TARGET_OS_IOS
#import <UIKit/NSLayoutAnchor.h>
#import "SCIStackView.h"
#import <SciChart/SCIButton.h>
#import <SciChart/SCIColor.h>
#import "SCDToolbarButton.h"
#endif

@implementation SCDToolbarButtonsGroup {
    NSArray<id<ISCDToolbarItemModel>> *_toolbarItems;
    NSUInteger _trackingMode;
    NSInteger _selectedSegment;
}

- (instancetype)initWithToolbarItems:(NSArray<id<ISCDToolbarItemModel>> *)toolbarItems {
    // 2 = NSSegmentSwitchTrackingMomentary
    return [self initWithToolbarItems:toolbarItems withTrackingMode:2];
}

- (instancetype)initWithToolbarItems:(NSArray<id<ISCDToolbarItemModel>> *)toolbarItems withTrackingMode:(NSUInteger)trackingMode {
    return [self initWithToolbarItems:toolbarItems withTrackingMode:trackingMode andSelectedSegment:-1];
}

- (instancetype)initWithToolbarItems:(NSArray<id<ISCDToolbarItemModel>> *)toolbarItems withTrackingMode:(NSUInteger)trackingMode andSelectedSegment:(NSInteger)selectedSegment {
    self = [super init];
    if (self) {
        _toolbarItems = toolbarItems;
        _trackingMode = trackingMode;
        _selectedSegment = selectedSegment;
    }
    return self;
}

- (SCIView *)createView {
#if TARGET_OS_OSX
    NSSegmentedControl *_segmentedControl = [NSSegmentedControl new];
    _segmentedControl.segmentCount = _toolbarItems.count;
    _segmentedControl.trackingMode = _trackingMode;
    _segmentedControl.target = self;
    _segmentedControl.action = @selector(p_SCD_onSegmentedControlSelect:);
    _segmentedControl.selectedSegment = _selectedSegment;
    
    for (NSUInteger i = 0; i < _toolbarItems.count; i++) {
        id<ISCDToolbarItemModel> item = _toolbarItems[i];
        if (item.image != nil) {
            [_segmentedControl setImage:[item.image scaledToSize:CGSizeMake(17, 17)] forSegment:i];
        } else {
            [_segmentedControl setLabel:item.title forSegment:i];
        }
    }
    return _segmentedControl;
#elif TARGET_OS_IOS
    SCIStackView *stackView = [SCIStackView new];
    stackView.axis = UILayoutConstraintAxisVertical;
    stackView.alignment = UIStackViewAlignmentCenter;
    for (id<ISCDToolbarItemModel> item in _toolbarItems) {
        SCDToolbarButton *button = [[SCDToolbarButton alloc] initWithTitle:item.title image:item.image andAction:item.action];
        [stackView addArrangedSubview:[button createView]];
    }
    
    return stackView;
#endif
}

#if TARGET_OS_OSX
- (void)p_SCD_onSegmentedControlSelect:(NSSegmentedControl *)sender {
    _toolbarItems[sender.selectedSegment].action();
}
#endif

@end
