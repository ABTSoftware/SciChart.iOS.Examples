//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ExampleListLabel.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ExampleListLabel.h"

@implementation ExampleListLabel

- (instancetype)initWithFont:(NSFont *)font {
    NSTextField *label = [NSTextField wrappingLabelWithString:@""];
    label.textColor = NSColor.labelColor;
    label.alignment = NSTextAlignmentNatural;
    label.font = font;
    label.maximumNumberOfLines = 1;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.cell.truncatesLastVisibleLine = YES;
    
    return (ExampleListLabel *)label;
}

- (instancetype)initWithFontSize:(CGFloat)fontSize {
    return [self initWithFont:[NSFont fontWithName:@"Montserrat-Light" size:fontSize]];
}

@end
