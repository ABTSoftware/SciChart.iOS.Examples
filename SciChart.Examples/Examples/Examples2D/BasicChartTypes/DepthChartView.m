//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DepthChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
#import "SCDDoubleChartPaneViewController.h"
#import "SCDDataManager.h"
#import "SCDConstants.h"

#import "DepthChartView.h"


@implementation DepthChartView {
    SCIHitTestInfo *_hitTestInfo;
    SCIHitTestInfo *_buyHitTestInfo;
    SCIHitTestInfo *_sellHitTestInfo;

    SCIVerticalLineAnnotation *xSellLineAnnotation;
    SCIVerticalLineAnnotation *xbuyLineAnnotation;
    SCILineAnnotation *ySellLineAnnotation;
    SCILineAnnotation *ybuyLineAnnotation;
    SCITextAnnotation *buyLabel;
    SCITextAnnotation *sellLabel;
    NSArray* reversedxArray;
    NSArray* reversedYArray;
    NSMutableArray *buyXValues;
    NSMutableArray *buyYValues;
    NSMutableArray *askXvalues;
    NSMutableArray *askYvalues;
    NSMutableArray* subArrayData;
}

@dynamic firstSurface;
@dynamic secondSurface;

- (void)initExample {    
    [self initChartfirstSurfaceView:self.firstSurface];
    [self initChartsecondSurfaceView:self.secondSurface];
    _sellHitTestInfo = [SCIHitTestInfo new];
    _buyHitTestInfo = [SCIHitTestInfo new];
    xSellLineAnnotation = [SCIVerticalLineAnnotation new];
    xbuyLineAnnotation = [SCIVerticalLineAnnotation new];
    ybuyLineAnnotation = [SCILineAnnotation new];
    ySellLineAnnotation = [SCILineAnnotation new];
    buyLabel = [SCITextAnnotation new];
    sellLabel = [SCITextAnnotation new];
}

- (void)initChartfirstSurfaceView:(SCIChartSurface *)surface {
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataIndu];
    NSInteger count = priceSeries.count;
    
    id<ISCIAxis> xAxis = [SCICategoryDateAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:count - 30 max:count];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    yAxis.autoRange = SCIAutoRange_Always;
    
    SCIOhlcDataSeries *dataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    [dataSeries appendValuesX:priceSeries.dateData open:priceSeries.openData high:priceSeries.highData low:priceSeries.lowData close:priceSeries.closeData];
    
    SCIFastCandlestickRenderableSeries *rSeries = [SCIFastCandlestickRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF67BDAF thickness:1];
    rSeries.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x7767BDAF];
    rSeries.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDC7969 thickness:1];
    rSeries.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x77DC7969];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:rSeries];
        [surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers]];
        
        [SCIAnimations waveSeries:rSeries duration:1.0 andEasingFunction:[SCICubicEase new]];
    }];
}

- (void)initChartsecondSurfaceView:(SCIChartSurface *)surface {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.axisAlignment = SCIAxisAlignment_Right;
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
    NSString *const SCIAskDataPath = @"Asks_Initial_Data.csv";
    NSString *const SCIBidDataPath = @"Bids_Initial_Data.csv";
    
    SCIXyDataSeries *askDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    SCIXyDataSeries *bidDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
   
    NSMutableArray *result = [NSMutableArray new];
    askXvalues = [NSMutableArray new];
    askYvalues = [NSMutableArray new];
    NSString *rawData = [NSString stringWithContentsOfFile:[SCDDataManager getBundleFilePathFrom:SCIAskDataPath] encoding:NSUTF8StringEncoding error:nil];
    double sumofValues = 0.0;
    NSArray *lines = [rawData componentsSeparatedByString:@"\n"];
    for (NSUInteger i = 0; i < lines.count; i++) {
        [result addObject:lines[i]];
        NSArray *components = [result[i] componentsSeparatedByString:@","];
        double xType = [components[0] doubleValue];
        double yType = [components[1] doubleValue];
        sumofValues += yType;
        [askXvalues addObject:@(xType)];
        [askYvalues addObject:@(sumofValues)];
        
        [askDataSeries appendX:@(xType) y:@(sumofValues)];
    }
    
    NSMutableArray *result1 = [NSMutableArray new];
    NSString *rawData1 = [NSString stringWithContentsOfFile:[SCDDataManager getBundleFilePathFrom:SCIBidDataPath] encoding:NSUTF8StringEncoding error:nil];
    
    NSMutableArray *xArray = [NSMutableArray new];
    NSMutableArray *yArray = [NSMutableArray new];
    
    NSArray *lines1 = [rawData1 componentsSeparatedByString:@"\n"];
    for (NSUInteger i = 0; i < lines1.count; i++) {
        [result1 addObject:lines1[i]];
        NSArray *components = [result1[i] componentsSeparatedByString:@","];
        double xType = [components[0] doubleValue];
        double yType = [components[1] doubleValue];
        
        NSNumber *xNum = [NSNumber numberWithDouble:xType];
        [xArray addObject:xNum];
        
        NSNumber *yNum = [NSNumber numberWithDouble:yType];
        [yArray addObject:yNum];
    }
    
    reversedxArray = [[xArray reverseObjectEnumerator] allObjects];
    reversedYArray = [[yArray reverseObjectEnumerator] allObjects];
    double sumofValues1 = 0.0;
    buyYValues = [NSMutableArray new];
    buyXValues = [NSMutableArray new];
    bidDataSeries.acceptsUnsortedData = YES;
    for (NSUInteger i = 0; i < reversedYArray.count; ++i) {
        double yValue = [reversedYArray[i] doubleValue];
        double xValue = [reversedxArray[i] doubleValue];
        sumofValues1 += yValue;
        [buyYValues addObject:@(sumofValues1)];
        [buyXValues addObject:@(xValue)];
        [bidDataSeries appendX:@(xValue) y:@(sumofValues1)];
    }
    
    SCIFastLineRenderableSeries *askSeries = [SCIFastLineRenderableSeries new];
    askSeries.dataSeries = askDataSeries;
    askSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0x77e97064 thickness:2.0 strokeDashArray:NULL antiAliasing:YES];
    
    SCIFastLineRenderableSeries *bidSeries = [SCIFastLineRenderableSeries new];
    bidSeries.dataSeries = bidDataSeries;
    bidSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF67BDAF thickness:2.0 strokeDashArray:NULL antiAliasing:YES];
    
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        self->_hitSurface = surface;
        [self->_hitSurface addGestureRecognizer:[[SCITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)]];
        [surface.xAxes add:xAxis];
        [surface.yAxes add:yAxis];
        [surface.renderableSeries add:askSeries];
        [surface.renderableSeries add:bidSeries];
        [SCIAnimations sweepSeries:askSeries duration:1.0 andEasingFunction:[SCICubicEase new]];
        [SCIAnimations sweepSeries:bidSeries duration:1.0 andEasingFunction:[SCICubicEase new]];
        
    }];
}

- (SCIAnnotationLabel *)createLabelWithText:(NSString *)text alignment:(SCILabelPlacement)labelPlacement {
    SCIAnnotationLabel *annotationLabel = [SCIAnnotationLabel new];
    if (text != nil) {
        annotationLabel.text = text;
    }
    annotationLabel.labelPlacement = labelPlacement;
    
    return annotationLabel;
}

- (void)handleSingleTap:(SCITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    CGPoint hitTestPoint = [_hitSurface translatePoint:location hitTestable:_hitSurface.renderableSeriesArea];

    SCIRenderableSeriesCollection *seriesCollection = _hitSurface.renderableSeries;
    for (NSInteger i = 0, count = seriesCollection.count; i < count; i++) {
        id<ISCIRenderableSeries> rSeries = seriesCollection[i];
        if (i == 0) {
            [rSeries verticalSliceHitTest:_sellHitTestInfo at:hitTestPoint];

        } else {
            [rSeries verticalSliceHitTest:_buyHitTestInfo at:hitTestPoint];
        }
    }
    subArrayData = [reversedxArray mutableCopy];
    unsigned long midValue = (askXvalues.count + subArrayData.count)/2;
    NSArray *newArray=[askXvalues arrayByAddingObjectsFromArray:subArrayData];
    SCIVerticalLineAnnotation *middleLine = [SCIVerticalLineAnnotation new];
    double midPoint = 0.0;
    for (NSUInteger i = 0; i < newArray.count; ++i) {
        if (midValue == i) {
            midPoint = [newArray[i] doubleValue];
        }
    }
    middleLine.x1 = @(midPoint);
    middleLine.y1 = @(0);
    middleLine.isEditable = YES;
    middleLine.verticalAlignment = SCIAlignment_FillVertical;
    middleLine.stroke = [[SCISolidPenStyle alloc] initWithColor: SCIColor.whiteColor thickness:2];
    if (_buyHitTestInfo.isHit == true) {
        unsigned long item =  _buyHitTestInfo.dataSeriesIndex;
        double buyXvalue = 0.0;
        double buyYvalue = 0.0;

        for (unsigned long i = 0; i < buyXValues.count; ++i) {
            if (item == i) {
                buyXvalue = [buyXValues[i] doubleValue];
            }
        }
        for (unsigned long i = 0; i < buyYValues.count; ++i) {
            if (item == i) {
                buyYvalue = [buyYValues[i] doubleValue];
            }
        }
        xbuyLineAnnotation.x1 = @(buyXvalue);
        xbuyLineAnnotation.verticalAlignment = SCIAlignment_Fill;
        xbuyLineAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColor:SCIColor.greenColor thickness:2];
        [xbuyLineAnnotation.annotationLabels add:[self createLabelWithText:nil alignment:SCILabelPlacement_Axis]];
        
        double sellValue = midPoint  + (midPoint - buyXvalue);
        xSellLineAnnotation.x1 = @(sellValue);
        xSellLineAnnotation.verticalAlignment = SCIAlignment_Fill;
        xSellLineAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColor:SCIColor.redColor thickness:2];
        [xSellLineAnnotation.annotationLabels add:[self createLabelWithText:nil alignment:SCILabelPlacement_Axis]];
        
        ybuyLineAnnotation.x1 = @(buyXvalue);
        ybuyLineAnnotation.x2 = @(midPoint);
        ybuyLineAnnotation.y1 = @(buyYvalue);
        ybuyLineAnnotation.y2 = @(buyYvalue);
        ybuyLineAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColor:SCIColor.greenColor thickness:2];
        
        double sellYvalue = 0.0;
        for (unsigned long i = 0; i < askYvalues.count; ++i) {
            if (item == i) {
                sellYvalue = [askYvalues[i] doubleValue];
            }
        }
        
        ySellLineAnnotation.x1 = @(midPoint);
        ySellLineAnnotation.x2 = @(sellValue);
        ySellLineAnnotation.y1 = @(sellYvalue);
        ySellLineAnnotation.y2 = @(sellYvalue);
        ySellLineAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColor:SCIColor.redColor thickness:2];
        
        buyLabel.x1 = @(midPoint);
        buyLabel.y1 = @(buyYvalue);
        buyLabel.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Right;
        buyLabel.text = [NSString stringWithFormat:@"%.2f", buyYvalue];
        buyLabel.fontStyle = [[SCIFontStyle alloc] initWithFontSize:8 andTextColor:SCIColor.whiteColor];
        
        sellLabel.x1 = @(midPoint);
        sellLabel.y1 = @(sellYvalue);
        sellLabel.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Left;
        sellLabel.text = [NSString stringWithFormat:@"%.2f", sellYvalue];
        sellLabel.fontStyle = [[SCIFontStyle alloc] initWithFontSize:8 andTextColor:SCIColor.whiteColor];
        
    _hitSurface.annotations = [[SCIAnnotationCollection alloc] initWithCollection:@[xbuyLineAnnotation,xSellLineAnnotation,middleLine,ybuyLineAnnotation,ySellLineAnnotation,buyLabel,sellLabel]];

    }
    if (_sellHitTestInfo.isHit == true) {
        unsigned long index =  _sellHitTestInfo.dataSeriesIndex;
        double sellXvalue = 0.0;
        double sellYvalue = 0.0;

        for (unsigned long i = 0; i < askXvalues.count; ++i) {
            if (index == i) {
                sellXvalue = [askXvalues[i] doubleValue];
            }
        }
        for (unsigned long i = 0; i < askYvalues.count; ++i) {
            if (index == i) {
                sellYvalue = [askYvalues[i] doubleValue];
            }
        }
        xSellLineAnnotation.x1 = @(sellXvalue);
        xSellLineAnnotation.verticalAlignment = SCIAlignment_Fill;
        xSellLineAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColor:SCIColor.redColor thickness:2];
        [xSellLineAnnotation.annotationLabels add:[self createLabelWithText:nil alignment:SCILabelPlacement_Axis]];
        
        double buyValue = midPoint - (sellXvalue - midPoint);
        xbuyLineAnnotation.x1 = @(buyValue);
        xbuyLineAnnotation.verticalAlignment = SCIAlignment_Fill;
        xbuyLineAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColor:SCIColor.greenColor thickness:2];
        [xbuyLineAnnotation.annotationLabels add:[self createLabelWithText:nil alignment:SCILabelPlacement_Axis]];
        
        ySellLineAnnotation.x1 = @(midPoint);
        ySellLineAnnotation.x2 = @(sellXvalue);
        ySellLineAnnotation.y1 = @(sellYvalue);
        ySellLineAnnotation.y2 = @(sellYvalue);
        ySellLineAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColor:SCIColor.redColor thickness:2];
        
        double buyXvalue = 0.0;
        double buyYvalue = 0.0;

        for (unsigned long i = 0; i < buyXValues.count; ++i) {
            if (index == i) {
                buyXvalue = [buyXValues[i] doubleValue];
            }
        }
        for (unsigned long i = 0; i < buyYValues.count; ++i) {
            if (index == i) {
                buyYvalue = [buyYValues[i] doubleValue];
            }
        }
        
        ybuyLineAnnotation.x1 = @(buyValue);
        ybuyLineAnnotation.x2 = @(midPoint);
        ybuyLineAnnotation.y1 = @(buyYvalue);
        ybuyLineAnnotation.y2 = @(buyYvalue);
        ybuyLineAnnotation.stroke = [[SCISolidPenStyle alloc] initWithColor:SCIColor.greenColor thickness:2];

        buyLabel.x1 = @(midPoint);
        buyLabel.y1 = @(buyYvalue);
        buyLabel.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Right;
        buyLabel.text = [NSString stringWithFormat:@"%.2f", buyYvalue];
        buyLabel.fontStyle = [[SCIFontStyle alloc] initWithFontSize:8 andTextColor:SCIColor.whiteColor];
        
        sellLabel.x1 = @(midPoint);
        sellLabel.y1 = @(sellYvalue);
        sellLabel.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Left;
        sellLabel.text = [NSString stringWithFormat:@"%.2f", sellYvalue];
        sellLabel.fontStyle = [[SCIFontStyle alloc] initWithFontSize:8 andTextColor:SCIColor.whiteColor];
        
        _hitSurface.annotations = [[SCIAnnotationCollection alloc] initWithCollection:@[xSellLineAnnotation,xbuyLineAnnotation,middleLine,ySellLineAnnotation,ybuyLineAnnotation,buyLabel,sellLabel]];

    }
}

@end
