//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// XyCustomPaletteProvider.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "XyCustomPaletteProvider.h"

@implementation XyCustomPaletteProvider {
    SCIUnsignedIntegerValues *_colors;
    int _color;
    SCIBoxAnnotation *_annotation;
}

- (instancetype)initWithColor:(SCIColor *)color annotation:(SCIBoxAnnotation *)annotation {
    self = [super initWithRenderableSeriesType:SCIXyRenderableSeriesBase.class];
    if (self) {
        _colors = [SCIUnsignedIntegerValues new];
        _color = color.colorARGBCode;
        _annotation = annotation;
    }
    return self;
}

- (void)update {
    SCIXyRenderableSeriesBase *rSeries = self.renderableSeries;
    SCIXyRenderPassData *rpd = (SCIXyRenderPassData *)rSeries.currentRenderPassData;
    SCIDoubleValues *xValues = rpd.xValues;
    
    NSInteger count = rpd.pointsCount;
    _colors.count = count;
    
    double x1 = _annotation.x1.toDouble;
    double x2 = _annotation.x2.toDouble;
    
    double min = MIN(x1, x2);
    double max = MAX(x1, x2);
    
    unsigned int *colorsArray = _colors.itemsArray;
    double *valuesArray = xValues.itemsArray;
    
    for (int i = 0; i < count; i++) {
        double value = valuesArray[i];
        if (value > min && value < max) {
            colorsArray[i] = _color;
        } else {
            colorsArray[i] = SCIPaletteProviderBase.defaultColor;
        }
    }
}

- (SCIUnsignedIntegerValues *)fillColors {
    return _colors;
}

- (SCIUnsignedIntegerValues *)pointMarkerColors {
    return _colors;
}

- (SCIUnsignedIntegerValues *)strokeColors {
    return _colors;
}

@end
