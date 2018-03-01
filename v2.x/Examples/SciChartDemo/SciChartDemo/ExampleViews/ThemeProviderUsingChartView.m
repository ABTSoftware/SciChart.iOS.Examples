//
//  ThemeProviderUsingChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 12/15/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ThemeProviderUsingChartView.h"
#import "ThousandsLabelProvider.h"
#import "BillionsLabelProvider.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@implementation ThemeProviderUsingChartView

@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        surface = [SCIChartSurface new];
        surface.translatesAutoresizingMaskIntoConstraints = NO;

        UIView * panel = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 45.f)];
        panel.backgroundColor = [UIColor blackColor];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:panel];

        UIButton * themeButton = [[UIButton alloc] initWithFrame:panel.frame];
        themeButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [themeButton setTitle:@"Chart V4 Dark" forState:UIControlStateNormal];
        [themeButton addTarget:self action:@selector(p_changeTheme:) forControlEvents:UIControlEventTouchUpInside];
        [panel addSubview:themeButton];

        [self addSubview:surface];
        NSDictionary * layout = @{@"SciChart": surface, @"Panel": panel};

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(45)]-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|" options:0 metrics:0 views:layout]];

        [self initializeSurfaceData];
    }

    return self;
}

- (void)p_changeTheme:(UIButton *)button {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Select Theme" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    NSArray * themeNames = @[@"Black Steel", @"Bright Spark", @"Chrome", @"Chart V4 Dark", @"Electric", @"Expression Dark", @"Expression Light", @"Oscilloscope"];
    NSArray * themeKeys = @[SCIChart_BlackSteelStyleKey, SCIChart_Bright_SparkStyleKey, SCIChart_ChromeStyleKey, SCIChart_SciChartv4DarkStyleKey, SCIChart_ElectricStyleKey, SCIChart_ExpressionDarkStyleKey, SCIChart_ExpressionLightStyleKey, SCIChart_OscilloscopeStyleKey];

    for (NSString * themeName in themeNames) {
        UIAlertAction * actionTheme = [UIAlertAction actionWithTitle:themeName style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            NSString * themeKey = themeKeys[[themeNames indexOfObject:themeName]];
            [SCIThemeManager applyThemeToThemeable:surface withThemeKey:themeKey];
            [button setTitle:themeName forState:UIControlStateNormal];
        }];
        [alertController addAction:actionTheme];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    alertController.popoverPresentationController.sourceView = self;
    alertController.popoverPresentationController.sourceRect = button.frame;
    [[self.window rootViewController] presentViewController:alertController animated:YES completion:nil];
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
    yRightAxis.labelProvider = [[ThousandsLabelProvider alloc] init];

    id <SCIAxis2DProtocol> yLeftAxis = [[SCINumericAxis alloc] init];
    yLeftAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(3)];
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.autoRange = SCIAutoRange_Always;
    yLeftAxis.axisId = @"SecondaryAxisId";
    yLeftAxis.labelProvider = [[BillionsLabelProvider alloc] init];

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
        
        [SCIThemeManager applyDefaultThemeToThemeable:surface];
    }];
}

@end
