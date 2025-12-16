//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2025. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomModifier.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CustomModifier.h"
#import "SCDDataManager.h"
#import "DrawingModifier.h"
#import "SciChart/SCIGestureModifierBase+Protected.h"

@implementation CustomModifier

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataIndu];
    double size = priceSeries.count;
    
    SCICategoryDateAxis *xAxis = [SCICategoryDateAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0 max:0.1];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:size - 30 max:size];
    
    SCINumericAxis *yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.autoRange = SCIAutoRange_Always;
    
    // OHLC series
    SCIOhlcDataSeries *dataSeries = [[SCIOhlcDataSeries alloc] initWithXType:SCIDataType_Date
                                                               yType:SCIDataType_Double];
    [dataSeries appendValuesX:priceSeries.dateData open:priceSeries.openData high:priceSeries.highData low:priceSeries.lowData close:priceSeries.closeData];
    
    SCIFastCandlestickRenderableSeries *rSeries = [SCIFastCandlestickRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeUpStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF67BDAF thickness:1];
    rSeries.fillUpBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x7767BDAF];
    rSeries.strokeDownStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDC7969 thickness:1];
    rSeries.fillDownBrushStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0x77DC7969];
    
    _drawingModifier = [[DrawingModifier alloc] initWithSurface:self.surface
                                                       drawMode:self.drawMode
                                                 ohlcDataSeries:dataSeries];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:self->_drawingModifier];

        [SCIAnimations waveSeries:rSeries duration:1.0 andEasingFunction:[SCICubicEase new]];
    }];
    
    [self addInstructionForMarkers];
}

#if TARGET_OS_OSX
- (void)viewWillDisappear {
    [super viewWillDisappear];
    
    // Clearing gestures
    for (NSGestureRecognizer *gesture in self.view.gestureRecognizers) {
        [self.view removeGestureRecognizer:gesture];
    }
}
#endif

#pragma mark - Instructions

- (void)addInstructionForMarkers {
    self.instructionAnnotation = [SCITextAnnotation new];
    [self.instructionAnnotation setX1:@(224.0)];
    [self.instructionAnnotation setY1:@(12200.0)];
    self.instructionAnnotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Center;

#if TARGET_OS_OSX
    self.instructionAnnotation.text =
    @"Right click to remove a marker.";
#else
    self.instructionAnnotation.text =
    @"Press and hold to activate delete mode,\n"
    @"then tap the × to remove a marker.";
#endif

    self.instructionAnnotation.fontStyle =
        [[SCIFontStyle alloc] initWithFontSize:16 andTextColorCode:0xFFFFFFFF];
    
    [self.surface.annotations add:self.instructionAnnotation];
}

#pragma mark - DrawMode Change

- (void)didDragModeChange:(DrawMode)drawMode {
    self.drawMode = drawMode;
    
    // Deselect any annotation currently selected
    for (id<ISCIAnnotation> annotation in [self.surface.annotations toArray]) {
        annotation.isSelected = NO;
    }
    
    self.drawingModifier.drawMode = self.drawMode;

#if TARGET_OS_IOS
    [self.drawingModifier exitDeleteMode];
#else
    self.drawingModifier.isEditMode = NO;
#endif
    
    // Rebuild gesture recognizers for new draw mode
    [self.drawingModifier reCreateGestureRecognizer];
}

@end
