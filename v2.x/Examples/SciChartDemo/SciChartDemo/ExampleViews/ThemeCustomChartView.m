//
//  ThemeCustomChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 12/15/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ThemeCustomChartView.h"
#import "DataManager.h"
#import "ThousandsLabelProvider.h"
#import "BillionsLabelProvider.h"
#import <SciChart/SciChart.h>

static NSString *_Nonnull const SCIChart_BerryBlueStyleKey = @"SciChart_BerryBlue";

@implementation ThemeCustomChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;

        NSDictionary * layout = @{@"SciChart": surface};
        [self addSubview:surface];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];

        [self initializeSurfaceData];
    }

    return self;
}

- (void)initializeSurfaceData {
    id <SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(150) Max:SCIGeneric(180)];

    id <SCIAxis2DProtocol> yRightAxis = [SCINumericAxis new];
    yRightAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yRightAxis.axisAlignment = SCIAxisAlignment_Right;
    yRightAxis.autoRange = SCIAutoRange_Always;
    yRightAxis.axisId = @"PrimaryAxisId";
    yRightAxis.labelProvider = [ThousandsLabelProvider new];

    id <SCIAxis2DProtocol> yLeftAxis = [SCINumericAxis new];
    yLeftAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(3)];
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.autoRange = SCIAutoRange_Always;
    yLeftAxis.axisId = @"SecondaryAxisId";
    yLeftAxis.labelProvider = [BillionsLabelProvider new];

    PriceSeries * priceSeries = [DataManager getPriceDataIndu];
    double movingAverageArray[priceSeries.size];
    double offsetLowData[priceSeries.size];
    
    SCIXyDataSeries * mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    mountainDataSeries.seriesName = @"Mountain Series";
    SCIXyDataSeries * lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    lineDataSeries.seriesName = @"Line Series";
    SCIXyDataSeries * columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Int64];
    columnDataSeries.seriesName = @"Column Series";
    SCIOhlcDataSeries * candlestickDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    candlestickDataSeries.seriesName = @"Candlestick Series";
    
    [mountainDataSeries appendRangeX:SCIGeneric(priceSeries.indexesAsDouble) Y:SCIGeneric([DataManager offsetArray:priceSeries.lowData destArray:offsetLowData count:priceSeries.size offset:-1000]) Count:priceSeries.size];
    SCIGenericType movingAverage = SCIGeneric([DataManager computeMovingAverageOf:priceSeries.closeData destArray:movingAverageArray sourceArraySize:priceSeries.size length:50]);
    [lineDataSeries appendRangeX:SCIGeneric(priceSeries.indexesAsDouble) Y:movingAverage Count:priceSeries.size];
    [columnDataSeries appendRangeX:SCIGeneric(priceSeries.indexesAsDouble) Y:SCIGeneric(priceSeries.volumeData) Count:priceSeries.size];
    [candlestickDataSeries appendRangeX:SCIGeneric(priceSeries.indexesAsDouble)
                                   Open:SCIGeneric(priceSeries.openData)
                                   High:SCIGeneric(priceSeries.highData)
                                    Low:SCIGeneric(priceSeries.lowData)
                                  Close:SCIGeneric(priceSeries.closeData)
                                  Count:priceSeries.size];
    
    SCIFastMountainRenderableSeries * mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = mountainDataSeries;
    mountainSeries.yAxisId = @"PrimaryAxisId";
    
    SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = lineDataSeries;
    lineSeries.yAxisId = @"PrimaryAxisId";
    
    SCIFastColumnRenderableSeries * columnSeries = [SCIFastColumnRenderableSeries new];
    columnSeries.dataSeries = columnDataSeries;
    columnSeries.yAxisId = @"SecondaryAxisId";
    
    SCIFastCandlestickRenderableSeries * candlestickSeries = [SCIFastCandlestickRenderableSeries new];
    candlestickSeries.dataSeries = candlestickDataSeries;
    candlestickSeries.yAxisId = @"PrimaryAxisId";
    
    SCILegendModifier * legendModifier = [[SCILegendModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop andOrientation:SCIOrientationVertical];
    legendModifier.showCheckBoxes = NO;
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yRightAxis];
        [surface.yAxes add:yLeftAxis];
        [surface.renderableSeries add:mountainSeries];
        [surface.renderableSeries add:lineSeries];
        [surface.renderableSeries add:columnSeries];
        [surface.renderableSeries add:candlestickSeries];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[legendModifier, [SCICursorModifier new], [SCIZoomExtentsModifier new]]];
        
        [mountainSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [lineSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [columnSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [candlestickSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        
        [SCIThemeManager applyThemeToThemeable:surface withThemeKey:SCIChart_BerryBlueStyleKey];
    }];
}

@end
