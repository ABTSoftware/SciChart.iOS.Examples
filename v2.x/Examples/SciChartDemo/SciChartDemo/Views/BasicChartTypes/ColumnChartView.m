//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import <SciChart/SciChart.h>
#import "DataManager.h"

@interface ColumnsTripleColorPalette : SCIPaletteProvider
@end

@implementation ColumnsTripleColorPalette {
    SCIColumnSeriesStyle * _style1;
    SCIColumnSeriesStyle * _style2;
    SCIColumnSeriesStyle * _style3;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _style1 = [SCIColumnSeriesStyle new];
        _style1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
        _style1.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFa9d34f finish:0xFF93b944 direction:SCILinearGradientDirection_Vertical];

        _style2 = [SCIColumnSeriesStyle new];
        _style2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
        _style2.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFfc9930 finish:0xFFd17f28 direction:SCILinearGradientDirection_Vertical];
        
        _style3 = [SCIColumnSeriesStyle new];
        _style3.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF232323 withThickness:0.4];
        _style3.fillBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithColorCodeStart:0xFFd63b3f finish:0xFFbc3337 direction:SCILinearGradientDirection_Vertical];
    }
    return self;
}

- (id<SCIStyleProtocol>)styleForX:(double)x Y:(double)y Index:(int)index {
    int styleIndex = index % 3;
    if (styleIndex == 0) {
        return _style1;
    } else if (styleIndex == 1) {
        return _style2;
    } else {
        return _style3;
    }
}

@end

@implementation ColumnChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int32 YType:SCIDataType_Int32];
    int yValues[] = {50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60};
    for (int i = 0; i < sizeof(yValues)/sizeof(yValues[0]); i++) {
        [dataSeries appendX:SCIGeneric(i) Y:SCIGeneric(yValues[i])];
    }
    
    SCIFastColumnRenderableSeries * rSeries = [SCIFastColumnRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.paletteProvider = [ColumnsTripleColorPalette new];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIRolloverModifier new]]];
        
        [rSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

@end
