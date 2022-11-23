//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// InteractionWithAnnotations.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "InteractionWithAnnotations.h"
#import "SCDDataManager.h"
#import "SCDMarketDataService.h"

@implementation InteractionWithAnnotations

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    SCICategoryDateAxis *xAxis = [SCICategoryDateAxis new];
    SCINumericAxis *yAxis = [SCINumericAxis new];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:30 max:37];
    
    SCIOhlcDataSeries *dataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    
    SCDMarketDataService *marketDataService = [[SCDMarketDataService alloc] initWithStartDate:NSDate.date TimeFrameMinutes:5 TickTimerIntervals:0.005];
    SCDPriceSeries *data = [marketDataService getHistoricalData:200];
    
    [dataSeries appendValuesX:data.dateData open:data.openData high:data.highData low:data.lowData close:data.closeData];
    
    SCIFastCandlestickRenderableSeries *rSeries = [SCIFastCandlestickRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.opacity = 0.4;
    
    [self.surface.xAxes add:xAxis];
    [self.surface.yAxes add:yAxis];
    [self.surface.renderableSeries add:rSeries];
    [self.surface.chartModifiers add:[SCIZoomPanModifier new]];

    SCITextAnnotation *textAnnotation1 = [SCITextAnnotation new];
    textAnnotation1.x1 = @(10);
    textAnnotation1.y1 = @(30.5);
    textAnnotation1.isEditable = YES;
    textAnnotation1.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
    textAnnotation1.text = @"Buy";
    textAnnotation1.fontStyle = [[SCIFontStyle alloc] initWithFontSize:20 andTextColor:SCIColor.whiteColor];
                                       
    SCITextAnnotation *textAnnotation2 = [SCITextAnnotation new];
    textAnnotation2.x1 = @(50);
    textAnnotation2.y1 = @(34);
    textAnnotation2.isEditable = YES;
    textAnnotation2.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
    textAnnotation2.text = @"Sell";
    textAnnotation2.fontStyle = [[SCIFontStyle alloc] initWithFontSize:20 andTextColor:SCIColor.whiteColor];
    
    SCITextAnnotation *rotatedTextAnnotation = [SCITextAnnotation new];
    rotatedTextAnnotation.x1 = @(80);
    rotatedTextAnnotation.y1 = @(36);
    rotatedTextAnnotation.isEditable = YES;
    rotatedTextAnnotation.rotationAngle = -30;
    rotatedTextAnnotation.text = @"Rotated text";
    rotatedTextAnnotation.fontStyle = [[SCIFontStyle alloc] initWithFontSize:20 andTextColor:SCIColor.whiteColor];
    
    SCIBoxAnnotation *boxAnnotation = [SCIBoxAnnotation new];
    boxAnnotation.x1 = @(50);
    boxAnnotation.y1 = @(35.5);
    boxAnnotation.x2 = @(120);
    boxAnnotation.y2 = @(32);
    boxAnnotation.isEditable = YES;
    boxAnnotation.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x33FF6600];
    boxAnnotation.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0x77FF6600 thickness:1.0];
    
    SCILineAnnotation *lineAnnotation1 = [SCILineAnnotation new];
    lineAnnotation1.x1 = @(30);
    lineAnnotation1.y1 = @(30.5);
    lineAnnotation1.x2 = @(60);
    lineAnnotation1.y2 = @(35.5);
    lineAnnotation1.isEditable = YES;
    lineAnnotation1.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xAAFF6600 thickness:2];
    
    SCILineAnnotation *lineAnnotation2 = [SCILineAnnotation new];
    lineAnnotation2.x1 = @(120);
    lineAnnotation2.y1 = @(30.5);
    lineAnnotation2.x2 = @(175);
    lineAnnotation2.y2 = @(36);
    lineAnnotation2.isEditable = YES;
    lineAnnotation2.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xAAFF6600 thickness:2];
    
    SCILineArrowAnnotation *lineArrowAnnotation = [SCILineArrowAnnotation new];
    lineArrowAnnotation.x1 = @(120);
    lineArrowAnnotation.y1 = @(35);
    lineArrowAnnotation.x2 = @(80);
    lineArrowAnnotation.y2 = @(31.4);
    lineArrowAnnotation.headLength = 8;
    lineArrowAnnotation.headWidth = 16;
    lineArrowAnnotation.isEditable = YES;
    
    SCIAxisMarkerAnnotation *axisMarker1 = [SCIAxisMarkerAnnotation new];
    axisMarker1.y1 = @(32.7);
    axisMarker1.isEditable = YES;

    SCIAxisMarkerAnnotation *axisMarker2 = [SCIAxisMarkerAnnotation new];
    axisMarker2.x1 = @(100);
    axisMarker2.isEditable = YES;
    axisMarker2.formattedValue = @"Horizontal";
    axisMarker2.annotationSurface = SCIAnnotationSurface_XAxis;

    SCIHorizontalLineAnnotation *horizontalLine1 = [SCIHorizontalLineAnnotation new];
    horizontalLine1.x1 = @(150);
    horizontalLine1.y1 = @(32.2);
    horizontalLine1.isEditable = YES;
    horizontalLine1.horizontalAlignment = SCIAlignment_Right;
    horizontalLine1.stroke = [[SCISolidPenStyle alloc] initWithColorCode: 0xFFc43360 thickness:2];
    [horizontalLine1.annotationLabels add:[self createLabelWithText:nil alignment:SCILabelPlacement_Axis]];
    
    SCIHorizontalLineAnnotation *horizontalLine2 = [SCIHorizontalLineAnnotation new];
    horizontalLine2.x1 = @(130);
    horizontalLine2.x2 = @(160);
    horizontalLine2.y1 = @(33.9);
    horizontalLine2.isEditable = YES;
    horizontalLine2.horizontalAlignment = SCIAlignment_CenterHorizontal;
    horizontalLine2.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0x55274b92  thickness:2];
    [horizontalLine2.annotationLabels add:[self createLabelWithText:@"Top" alignment:SCILabelPlacement_Top]];
    [horizontalLine2.annotationLabels add:[self createLabelWithText:@"Left" alignment:SCILabelPlacement_Left]];
    [horizontalLine2.annotationLabels add:[self createLabelWithText:@"Right" alignment:SCILabelPlacement_Right]];
    
    SCIVerticalLineAnnotation *verticalLine1 = [SCIVerticalLineAnnotation new];
    verticalLine1.x1 = @(20);
    verticalLine1.y1 = @(35);
    verticalLine1.y2 = @(33);
    verticalLine1.isEditable = YES;
    verticalLine1.verticalAlignment = SCIAlignment_CenterVertical;
    verticalLine1.stroke = [[SCISolidPenStyle alloc] initWithColorCode: 0xFF68bcae thickness:2];
    
    SCIVerticalLineAnnotation *verticalLine2 = [SCIVerticalLineAnnotation new];
    verticalLine2.x1 = @(40);
    verticalLine2.y1 = @(34);
    verticalLine2.isEditable = YES;
    verticalLine2.verticalAlignment = SCIAlignment_Top;
    verticalLine2.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:2];
    [verticalLine2.annotationLabels add:[self createLabelWithText:nil alignment:SCILabelPlacement_Top]];
    
    SCITextAnnotation *textAnnotation3 = [SCITextAnnotation new];
    textAnnotation3.x1 = @(0.5);
    textAnnotation3.y1 = @(0.5);
    textAnnotation3.coordinateMode = SCIAnnotationCoordinateMode_Relative;
    textAnnotation3.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
    textAnnotation3.text = @"EUR/USD";
    textAnnotation3.fontStyle = [[SCIFontStyle alloc] initWithFontSize:72 andTextColorCode:0x77FFFFFF];

    self.surface.annotations = [[SCIAnnotationCollection alloc] initWithCollection:@[textAnnotation3, textAnnotation1, textAnnotation2, rotatedTextAnnotation, boxAnnotation, lineAnnotation1, lineAnnotation2, lineArrowAnnotation, axisMarker1, axisMarker2, horizontalLine1, horizontalLine2, verticalLine1, verticalLine2]];
}

- (SCIAnnotationLabel *)createLabelWithText:(NSString *)text alignment:(SCILabelPlacement)labelPlacement {
    SCIAnnotationLabel *annotationLabel = [SCIAnnotationLabel new];
    if (text != nil) {
        annotationLabel.text = text;
    }
    annotationLabel.labelPlacement = labelPlacement;
    
    return annotationLabel;
}

@end
