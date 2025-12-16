//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BuySellMarkerAnnotationChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "BuySellMarkerAnnotationChartView.h"
#import "SCDDataManager.h"

#pragma mark - Vertically Stacked Axes Layout

@interface StackedYAxisLayoutStrategy : SCIVerticalAxisLayoutStrategy
@end
@implementation StackedYAxisLayoutStrategy

- (void)measureAxesWithAvailableWidth:(CGFloat)width height:(CGFloat)height andChartLayoutState:(SCIChartLayoutState *)chartLayoutState {
    for (NSUInteger i = 0, count = self.axes.count; i < count; i++) {
        id<ISCIAxis> axis = self.axes[i];
        [axis updateAxisMeasurements];
        
        CGFloat requiredAxisSize = [SCIVerticalAxisLayoutStrategy getRequiredAxisSizeFrom:axis.axisLayoutState];
        chartLayoutState.rightOuterAreaSize = MAX(requiredAxisSize, chartLayoutState.leftOuterAreaSize);
    }
}

- (void)layoutWithLeft:(CGFloat)left top:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom {
    NSUInteger count = self.axes.count;
    CGFloat height = bottom - top;
    NSArray *ratios = @[@0.8, @0.2];

    
    CGFloat topPlacement = top;
    for (NSUInteger i = 0; i < count; i++) {
        id<ISCIAxis> axis = self.axes[i];
        SCIAxisLayoutState *axisLayoutState = axis.axisLayoutState;
        
        CGFloat ratio = [ratios[i] doubleValue];
        CGFloat axisHeight = height * ratio;
        CGFloat bottomPlacement = topPlacement + axisHeight;
        
        CGFloat requiredAxisSize = [SCIVerticalAxisLayoutStrategy getRequiredAxisSizeFrom:axisLayoutState];
        [axis layoutAreaWithLeft:right - requiredAxisSize + axisLayoutState.additionalLeftSize top:topPlacement right:right - axisLayoutState.additionalRightSize bottom:bottomPlacement];
        
        topPlacement = bottomPlacement;
    }
}

@end


@implementation BuySellMarkerAnnotationChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    
    // --- Data series ---
    SCIOhlcDataSeries *historicalData = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataIndex];
    SCIDateValues *dateData = priceSeries.dateData;
    SCIDataSeriesIndexDataProvider *indexDataProvider = [[SCIDataSeriesIndexDataProvider alloc] initWithDataSeriesValues:historicalData];
    
    // --- X Axis ---
    SCIIndexDateAxis *xAxis = [SCIIndexDateAxis new];
    [xAxis setIndexDataProvider:indexDataProvider];
    xAxis.visibleRange = [[SCIDateRange alloc] initWithMin:[dateData getValueAt:0]
                                                       max:[dateData getValueAt:30]];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.05 max:0.05];
    
    
    // --- Balance Axis ---
    SCINumericAxis *xAxis1 = [SCINumericAxis new];
    xAxis1.axisId = @"balance";
    xAxis1.isVisible = NO;
    
    
    // --- Price Y Axis ---
    SCINumericAxis *yAxis = [SCINumericAxis new];
    yAxis.autoRange = SCIAutoRange_Never;
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.axisAlignment = SCIAxisAlignment_Right;
    
    
    // --- Balance Y Axis ---
    SCINumericAxis *balanceYAxis = [SCINumericAxis new];
    balanceYAxis.axisId = @"Balance";
    balanceYAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    balanceYAxis.axisAlignment = SCIAxisAlignment_Right;
    balanceYAxis.autoRange = SCIAutoRange_Never;
    
    
    // --- Append OHLC data ---
    [historicalData appendValuesX:dateData open:priceSeries.openData high:priceSeries.highData low:priceSeries.lowData close:priceSeries.closeData];
    
    
    // --- Candlestick renderable ---
    SCIFastCandlestickRenderableSeries *historicalPrices = [SCIFastCandlestickRenderableSeries new];
    historicalPrices.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF84E2FF thickness:1];
    historicalPrices.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF84E2FF thickness:1];
    historicalPrices.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF84E2FF];
    historicalPrices.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x00000000];
    historicalPrices.dataSeries = historicalData;
    
    
    // --- Info Annotation ---
    SCITextAnnotation *infoText = [SCITextAnnotation new];
    [infoText setX1:[dateData getValueAt:1]];
    [infoText setY1:@160];
    infoText.text = @"Tap markers to see simulated trading info";
    [self.surface.annotations add:infoText];
    
    
    // --- Simulation Variables ---
    double position = 0, equity = 0, balance = 100, avgPrice = 0;
    
    SCIXyDataSeries *positionSeries =
    [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Int yType:SCIDataType_Double];
    
    SCIXyDataSeries *balanceSeries =
    [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    
    
    // --- Iterate over price bars ---
    for (int i = 0; i < priceSeries.count; i++) {
        
        double low = priceSeries.lowData.itemsArray[i];
        double high = priceSeries.highData.itemsArray[i];
        double price = low + drand48() * (high - low);
        
        BOOL shouldTrade = drand48() < 0.3;
        
        if (shouldTrade) {
            
            double t = equity / (equity + balance);
            
            if (drand48() > t) {
                // --- Buy ---
                int qty = arc4random_uniform(50) + 1;
                double size = qty * price;
                avgPrice = (avgPrice * position + size) / (position + qty);
                position += qty;
                balance -= size;
                
                TradeMarkerAnnotation *marker =
                [[TradeMarkerAnnotation alloc] initWithIndex:[dateData getValueAt:i]
                                                       isBuy:YES
                                                       yPoint:low
                                                       price:price];
                marker.delegate = self;
                [self.surface.annotations add:marker];
            } else {
                // --- Sell ---
                int qty = arc4random_uniform(50) + 1;
                double size = qty * price;
                position -= qty;
                balance += size;
                
                TradeMarkerAnnotation *marker =
                [[TradeMarkerAnnotation alloc] initWithIndex:[dateData getValueAt:i]
                                                       isBuy:NO
                                                       yPoint:high
                                                       price:price];
                
                marker.delegate = self;
                [self.surface.annotations add:marker];
            }
        }
        
        equity = position * priceSeries.closeData.itemsArray[i];
        [positionSeries appendX:@(i) y:@(position)];
        [balanceSeries appendX:[dateData getValueAt:i] y:@(balance + equity)];
        
        if (i % 20 == 0) {
            [self.surface.annotations add:[self newsBulletAnnotation:[dateData getValueAt:i]]];
        }
    }


// --- Balance mountain series ---
   SCIFastMountainRenderableSeries *balanceRenderable = [SCIFastMountainRenderableSeries new];
   balanceRenderable.dataSeries = balanceSeries;
   balanceRenderable.yAxisId = @"Balance";
   balanceRenderable.areaStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFBC88D2];
   balanceRenderable.strokeStyle =
       [[SCISolidPenStyle alloc] initWithColorCode:0xFFAA4BBD thickness:2];


   // --- Stacked axis layout ---
   SCIDefaultLayoutManager *layoutManager = [SCIDefaultLayoutManager new];
   layoutManager.rightOuterAxisLayoutStrategy = [StackedYAxisLayoutStrategy new];
   self.surface.layoutManager = layoutManager;

   [self.surface invalidateElement];


   // --- Apply to chart ---
   [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
       [self.surface.xAxes add:xAxis];
       [self.surface.yAxes add:yAxis];
       [self.surface.yAxes add:balanceYAxis];

       [self.surface.renderableSeries add:historicalPrices];
       [self.surface.renderableSeries add:balanceRenderable];

       [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
   }];
}

#pragma mark - News Annotation

- (SCITextAnnotation *)newsBulletAnnotation:(NSDate *)index {
   SCITextAnnotation *annotation = [SCITextAnnotation new];
   [annotation setX1:index];
   [annotation setY1:@120];
   annotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
   annotation.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
   annotation.text = @"Div";
   annotation.padding = (SCIEdgeInsets){5, 5, 5, 5};
   annotation.backgroundColor = SCIColor.whiteColor;
   annotation.fontStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColorCode:0xFF000000];
   return annotation;
}

#pragma mark - TradeAnnotationDelegate

- (void)didTradeAnnotationTapped:(TradeMarkerAnnotation *)annotation
                        atPoint:(CGPoint)point {

   if (annotation.hasLabel) {
       [self hidePriceLabelFor:annotation];
   } else {

       NSDictionary *info = annotation.userInfo.firstObject;
       BOOL isBuy = [info[@"isBuy"] boolValue];
       double price = [info[@"price"] doubleValue];

       [self showPriceLabelFor:annotation price:price isBuy:isBuy];
       [self.surface invalidateElement];
   }
}

- (void)showPriceLabelFor:(TradeMarkerAnnotation *)annotation
                   price:(double)price
                   isBuy:(BOOL)isBuy {

   SCITextAnnotation *label = [SCITextAnnotation new];
  
   [label setX1:annotation.x1];
   [label setY1:annotation.y1];

   label.text = [NSString stringWithFormat:@"%.2f", price];
   label.backgroundColor = [(isBuy ? SCIColor.systemGreenColor : SCIColor.systemRedColor) colorWithAlphaComponent:0.8];
   label.fontStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColorCode:0xFFFFFFFF];
   label.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
   label.verticalAnchorPoint = isBuy ? SCIVerticalAnchorPoint_Bottom : SCIVerticalAnchorPoint_Top;

   [self.surface.annotations add:label];

   annotation.hasLabel = YES;
    [annotation.userInfo addObject: label];
}

- (void)hidePriceLabelFor:(TradeMarkerAnnotation *)annotation {

   if (annotation.userInfo.count > 1) {

       SCITextAnnotation *label = annotation.userInfo[1];

       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC),
                      dispatch_get_main_queue(), ^{
           [self.surface.annotations remove:label];
           annotation.hasLabel = NO;
           [annotation.userInfo removeObject:label];
           [self.surface invalidateElement];
       });
   }
}

@end
