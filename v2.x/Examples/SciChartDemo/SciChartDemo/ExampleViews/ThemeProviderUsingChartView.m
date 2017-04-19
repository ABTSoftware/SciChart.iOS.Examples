//
//  ThemeProviderUsingChartView.m
//  SciChartDemo
//
//  Created by Hrybenuik Mykola on 12/15/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "ThemeProviderUsingChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"

@interface ThousandsLabelProvider : SCINumericLabelProvider
@end

@implementation ThousandsLabelProvider

- (NSString *)formatLabel:(SCIGenericType)dataValue {
    return [NSString stringWithFormat: @"%@k", [super formatLabel:SCIGeneric(SCIGenericDouble(dataValue) / 1000)]];
}

@end

@interface BillionsLabelProvider : SCINumericLabelProvider
@end

@implementation BillionsLabelProvider

- (NSString *)formatLabel:(SCIGenericType)dataValue {
    return [NSString stringWithFormat: @"%@B", [super formatLabel:SCIGeneric(SCIGenericDouble(dataValue) / pow(10, 9))]];
}

@end

@implementation ThemeProviderUsingChartView

@synthesize sciChartSurfaceView;
@synthesize surface;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        sciChartSurfaceView = [[SCIChartSurfaceView alloc] initWithFrame:frame];
        [sciChartSurfaceView setTranslatesAutoresizingMaskIntoConstraints:NO];

        UIView *panel = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 45.f)];
        panel.backgroundColor = [UIColor blackColor];
        panel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:panel];

        UIButton *themeButton = [[UIButton alloc] initWithFrame:panel.frame];
        themeButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [themeButton setTitle:@"Chart V4 Dark" forState:UIControlStateNormal];
        [themeButton addTarget:self action:@selector(p_changeTheme:) forControlEvents:UIControlEventTouchUpInside];
        [panel addSubview:themeButton];

        [self addSubview:sciChartSurfaceView];
        NSDictionary *layout = @{@"SciChart": sciChartSurfaceView, @"Panel": panel};

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(0)-[Panel(45)]-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[SciChart]-(0)-|" options:0 metrics:0 views:layout]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(0)-[Panel]-(0)-|" options:0 metrics:0 views:layout]];

        [self initializeSurfaceData];
    }

    return self;
}

- (void)p_changeTheme:(UIButton *)button {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Select Theme" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    NSArray *themeNames = @[@"Black Steel", @"Bright Spark", @"Chrome", @"Chart V4 Dark", @"Electric", @"Expression Dark", @"Expression Light", @"Oscilloscope"];

    for (NSString *themeName in themeNames) {
        UIAlertAction *actionTheme = [UIAlertAction actionWithTitle:themeName style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [self p_applyTheme:[themeNames indexOfObject:themeName]];
            [button setTitle:themeName forState:UIControlStateNormal];
        }];
        [alertController addAction:actionTheme];
    }

    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    alertController.popoverPresentationController.sourceView = self;
    alertController.popoverPresentationController.sourceRect = button.frame;
    [[self.window rootViewController] presentViewController:alertController animated:YES completion:nil];
}

- (void)p_applyTheme:(SCIThemeKey)themeKey {
    [surface applyThemeProvider:[[SCIThemeColorProvider alloc] initWithThemeKey:themeKey]];
}

- (void)initializeSurfaceData {
    surface = [[SCIChartSurface alloc] initWithView:sciChartSurfaceView];

    SCIAxisStyle *axisStyle = [[SCIAxisStyle alloc] init];
    axisStyle.drawMajorTicks = NO;
    axisStyle.drawMinorTicks = NO;

    id <SCIAxis2DProtocol> xAxis = [[SCINumericAxis alloc] init];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(150) Max:SCIGeneric(180)];

    id <SCIAxis2DProtocol> yRightAxis = [[SCINumericAxis alloc] init];
    yRightAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yRightAxis.axisAlignment = SCIAxisAlignment_Right;
    yRightAxis.autoRange = SCIAutoRange_Always;
    yRightAxis.axisId = @"PrimaryAxisId";
    yRightAxis.style = axisStyle;
    yRightAxis.labelProvider = [[ThousandsLabelProvider alloc] init];

    id <SCIAxis2DProtocol> yLeftAxis = [[SCINumericAxis alloc] init];
    yLeftAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(3)];
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.autoRange = SCIAutoRange_Always;
    yLeftAxis.axisId = @"SecondaryAxisId";
    yLeftAxis.style = axisStyle;
    yLeftAxis.labelProvider = [[BillionsLabelProvider alloc] init];

    SCIXyDataSeries *mountainDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [mountainDataSeries setSeriesName:@"Mountain Series"];
    SCIXyDataSeries *lineDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [lineDataSeries setSeriesName:@"Line Series"];
    SCIXyDataSeries *columnDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
    [columnDataSeries setSeriesName:@"Column Series"];
    SCIOhlcDataSeries *candlestickDataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float SeriesType:SCITypeOfDataSeries_DefaultType];
    [candlestickDataSeries setSeriesName:@"Candlestick Series"];

    SCDMovingAverage *averageHigh = [[SCDMovingAverage alloc] initWithLength:50];

    NSArray <SCDMultiPaneItem *> *dataSource = [DataManager loadThemeData];
    for (int i = 0; i < dataSource.count; i++) {
        SCDMultiPaneItem *item = dataSource[i];

        SCIGenericType xValue = SCIGeneric(i);
        SCIGenericType open = SCIGeneric(item.open);
        SCIGenericType high = SCIGeneric(item.high);
        SCIGenericType low = SCIGeneric(item.low);
        SCIGenericType close = SCIGeneric(item.close);

        [mountainDataSeries appendX:xValue Y:SCIGeneric(item.close - 1000)];
        [lineDataSeries appendX:xValue Y:SCIGeneric([averageHigh push:item.close].current)];
        [columnDataSeries appendX:xValue Y:SCIGeneric(item.volume)];
        [candlestickDataSeries appendX:xValue Open:open High:high Low:low Close:close];
    }

    SCIFastMountainRenderableSeries *mountainRenderableSeries = [[SCIFastMountainRenderableSeries alloc] init];
    mountainRenderableSeries.dataSeries = mountainDataSeries;
    mountainRenderableSeries.yAxisId = @"PrimaryAxisId";

    SCIFastLineRenderableSeries *lineRenderableSeries = [SCIFastLineRenderableSeries new];
    lineRenderableSeries.dataSeries = lineDataSeries;
    lineRenderableSeries.yAxisId = @"PrimaryAxisId";

    SCIFastColumnRenderableSeries *columnRenderableSeries = [[SCIFastColumnRenderableSeries alloc] init];
    columnRenderableSeries.dataSeries = columnDataSeries;
    columnRenderableSeries.yAxisId = @"SecondaryAxisId";

    SCIFastCandlestickRenderableSeries *candlestickRenderableSeries = [[SCIFastCandlestickRenderableSeries alloc] init];
    candlestickRenderableSeries.dataSeries = candlestickDataSeries;
    candlestickRenderableSeries.yAxisId = @"PrimaryAxisId";

    [surface.xAxes add:xAxis];
    [surface.yAxes add:yRightAxis];
    [surface.yAxes add:yLeftAxis];
    [surface.renderableSeries add:mountainRenderableSeries];
    [surface.renderableSeries add:lineRenderableSeries];
    [surface.renderableSeries add:columnRenderableSeries];
    [surface.renderableSeries add:candlestickRenderableSeries];

    SCILegendCollectionModifier *legendModifier = [[SCILegendCollectionModifier alloc] initWithPosition:SCILegendPositionLeft | SCILegendPositionTop andOrientation:SCILegendOrientationVertical];
    legendModifier.showCheckBoxes = NO;
    legendModifier.modifierName = @"Legend Modifier";
    SCICursorModifier *cursorModifier = [[SCICursorModifier alloc] init];
    cursorModifier.modifierName = @"Cursor Modifier";
    SCIZoomExtentsModifier *zoomExtentsModifier = [[SCIZoomExtentsModifier alloc] init];
    zoomExtentsModifier.modifierName = @"Zoom Extents Modifier";

    surface.chartModifier = [[SCIModifierGroup alloc] initWithChildModifiers:@[legendModifier, cursorModifier, zoomExtentsModifier]];

    [surface invalidateElement];
    [self p_applyTheme:SCIChartV4DarkTheme];
}

@end
