//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2026. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BrushModifierAnnotationView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "BrushModifierAnnotationView.h"
#import "SCDDataManager.h"

@implementation BrushModifierAnnotationView

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
    yAxis.autoRange = SCIAutoRange_Always;
    
    SCIOhlcDataSeries *dataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double];
    [dataSeries appendValuesX:priceSeries.dateData open:priceSeries.openData high:priceSeries.highData low:priceSeries.lowData close:priceSeries.closeData];
    
    SCIFastCandlestickRenderableSeries *rSeries = [SCIFastCandlestickRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF67BDAF thickness:1];
    rSeries.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x7767BDAF];
    rSeries.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDC7969 thickness:1];
    rSeries.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x77DC7969];
    
    self.zoomPanModifier = [SCIZoomPanModifier new];
    self.zoomPanModifier.isEnabled = NO;
    
    SCIFreehandDrawingAnnotation *brush = [SCIFreehandDrawingAnnotation new];
    [brush appendPointWithX:@(224) y:@(11000)];
    [brush appendPointWithX:@(250) y:@(12000)];
    [brush appendPointWithX:@(220) y:@(11400)];
    [brush appendPointWithX:@(224) y:@(11000)];
    brush.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFFFF0000 thickness:3];
    brush.isEditable = YES;
    
    self.brushModifier = [SCIFreehandDrawingModifier new];
    self.brushModifier.receiveHandledEvents = YES;
    self.brushModifier.stroke = [[SCISolidPenStyle alloc] initWithColorCode:self.strokeColor thickness:self.thickness];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.annotations add:brush];
        [self.surface.chartModifiers addAll: self.zoomPanModifier, [SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], self.brushModifier, nil];
    }];
}

@end
