//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2026. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TradingAnnotationsView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "TradingAnnotationsView.h"
#import "SCDDataManager.h"

@implementation TradingAnnotationsView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    
    SCDPriceSeries *priceSeries = [SCDDataManager getPriceDataIndu];
    
    id<ISCIAxis> xAxis = [SCICategoryDateAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
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
        
        /// Create XABCD annotation with predefined points
        SCIXabcdAnnotation *xAbcdAnn = [SCIXabcdAnnotation new];
        [xAbcdAnn setBasePointWithX:@64 y:@12300];
        [xAbcdAnn setBasePointWithX:@70 y:@12000];
        [xAbcdAnn setBasePointWithX:@185 y:@12290];
        [xAbcdAnn setBasePointWithX:@260 y:@12290];
        [xAbcdAnn setBasePointWithX:@255 y:@12000];
        
        xAbcdAnn.fillBrush = [[SCISolidBrushStyle alloc] initWithColorCode:0x55AAAA00];
        xAbcdAnn.stroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFFE97064 thickness:2];
        xAbcdAnn.isEditable = YES;
        xAbcdAnn.showRatios = YES;
        
        /// Create Pitchfork annotation with predefined points
        SCIPitchforkAnnotation *pitchfork = [SCIPitchforkAnnotation new];
        [pitchfork setBasePointWithX:@84 y:@11700];   // pivot
        [pitchfork setBasePointWithX:@135 y:@11200];  // upper
        [pitchfork setBasePointWithX:@150 y:@11800];  // lower
        
        pitchfork.halfWidthZoneFill = [[SCISolidBrushStyle alloc] initWithColorCode:0x401E90FF];
        pitchfork.fullWidthZoneFill  = [[SCISolidBrushStyle alloc] initWithColorCode:0x4000AA00];
        pitchfork.isEditable = YES;
        
        [self.surface.annotations add: pitchfork];
        
        __weak typeof(self) weakSelf = self;
        
        /// Create Pitchfork annotation with user interaction
        self.pitchforkCreationModifier = [SCIPitchforkCreationModifier new];
        self.pitchforkCreationModifier.halfWidthZoneFill = [[SCISolidBrushStyle alloc] initWithColorCode:0x401F9FFF];
        self.pitchforkCreationModifier.fullWidthZoneFill = [[SCISolidBrushStyle alloc] initWithColorCode:0x40F0FA00];
        
        self.pitchforkCreationModifier.tineStroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFF007064 thickness:2];
        self.pitchforkCreationModifier.mainStroke = [[SCISolidPenStyle alloc] initWithColorCode:0xFF007064 thickness:2];
        
        /// Callback triggered when all points are placed
        /// Gives access to the completed annotation object
        self.pitchforkCreationModifier.annotationCreationCompletionListener = ^(id<ISCIAnnotation> _Nonnull createdAnnotation, SCIAnnotationCreationType type) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            
            NSLog(@"PITCHFORK annotation created: %@ type %@", createdAnnotation, SCIAnnotationTypeName(type));
            
            if (![createdAnnotation isKindOfClass:[SCIPitchforkAnnotation class]]) return;
            SCIPitchforkAnnotation *annotation = (SCIPitchforkAnnotation*) createdAnnotation;
            
            /// Get data points
            NSArray<SCIComparablePoint *> *arrPoints = [annotation getBaseDataValues];
            
            NSLog(@"Point A: %@", arrPoints[0]);
            NSLog(@"Point B: %@", arrPoints[1]);
            NSLog(@"Point C: %@", arrPoints[2]);
            
        };
        
        /// Create XABCD annotation with user interaction
        self.xabcdCreationModifier = [SCIXabcdCreationModifier new];
        
        self.xabcdCreationModifier.annotationStroke =
        [[SCISolidPenStyle alloc] initWithColorCode:0xFFE97064 thickness:2];
        self.xabcdCreationModifier.annotationFill =
        [[SCISolidBrushStyle alloc] initWithColorCode:0x55AAAA00];
        
        /// Callback triggered when all points (X, A, B, C, D) are placed
        /// Gives access to the completed annotation object
        self.xabcdCreationModifier.annotationCreationCompletionListener = ^(id<ISCIAnnotation> _Nonnull createdAnnotation, SCIAnnotationCreationType type) {
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (!strongSelf) return;
            
            NSLog(@"XABCD annotation created: %@ type %@", createdAnnotation, SCIAnnotationTypeName(type));
            
            if (![createdAnnotation isKindOfClass:[SCIXabcdAnnotation class]]) return;
            
            SCIXabcdAnnotation *xabcd = (SCIXabcdAnnotation *)createdAnnotation;
            NSArray<SCIComparablePoint *> *arrPoints = [xabcd getBaseDataValues];
            
            NSLog(@"XABCD point X: %@, %@", arrPoints[0].x, arrPoints[0].y);
            NSLog(@"XABCD point A: %@, %@", arrPoints[1].x, arrPoints[1].y);
            NSLog(@"XABCD point B: %@, %@", arrPoints[2].x, arrPoints[2].y);
            NSLog(@"XABCD point C: %@, %@", arrPoints[3].x, arrPoints[3].y);
            NSLog(@"XABCD point D: %@, %@", arrPoints[4].x, arrPoints[4].y);
            
        };
        
        [self.surface.annotations add:xAbcdAnn];
        [self.surface.annotations add:pitchfork];
        
        [self.surface.chartModifiers add:
         [SCDExampleBaseViewController createDefaultModifiers]];
        [self.surface.chartModifiers add:self.pitchforkCreationModifier];
        
    }];
    
    [self addInstructionForMarkers];
}

- (void)addInstructionForMarkers {
    [self.instructionAnnotation setX1:@5];
    [self.instructionAnnotation setY1:@13000];
    
    self.instructionAnnotation.verticalAnchorPoint = SCIVerticalAnchorPoint_Top;
    self.instructionAnnotation.fontStyle =
    [[SCIFontStyle alloc] initWithFontSize:15
                          andTextColorCode:0xFFFFFFFF];
    
    [self.surface.annotations add:self.instructionAnnotation];
}

@end
