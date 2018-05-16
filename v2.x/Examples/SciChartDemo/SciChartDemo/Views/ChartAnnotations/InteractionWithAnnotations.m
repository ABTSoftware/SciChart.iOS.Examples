//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import "DataManager.h"
#import "MarketDataService.h"

@implementation InteractionWithAnnotations

- (void)initExample {
    SCICategoryDateTimeAxis * xAxis = [SCICategoryDateTimeAxis new];
    SCINumericAxis * yAxis = [SCINumericAxis new];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(30.0) Max:SCIGeneric(37.0)];
    
    SCIOhlcDataSeries * dataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Float];
    
    MarketDataService * marketDataService = [[MarketDataService alloc] initWithStartDate:[NSDate date] TimeFrameMinutes:5 TickTimerIntervals:0.005];
    PriceSeries * data = [marketDataService getHistoricalData:200];
    
    [dataSeries appendRangeX:SCIGeneric(data.dateData)
                        Open:SCIGeneric(data.openData)
                        High:SCIGeneric(data.highData)
                         Low:SCIGeneric(data.lowData)
                       Close:SCIGeneric(data.closeData)
                       Count:data.size];
    
    SCIFastCandlestickRenderableSeries * rSeries = [SCIFastCandlestickRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    
    [self.surface.xAxes add:xAxis];
    [self.surface.yAxes add:yAxis];
    [self.surface.renderableSeries add:rSeries];
    [self.surface.chartModifiers add:[SCIZoomPanModifier new]];

    SCITextAnnotation * textAnnotation1 = [SCITextAnnotation new];
    textAnnotation1.isEditable = YES;
    textAnnotation1.text = @"Buy";
    textAnnotation1.x1 = SCIGeneric(10);
    textAnnotation1.y1 = SCIGeneric(30.5);
    textAnnotation1.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
    textAnnotation1.style.textStyle.fontSize = 20;
    textAnnotation1.style.textColor = [UIColor whiteColor];
                                       
    SCITextAnnotation * textAnnotation2 = [SCITextAnnotation new];
    textAnnotation2.isEditable = YES;
    textAnnotation2.text = @"Sell";
    textAnnotation2.x1 = SCIGeneric(50);
    textAnnotation2.y1 = SCIGeneric(34);
    textAnnotation2.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
    textAnnotation2.style.textStyle.fontSize = 20;
    textAnnotation2.style.textColor = [UIColor whiteColor];
    
    SCITextAnnotation * rotatedTextAnnotation = [SCITextAnnotation new];
    rotatedTextAnnotation.isEditable = YES;
    rotatedTextAnnotation.text = @"Rotated text";
    rotatedTextAnnotation.x1 = SCIGeneric(80);
    rotatedTextAnnotation.y1 = SCIGeneric(36);
    rotatedTextAnnotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Bottom;
    rotatedTextAnnotation.style.textStyle.fontSize = 20;
    rotatedTextAnnotation.style.textColor = [UIColor whiteColor];
    rotatedTextAnnotation.style.viewSetup = ^(UITextView * view) {
        view.userInteractionEnabled = YES;
        view.layer.transform = CATransform3DMakeRotation (30 * M_PI / 180, 0, 0, 1);
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, 50, 100);
    };
    
    SCIBoxAnnotation * boxAnnotation = [SCIBoxAnnotation new];
    boxAnnotation.x1 = SCIGeneric(50);
    boxAnnotation.y1 = SCIGeneric(35.5);
    boxAnnotation.x2 = SCIGeneric(120);
    boxAnnotation.y2 = SCIGeneric(32);
    boxAnnotation.style.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x33FF6600];
    boxAnnotation.style.borderPen = [[SCISolidPenStyle alloc] initWithColorCode:0x77FF6600 withThickness:1.0];
    boxAnnotation.isEditable = true;
    
    SCILineAnnotation * lineAnnotation1 = [SCILineAnnotation new];
    lineAnnotation1.x1 = SCIGeneric(30);
    lineAnnotation1.y1 = SCIGeneric(30.5);
    lineAnnotation1.x2 = SCIGeneric(60);
    lineAnnotation1.y2 = SCIGeneric(35.5);
    lineAnnotation1.isEditable = true;
    lineAnnotation1.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xAAFF6600 withThickness:2];
    
    SCILineAnnotation * lineAnnotation2 = [SCILineAnnotation new];
    lineAnnotation2.x1 = SCIGeneric(120);
    lineAnnotation2.y1 = SCIGeneric(30.5);
    lineAnnotation2.x2 = SCIGeneric(175);
    lineAnnotation2.y2 = SCIGeneric(36);
    lineAnnotation2.isEditable = true;
    lineAnnotation2.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xAAFF6600 withThickness:2];
    
    SCIAxisMarkerAnnotation * axisMarker1 = [SCIAxisMarkerAnnotation new];
    axisMarker1.position = SCIGeneric(32.7);
    axisMarker1.isEditable = true;
    axisMarker1.style.annotationSurface = SCIAnnotationSurface_YAxis;

    SCIAxisMarkerAnnotation * axisMarker2 = [SCIAxisMarkerAnnotation new];
    axisMarker2.position = SCIGeneric(100);
    axisMarker2.isEditable = true;
    axisMarker2.formattedValue = @"Horizontal";
    axisMarker2.style.annotationSurface = SCIAnnotationSurface_XAxis;

    SCIHorizontalLineAnnotation * horizontalLine1 = [SCIHorizontalLineAnnotation new];
    horizontalLine1.x1 = SCIGeneric(150);
    horizontalLine1.y1 = SCIGeneric(32.2);
    horizontalLine1.isEditable = true;
    horizontalLine1.horizontalAlignment = SCIHorizontalLineAnnotationAlignment_Right;
    horizontalLine1.style.linePen = [[SCISolidPenStyle alloc] initWithColor: [UIColor redColor] withThickness:2];
    [horizontalLine1 addLabel: [self buildLineAnnotationLabelWithText:@"" alignment:SCILabelPlacement_Axis color:[UIColor whiteColor] backColor:[UIColor redColor]]];
    
    SCIHorizontalLineAnnotation * horizontalLine2 = [SCIHorizontalLineAnnotation new];
    horizontalLine2.x1 = SCIGeneric(130);
    horizontalLine2.x2 = SCIGeneric(160);
    horizontalLine2.y1 = SCIGeneric(33.9);
    horizontalLine2.isEditable = true;
    horizontalLine2.horizontalAlignment = SCIHorizontalLineAnnotationAlignment_Center;
    horizontalLine2.style.linePen = [[SCISolidPenStyle alloc] initWithColor: [UIColor blueColor] withThickness:2];
    [horizontalLine2 addLabel:[self buildLineAnnotationLabelWithText:@"Top" alignment:SCILabelPlacement_Top color:[UIColor blueColor] backColor:[UIColor clearColor]]];
    [horizontalLine2 addLabel:[self buildLineAnnotationLabelWithText:@"Left" alignment:SCILabelPlacement_Left color:[UIColor blueColor] backColor:[UIColor clearColor]]];
    [horizontalLine2 addLabel:[self buildLineAnnotationLabelWithText:@"Right" alignment:SCILabelPlacement_Right color:[UIColor blueColor] backColor:[UIColor clearColor]]];
    
    SCIVerticalLineAnnotation * verticalLine1 = [SCIVerticalLineAnnotation new];
    verticalLine1.x1 = SCIGeneric(20);
    verticalLine1.y1 = SCIGeneric(35);
    verticalLine1.y2 = SCIGeneric(33);
    verticalLine1.isEditable = true;
    verticalLine1.verticalAlignment = SCIVerticalLineAnnotationAlignment_Center;
    verticalLine1.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode: 0xFF006400 withThickness:2];
    
    SCIVerticalLineAnnotation * verticalLine2 = [SCIVerticalLineAnnotation new];
    verticalLine2.x1 = SCIGeneric(40);
    verticalLine2.y1 = SCIGeneric(34);
    verticalLine2.isEditable = true;
    verticalLine2.verticalAlignment = SCIVerticalLineAnnotationAlignment_Top;
    verticalLine2.style.linePen = [[SCISolidPenStyle alloc] initWithColorCode:0xFF006400 withThickness:2];
    [verticalLine2 addLabel: [self buildLineAnnotationLabelWithText:@"" alignment:SCILabelPlacement_Top color:[UIColor greenColor] backColor:[UIColor clearColor]]];
    
    SCITextAnnotation * textAnnotation3 = [SCITextAnnotation new];
    textAnnotation3.coordinateMode = SCIAnnotationCoordinate_Relative;
    textAnnotation3.horizontalAnchorPoint = SCIHorizontalAnchorPoint_Center;
    textAnnotation3.text = @"EUR/USD";
    textAnnotation3.x1 = SCIGeneric(0.5);
    textAnnotation3.y1 = SCIGeneric(0.5);
    textAnnotation3.style.textStyle.fontSize = 72;
    textAnnotation3.style.textColor = [UIColor fromARGBColorCode:0x77FFFFFF];

    self.surface.annotations = [[SCIAnnotationCollection alloc] initWithChildAnnotations:@[textAnnotation3, textAnnotation1, textAnnotation2, rotatedTextAnnotation, boxAnnotation,
                                                                                      lineAnnotation1, lineAnnotation2, axisMarker1, axisMarker2,
                                                                                      horizontalLine1, horizontalLine2, verticalLine1, verticalLine2]];
    
    [SCIThemeManager applyDefaultThemeToThemeable:rSeries];
}

- (SCILineAnnotationLabel *)buildLineAnnotationLabelWithText:(NSString*)text alignment:(SCILabelPlacement)labelPlacement color:(UIColor*)color backColor:(UIColor*)backColor {
    SCILineAnnotationLabel * lineAnnotationLabel = [SCILineAnnotationLabel new];
    lineAnnotationLabel.text = text;
    lineAnnotationLabel.style.textStyle.color = color;
    lineAnnotationLabel.style.backgroundColor = backColor;
    lineAnnotationLabel.style.labelPlacement = labelPlacement;
    return lineAnnotationLabel;
}

@end
