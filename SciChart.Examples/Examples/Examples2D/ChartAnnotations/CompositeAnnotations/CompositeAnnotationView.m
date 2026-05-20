//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2026. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CompositeAnnotationView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CompositeAnnotationView.h"
#import "SCDDataManager.h"
#import "CompositeAnnotationHelperClass.h"

@implementation CompositeAnnotationView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }


- (void)initExample {
    
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataIndu];
    NSInteger count = priceSeries.count;
    
    id<ISCIAxis> xAxis = [SCICategoryDateAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:count - 70 max:count];
    
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
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        
        // Composite Annotation
        SCICompositeAnnotation *compositeAnnotation = [SCICompositeAnnotation new];
        compositeAnnotation.x1 = @(185.0);
        compositeAnnotation.y1 = @(12300.0);
        compositeAnnotation.x2 = @(210.0);
        compositeAnnotation.y2 = @(11100.0);
        compositeAnnotation.isEditable = YES;
        compositeAnnotation.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x33FF69BD];
        
        
        // Text Annotation 1
        SCITextAnnotation *textAnnotation1 = [SCITextAnnotation new];
        textAnnotation1.x1 = @(0.25);
        textAnnotation1.y1 = @(0.75);
        textAnnotation1.text = @"Text 1\n(0.25, 0.75)";
        textAnnotation1.fontStyle = [[SCIFontStyle alloc] initWithFontSize:14 andTextColor:SCIColor.whiteColor];
        
        // Text Annotation 2
        SCITextAnnotation *textAnnotation2 = [SCITextAnnotation new];
        textAnnotation2.x1 = @(0.75);
        textAnnotation2.y1 = @(0.25);
        textAnnotation2.text = @"Text 2\n(0.75, 0.25)";
        textAnnotation2.fontStyle =
        [[SCIFontStyle alloc] initWithFontSize:14 andTextColor:SCIColor.whiteColor];
        
        // Center Text Annotation
        SCITextAnnotation *textAnnotationCenter = [SCITextAnnotation new];
        textAnnotationCenter.x1 = @(0.5);
        textAnnotationCenter.y1 = @(0.5);
        textAnnotationCenter.text = @"Center\n(0.5, 0.5)";
        textAnnotationCenter.fontStyle =
        [[SCIFontStyle alloc] initWithFontSize:14 andTextColor:SCIColor.whiteColor];
        
        // Line Annotation
        SCILineAnnotation *lineAnnotation = [SCILineAnnotation new];
        lineAnnotation.x1 = @(0.2);
        lineAnnotation.y1 = @(0.2);
        lineAnnotation.x2 = @(0.8);
        lineAnnotation.y2 = @(0.8);
        lineAnnotation.stroke =
        [[SCISolidPenStyle alloc] initWithColor:SCIColor.whiteColor thickness:2];
        
        // Add child annotations to composite
        compositeAnnotation.annotations = [[SCIAnnotationCollection alloc] initWithCollection: @[textAnnotation1, textAnnotation2, textAnnotationCenter, lineAnnotation]];
        
        // Add composite annotation
        [self.surface.annotations add:compositeAnnotation];
        
        // Regular annotation (not grouped)
        SCITextAnnotation *regularAnnotation = [SCITextAnnotation new];
        regularAnnotation.x1 = @(7.0);
        regularAnnotation.y1 = @(7.0);
        regularAnnotation.text = @"Regular Annotation\n(not grouped)";
        regularAnnotation.fontStyle =
        [[SCIFontStyle alloc] initWithFontSize:12 andTextColor:SCIColor.whiteColor];
        
        [self.surface.annotations add:regularAnnotation];
        
        MeasureXAnnotation *measure = [MeasureXAnnotation new];
        
        [measure setX1:@220.0];
        [measure setY1:@11600.0];
        [measure setX2:@250.0];
        [measure setY2:@11300.0];
        
        // Attach Drag Listener
        MeasureDragListener *dragListener =
        [[MeasureDragListener alloc] initWithMeasure:measure
                                               xAxis:xAxis];
        
        measure.annotationDragListener = dragListener;
        
        // Initial update
        id<ISCICoordinateCalculator> calc =
        xAxis.currentCoordinateCalculator;
        
        [measure updateMeasureWithXAxis:calc isCategoryAxis:calc.isCategoryAxisCalculator];
        
        // Optional: update on selection change
        measure.annotationSelectionChangedListener = ^(id<ISCIAnnotation> annotation, BOOL isSelected) {
            id<ISCICoordinateCalculator> calc =
            xAxis.currentCoordinateCalculator;
            
            [measure updateMeasureWithXAxis:calc isCategoryAxis:calc.isCategoryAxisCalculator];
        };
        
        TradeSetupAnnotation *trade =
        [[TradeSetupAnnotation alloc] initWithEntry:11500.0
                                           stopLoss:10600.0
                                         takeProfit:12200.0
                                             xIndex:215.0
                                              isBuy:YES];
        
        [self.surface.annotations addAll:compositeAnnotation, measure, trade, nil];
        
        [self.surface.chartModifiers addAll:
         [SCDExampleBaseViewController createDefaultModifiers], nil];
    }];
}

@end
