//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2026. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FreehandDrawingAnnotation.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "FreehandDrawingAnnotation.h"
#import "SCDDataManager.h"

@implementation FreehandDrawingAnnotation

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataIndu];
    NSInteger count = priceSeries.count;
    
    id<ISCIAxis> xAxis = [SCICategoryDateAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:count - 50 max:count];
    
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
    SCIOhlcDataSeries *dataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    [dataSeries appendValuesX:priceSeries.dateData open:priceSeries.openData high:priceSeries.highData low:priceSeries.lowData close:priceSeries.closeData];
    
    SCIFastCandlestickRenderableSeries *rSeries = [SCIFastCandlestickRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF67BDAF thickness:1];
    rSeries.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x7767BDAF];
    rSeries.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDC7969 thickness:1];
    rSeries.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x77DC7969];
    
    self.zoomPanModifier = [SCIZoomPanModifier new];
    self.zoomPanModifier.receiveHandledEvents = YES;
    self.zoomPanModifier.isEnabled = NO;
    
    SCIFreehandDrawingAnnotation *freehandDrawing = [SCIFreehandDrawingAnnotation new];
    [freehandDrawing appendPointWithX:@(224) y:@(11000)];
    [freehandDrawing appendPointWithX:@(250) y:@(12000)];
    [freehandDrawing appendPointWithX:@(220) y:@(11400)];
    [freehandDrawing appendPointWithX:@(224) y:@(11000)];
    freehandDrawing.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF0000 thickness:3];
    freehandDrawing.isEditable = YES;
    
    self.freeHandModifier = [SCIFreehandDrawingModifier new];
    self.freeHandModifier.stroke = [[SCISolidPenStyle alloc] initWithColorCode:self.strokeColor thickness:self.thickness];
    /// Callback triggered when all points are placed
    /// Gives access to the completed annotation object
    __weak typeof(self) weakSelf = self;
    self.freeHandModifier.annotationCreationCompletionListener = ^(id<ISCIAnnotation> _Nonnull createdAnnotation, SCIAnnotationCreationType type) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!strongSelf) return;
        
        NSLog(@"FREEHAND annotation created: %@ type %@", createdAnnotation, SCIAnnotationTypeName(type));
        
        if (![createdAnnotation isKindOfClass:[SCIFreehandDrawingAnnotation class]]) return;
        SCIFreehandDrawingAnnotation *annotation = (SCIFreehandDrawingAnnotation*) createdAnnotation;
        
        NSLog(@"draw id: %@", annotation.drawId);
        
    };
    
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.annotations add:freehandDrawing];
        [self.surface.chartModifiers addAll: self.zoomPanModifier, [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], self.freeHandModifier, nil];
    }];
}

@end
