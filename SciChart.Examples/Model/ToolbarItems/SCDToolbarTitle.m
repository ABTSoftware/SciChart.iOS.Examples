//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDToolbarTitle.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDToolbarTitle.h"
#if TARGET_OS_OSX
#import <AppKit/NSTextField.h>
#endif
@implementation SCDToolbarTitle {
    NSString *_title;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        _title = title;
        self.identifier = @"TOOLBAR_TITLE";
    }
    return self;
}

- (SCIView *)createView {
#if TARGET_OS_OSX
    NSTextField *label = [NSTextField new];
    label.bezeled = NO;
    label.drawsBackground = NO;
    label.editable = NO;
    label.selectable = NO;
    label.alignment = NSTextAlignmentCenter;
    label.textColor = NSColor.labelColor;
    label.stringValue = _title;
    
    return label;
#elif TARGET_OS_IOS
    return nil;
#endif
}

@end
