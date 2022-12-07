//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ColumnChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ColumnChartView.h"
#import "SCDDataManager.h"

@interface ColumnsTripleColorPalette : SCIPaletteProviderBase<SCIFastColumnRenderableSeries *><ISCIFillPaletteProvider>
- (instancetype)init;
@end

@implementation ColumnsTripleColorPalette {
    SCIUnsignedIntegerValues *_colors;
}

static unsigned int desiredColors[] = {0xFF882B91, 0xFFEC0F6C, 0xFFF48420, 0xFF50C7E0, 0xFFC52E60, 0xFF67BDAF};

- (instancetype)init {
    self = [super initWithRenderableSeriesType:SCIFastColumnRenderableSeries.class];
    if (self) {
        _colors = [SCIUnsignedIntegerValues new];
    }
    return self;
}

- (void)update {
    NSInteger count = self.renderableSeries.currentRenderPassData.pointsCount;
    _colors.count = count;
    
    unsigned int *colorsArray = _colors.itemsArray;
    for (NSInteger i = 0; i < count; i++) {
        colorsArray[i] = desiredColors[i % 6];
    }
}

- (SCIUnsignedIntegerValues *)fillColors {
    return _colors;
}

@end

@implementation ColumnChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    int yValues[] = {50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60};
    for (size_t i = 0; i < sizeof(yValues)/sizeof(yValues[0]); i++) {
        [dataSeries appendX:@(i) y:@(yValues[i])];
    }
    
    SCIFastColumnRenderableSeries *rSeries = [SCIFastColumnRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.paletteProvider = [ColumnsTripleColorPalette new];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];

        [SCIAnimations waveSeries:rSeries duration:2.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
