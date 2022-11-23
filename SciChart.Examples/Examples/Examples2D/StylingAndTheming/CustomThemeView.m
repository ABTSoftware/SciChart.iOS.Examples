//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomThemeView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CustomThemeView.h"
#import "SCDDataManager.h"
#import "ThousandsLabelProvider.h"
#import "BillionsLabelProvider.h"

static SCIChartTheme const SCIChartThemeBerryBlue = @"SciChart_BerryBlue";

@implementation CustomThemeView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)tryUpdateChartTheme:(SCIChartTheme)theme {
    // Don't respond to system theme changes
}

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:150 max:180];

    id<ISCIAxis> yRightAxis = [SCINumericAxis new];
    yRightAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yRightAxis.axisAlignment = SCIAxisAlignment_Right;
    yRightAxis.autoRange = SCIAutoRange_Always;
    yRightAxis.axisId = @"PrimaryAxisId";
    yRightAxis.labelProvider = [ThousandsLabelProvider new];

    id<ISCIAxis> yLeftAxis = [SCINumericAxis new];
    yLeftAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0 max:3];
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.autoRange = SCIAutoRange_Always;
    yLeftAxis.axisId = @"SecondaryAxisId";
    yLeftAxis.axisTitle = @"Billions (of People)";
    yLeftAxis.axisTitleAlignment = SCIAlignment_Top;
    yLeftAxis.axisTitlePlacement = SCIAxisTitlePlacement_Inside;
    yLeftAxis.axisTitleMargins = (SCIEdgeInsets){ .top = 20, .left = 20, .bottom = 0, .right = 0 };
    yLeftAxis.labelProvider = [BillionsLabelProvider new];

    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataIndu];
    
    SCIXyDataSeries *mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    mountainDataSeries.seriesName = @"Mountain Series";
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    lineDataSeries.seriesName = @"Line Series";
    SCIXyDataSeries *columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Long];
    columnDataSeries.seriesName = @"Column Series";
    SCIOhlcDataSeries *candlestickDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    candlestickDataSeries.seriesName = @"Candlestick Series";
    
    [mountainDataSeries appendValuesX:priceSeries.indexesAsDouble y:[SCDDataManager offset:priceSeries.lowData offset:-1000]];
    [lineDataSeries appendValuesX:priceSeries.indexesAsDouble y:[SCDDataManager computeMovingAverageOf:priceSeries.closeData length:50]];
    [columnDataSeries appendValuesX:priceSeries.indexesAsDouble y:priceSeries.volumeData];
    [candlestickDataSeries appendValuesX:priceSeries.indexesAsDouble open:priceSeries.openData high:priceSeries.highData low:priceSeries.lowData close:priceSeries.closeData];
    
    SCIFastMountainRenderableSeries *mountainSeries = [SCIFastMountainRenderableSeries new];
    mountainSeries.dataSeries = mountainDataSeries;
    mountainSeries.yAxisId = @"PrimaryAxisId";
    
    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = lineDataSeries;
    lineSeries.yAxisId = @"PrimaryAxisId";
    
    SCIFastColumnRenderableSeries *columnSeries = [SCIFastColumnRenderableSeries new];
    columnSeries.dataSeries = columnDataSeries;
    columnSeries.yAxisId = @"SecondaryAxisId";
    
    SCIFastCandlestickRenderableSeries *candlestickSeries = [SCIFastCandlestickRenderableSeries new];
    candlestickSeries.dataSeries = candlestickDataSeries;
    candlestickSeries.yAxisId = @"PrimaryAxisId";
    candlestickSeries.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:1];
    candlestickSeries.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x9068bcae];
    candlestickSeries.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFae418d thickness:1];
    candlestickSeries.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x90ae418d];
    
    SCILegendModifier *legendModifier = [SCILegendModifier new];
    legendModifier.showCheckBoxes = NO;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yRightAxis];
        [self.surface.yAxes add:yLeftAxis];
        [self.surface.renderableSeries add:mountainSeries];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.renderableSeries add:columnSeries];
        [self.surface.renderableSeries add:candlestickSeries];
        [self.surface.chartModifiers addAll:SCDExampleBaseViewController.createDefaultModifiers, legendModifier, nil];
        
        [SCIAnimations scaleSeries:mountainSeries withZeroLine:10500 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:lineSeries withZeroLine:11700 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:columnSeries withZeroLine:12250 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        [SCIAnimations scaleSeries:candlestickSeries withZeroLine:10500 duration:3.0 andEasingFunction:[SCIElasticEase new]];
        
        [SCIThemeManager addTheme:SCIChartThemeBerryBlue fromBundle:[NSBundle bundleWithIdentifier:@"com.scichart.examples.sources"]];
        [SCIThemeManager applyTheme:SCIChartThemeBerryBlue toThemeable:self.surface];
    }];
}

@end
