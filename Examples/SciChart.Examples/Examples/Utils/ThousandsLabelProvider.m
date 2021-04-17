//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ThousandsLabelProvider.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ThousandsLabelProvider.h"

@implementation ThousandsLabelProvider

- (id<ISCIString>)formatLabel:(id<ISCIComparable>)dataValue {
    return [NSString stringWithFormat:@"%.1fk", [SCIComparableUtil toDouble:dataValue] / 1000];
}

- (id<ISCIString>)formatCursorLabel:(id<ISCIComparable>)dataValue {
    return [self formatLabel:dataValue];
}

@end
