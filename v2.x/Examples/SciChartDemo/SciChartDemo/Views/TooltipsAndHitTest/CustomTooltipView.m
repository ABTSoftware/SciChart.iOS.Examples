//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomTooltipView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CustomTooltipView.h"

@implementation CustomTooltipView

+ (SCITooltipDataView *)createInstance {
    CustomTooltipView * view = [NSBundle.mainBundle loadNibNamed:@"CustomTooltipView" owner:nil options:nil].firstObject;
    view.translatesAutoresizingMaskIntoConstraints = false;
    
    return view;
}

- (void)setData:(SCISeriesInfo *)data {
    SCIXySeriesInfo * seriesInfo = (SCIXySeriesInfo *)data;
    
    _xLabel.text = [seriesInfo formatXCursorValue:seriesInfo.xValue];
    _yLabel.text = [seriesInfo formatYCursorValue:seriesInfo.yValue];
    _seriesName.text = seriesInfo.seriesName;
}

@end
