//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDDimTracePaletteProvider.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDDimTracePaletteProvider.h"

@implementation SCDDimTracePaletteProvider {
    SCIUnsignedIntegerValues *_colors;
    double _startOpacity;
    double _diffOpacity;
}

- (instancetype)init {
    self = [super initWithRenderableSeriesType:SCIFastLineRenderableSeries.class];
    if (self) {
        _colors = [SCIUnsignedIntegerValues new];
        _startOpacity = 0.2;
        _diffOpacity = 1 - _startOpacity;
    }
    return self;
}

- (void)update {
    unsigned int defaultColor = self.renderableSeries.strokeStyle.color.colorARGBCode;
    NSInteger count = self.renderableSeries.currentRenderPassData.pointsCount;
    _colors.count = count;
    
    unsigned int *colorsArray = _colors.itemsArray;
    for (int i = 0; i < count; i++) {
        double fraction = (double)i / count;
        double opacity = _startOpacity + fraction * _diffOpacity;
        unsigned int color = [SCIColor argb:defaultColor withOpacity:opacity];
        
        colorsArray[i] = color;
    }
}

- (SCIUnsignedIntegerValues *)strokeColors {
    return _colors;
}

@end
