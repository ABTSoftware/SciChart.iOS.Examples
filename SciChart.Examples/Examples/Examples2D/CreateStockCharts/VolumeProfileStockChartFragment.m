//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// VolumeProfileStockChartFragment.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "VolumeProfileStockChartFragment.h"
#import "SCDDataManager.h"

NSString * const VOLUME_XAXIS = @"VolumeXAxis";
NSString * const PRICES_XAXIS = @"PricesXAxis";
NSString * const VOLUME_YAXIS = @"VolumeYAxis";
NSString * const PRICES_YAXIS = @"PricesYAxis";

@implementation VolumeProfileStockChartFragment

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataEurUsd];
    [self initPrice:priceSeries];
    [self initVolume:priceSeries];
}

-(void)initPrice: (SCDPriceSeries *)prices {
    
    SCICategoryDateAxis *xAxis = [SCICategoryDateAxis new];
    xAxis.visibleRange = [SCIDoubleRange new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.05];
    xAxis.axisId = PRICES_XAXIS;
    
    SCINumericAxis *yAxis = [SCINumericAxis new];
    yAxis.axisId = PRICES_YAXIS;
    yAxis.textFormatting = @"$0.0000";
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.minorsPerMajor = 4;
    yAxis.maxAutoTicks = 8;
    
    double growBy = 0.05;
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:growBy max:growBy];
    
    SCIOhlcDataSeries *stockPrices = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    stockPrices.seriesName = @"EUR/USD";
    [stockPrices appendValuesX:prices.dateData open:prices.openData high:prices.highData low:prices.lowData close:prices.closeData];
    
    SCIFastCandlestickRenderableSeries *candlestickSeries = [SCIFastCandlestickRenderableSeries new];
    candlestickSeries.dataSeries = stockPrices;
    candlestickSeries.yAxisId = PRICES_YAXIS;
    candlestickSeries.xAxisId = PRICES_XAXIS;
    
    SCIXAxisDragModifier *xAxisDragModifier = [SCIXAxisDragModifier new];
    xAxisDragModifier.dragMode = SCIAxisDragMode_Pan;
    xAxisDragModifier.clipModeX = SCIClipMode_StretchAtExtents;

    SCIPinchZoomModifier *pinchZoomModifier = [SCIPinchZoomModifier new];
    pinchZoomModifier.direction = SCIDirection2D_XDirection;

    SCILegendModifier *legendModifier = [SCILegendModifier new];
    legendModifier.showCheckBoxes = NO;
    
    SCIAxisMarkerAnnotation *annotations = [SCIAxisMarkerAnnotation new];
    annotations = [self addAxisMarkerAnnotationWithYAxisId:PRICES_YAXIS xAxisId:PRICES_XAXIS format:@"$%.4f" value:[stockPrices.yValues valueAt:stockPrices.count - 1] color:[SCIColor fromARGBColorCode:0xFF67BDAF]];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:candlestickSeries];
        [self.surface.annotations add:annotations];
        [self.surface.chartModifiers addAll:xAxisDragModifier, pinchZoomModifier, [SCIZoomPanModifier new], [SCIZoomExtentsModifier new], legendModifier, nil];
    }];
}

-(void)initVolume: (SCDPriceSeries *)prices {
    
    SCIRenderableSeriesCollection *renderableSeries = [SCIRenderableSeriesCollection new];
    SCIAnnotationCollection *annotations = [SCIAnnotationCollection new];
    
    SCICategoryDateAxis *xAxis = [SCICategoryDateAxis new];
    xAxis.visibleRange = [SCIDoubleRange new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.05];
    xAxis.isVisible = false;
    xAxis.axisId = VOLUME_XAXIS;
    xAxis.axisAlignment = SCIAxisAlignment_Left;
    
    SCINumericAxis *yAxis = [SCINumericAxis new];
    yAxis.axisId = VOLUME_YAXIS;
    yAxis.textFormatting = @"$0.0000";
    yAxis.autoRange = SCIAutoRange_Always;
    yAxis.minorsPerMajor = 4;
    yAxis.maxAutoTicks = 8;
    yAxis.isVisible = false;
    yAxis.axisAlignment = SCIAxisAlignment_Top;
    
    double growBy = 0.05;
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:growBy max:growBy];
    
    SCIXyDataSeries *volumePrices = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Long];
    volumePrices.seriesName = @"Volume";
    [volumePrices appendValuesX:prices.dateData y:prices.volumeData];
    
    SCIFastColumnRenderableSeries *columnSeries = [SCIFastColumnRenderableSeries new];
    columnSeries.dataSeries = volumePrices;
    columnSeries.yAxisId = VOLUME_YAXIS;
    columnSeries.xAxisId = VOLUME_XAXIS;
    columnSeries.fillBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x30FFFFFF];
    columnSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0x30FFFFFF thickness:1.0];
    
    SCIXAxisDragModifier *xAxisDragModifier = [SCIXAxisDragModifier new];
    xAxisDragModifier.dragMode = SCIAxisDragMode_Pan;
    xAxisDragModifier.clipModeX = SCIClipMode_StretchAtExtents;

    SCIPinchZoomModifier *pinchZoomModifier = [SCIPinchZoomModifier new];
    pinchZoomModifier.direction = SCIDirection2D_XDirection;

    SCILegendModifier *legendModifier = [SCILegendModifier new];
    legendModifier.showCheckBoxes = NO;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:columnSeries];
        [self.surface.chartModifiers addAll:xAxisDragModifier, pinchZoomModifier, [SCIZoomPanModifier new], [SCIZoomExtentsModifier new], legendModifier, nil];
    }];
}

- (SCIAxisMarkerAnnotation *)addAxisMarkerAnnotationWithYAxisId:(NSString *)yAxisId xAxisId:(NSString *)xAxisId format:(NSString *)format value:(id<ISCIComparable>)value color:(SCIColor *)color {
    SCIAxisMarkerAnnotation *axisMarkerAnnotation = [SCIAxisMarkerAnnotation new];
    axisMarkerAnnotation.yAxisId = yAxisId;
    axisMarkerAnnotation.xAxisId = xAxisId;
    axisMarkerAnnotation.y1 = value;
    axisMarkerAnnotation.coordinateMode = SCIAnnotationCoordinateMode_Absolute;
    if (color != nil) {
        axisMarkerAnnotation.backgroundBrush = [[SCISolidBrushStyle alloc] initWithColor:color];
    }
    axisMarkerAnnotation.formattedValue = [NSString stringWithFormat: format, value.toDouble];
    return axisMarkerAnnotation;
}

@end
    
