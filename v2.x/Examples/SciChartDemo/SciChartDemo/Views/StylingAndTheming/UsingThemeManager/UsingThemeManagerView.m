//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingThemeManagerView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UsingThemeManagerView.h"
#import "ThousandsLabelProvider.h"
#import "BillionsLabelProvider.h"
#import "DataManager.h"

@implementation UsingThemeManagerView

- (void)commonInit {
    [self.selectThemeButton setTitle:@"Chart V4 Dark" forState:UIControlStateNormal];
    [self.selectThemeButton addTarget:self action:@selector(p_changeTheme:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)p_changeTheme:(UIButton *)button {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Select Theme" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    NSArray * themeNames = @[@"Black Steel", @"Bright Spark", @"Chrome", @"Chart V4 Dark", @"Electric", @"Expression Dark", @"Expression Light", @"Oscilloscope"];
    NSArray * themeKeys = @[SCIChart_BlackSteelStyleKey, SCIChart_Bright_SparkStyleKey, SCIChart_ChromeStyleKey, SCIChart_SciChartv4DarkStyleKey, SCIChart_ElectricStyleKey, SCIChart_ExpressionDarkStyleKey, SCIChart_ExpressionLightStyleKey, SCIChart_OscilloscopeStyleKey];

    for (NSString * themeName in themeNames) {
        UIAlertAction * actionTheme = [UIAlertAction actionWithTitle:themeName style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            NSString * themeKey = themeKeys[[themeNames indexOfObject:themeName]];
            [SCIThemeManager applyThemeToThemeable:self.surface withThemeKey:themeKey];
            [button setTitle:themeName forState:UIControlStateNormal];
        }];
        [alertController addAction:actionTheme];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    alertController.popoverPresentationController.sourceView = self;
    alertController.popoverPresentationController.sourceRect = button.frame;
    [[self.window rootViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)initExample {
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
    
    SCILegendModifier * legendModifier = [SCILegendModifier new];
    legendModifier.showCheckBoxes = NO;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yRightAxis];
        [self.surface.yAxes add:yLeftAxis];
        [self.surface.renderableSeries add:mountainSeries];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.renderableSeries add:columnSeries];
        [self.surface.renderableSeries add:candlestickSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[legendModifier, [SCICursorModifier new], [SCIZoomExtentsModifier new]]];

        [mountainSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [lineSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [columnSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        [candlestickSeries addAnimation:[[SCIScaleRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOutElastic]];
        
        [SCIThemeManager applyDefaultThemeToThemeable:self.surface];
    }];
}

@end
