//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// OhlcCustomPaletteProvider.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "OhlcCustomPaletteProvider.h"

@implementation OhlcCustomPaletteProvider {
    SCIIntegerValues *_colors;
    
    int _color;
    SCIBoxAnnotation *_annotation;
}

- (instancetype)initWithColor:(SCIColor *)color annotation:(SCIBoxAnnotation *)annotation {
    self = [super initWithRenderableSeriesType:SCIOhlcRenderableSeriesBase.class];
    if (self) {
        _colors = [SCIIntegerValues new];
        _color = color.colorARGBCode;
        _annotation = annotation;
    }
    return self;
}

- (void)update {
    SCIOhlcRenderableSeriesBase *rSeries = self.renderableSeries;
    SCIOhlcRenderPassData *rpd = (SCIOhlcRenderPassData *)rSeries.currentRenderPassData;
    SCIDoubleValues *xValues = rpd.xValues;
    
    NSInteger count = rpd.pointsCount;
    _colors.count = count;
    
    double x1 = _annotation.x1.toDouble;
    double x2 = _annotation.x2.toDouble;
    
    double min = MIN(x1, x2);
    double max = MAX(x1, x2);
    
    int *colorsArray = _colors.itemsArray;
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

- (SCIIntegerValues *)fillColors {
    return _colors;
}

- (SCIIntegerValues *)pointMarkerColors {
    return _colors;
}

- (SCIIntegerValues *)strokeColors {
    return _colors;
}

@end
