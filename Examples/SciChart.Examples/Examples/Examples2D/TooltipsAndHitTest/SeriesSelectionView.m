//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SeriesSelectionView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SeriesSelectionView.h"
#import "SCDDataManager.h"
#import <SciChart/SCIStyleBase+Protected.h>

#pragma mark - Selected Series Style

NSString * const Stroke = @"Stroke";
NSString * const PointMarker = @"PointMarker";

@interface SelectedSeriesStyle : SCIStyleBase<id<ISCIRenderableSeries>>
- (instancetype)init;
@end
@implementation SelectedSeriesStyle {
    SCISolidPenStyle *_selectedStrokeStyle;
    id<ISCIPointMarker> _selectedPointMarker;
}

- (instancetype)init {
    self = [super initWithStyleableType:SCIRenderableSeriesBase.class];
    if (self) {
        _selectedPointMarker = [SCIEllipsePointMarker new];
        _selectedPointMarker.size = CGSizeMake(10, 10);
        _selectedPointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFF00DC];
        _selectedPointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.whiteColor thickness:1];
        
        _selectedStrokeStyle = [[SCISolidPenStyle alloc] initWithColor:SCIColor.whiteColor thickness:4];
    }
    return self;
}

- (void)applyStyleInternalTo:(id<ISCIRenderableSeries>)styleableObject {
    [self putProperty:Stroke value:styleableObject.strokeStyle intoObject:styleableObject];
    [self putProperty:PointMarker value:styleableObject.pointMarker intoObject:styleableObject];
    
    styleableObject.strokeStyle = _selectedStrokeStyle;
    styleableObject.pointMarker = _selectedPointMarker;
}

- (void)discardStyleInternalFrom:(id<ISCIRenderableSeries>)styleableObject {
    SCIPenStyle *penStyle = [self getValueFromProperty:Stroke ofType:SCISolidPenStyle.class fromObject:styleableObject];
    id<ISCIPointMarker> pointMarker = [self getValueFromProperty:PointMarker ofType:SCIEllipsePointMarker.class fromObject:styleableObject];
    
    styleableObject.strokeStyle = penStyle;
    styleableObject.pointMarker = pointMarker;
}

@end

#pragma mark - Chart Initialization

static double const SeriesPointCount = 50;
static int const SeriesCount = 80;

@implementation SeriesSelectionView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<ISCIAxis> leftAxis = [SCINumericAxis new];
    leftAxis.axisId = @"yLeftAxis";
    leftAxis.axisAlignment = SCIAxisAlignment_Left;
    
    id<ISCIAxis> rightAxis = [SCINumericAxis new];
    rightAxis.axisId = @"yRightAxis";
    rightAxis.axisAlignment = SCIAxisAlignment_Right;
    
    SCISeriesSelectionModifier *seriesSelectionModifier = [SCISeriesSelectionModifier new];
    seriesSelectionModifier.selectedSeriesStyle = [SelectedSeriesStyle new];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:leftAxis];
        [self.surface.yAxes add:rightAxis];
        [self.surface.chartModifiers add:seriesSelectionModifier];
    
        SCIColor * initialColor = SCIColor.blueColor;
        for (int i = 0; i < SeriesCount; i++) {
            SCIAxisAlignment axisAlignment = i % 2 == 0 ? SCIAxisAlignment_Left : SCIAxisAlignment_Right;
            
            SCIFastLineRenderableSeries *rSeries = [SCIFastLineRenderableSeries new];
            rSeries.dataSeries = [self generateDataSeries:axisAlignment andIndex:i];
            rSeries.yAxisId = axisAlignment == SCIAxisAlignment_Left ? @"yLeftAxis" : @"yRightAxis";
            rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:initialColor thickness:1.0];
            
            [self.surface.renderableSeries add:rSeries];
            
            CGFloat red, green, blue, alpha;
            [initialColor getRed:&red green:&green blue:&blue alpha:&alpha];
            
            CGFloat newR = red == 1.0 ? 1.0 : red + 0.0125;
            CGFloat newB = blue == 0.0 ? 0.0 : blue - 0.0125;
            initialColor = [SCIColor colorWithRed:newR green:green blue:newB alpha:alpha];
            
            [SCIAnimations sweepSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
        }
    }];
}

- (SCIXyDataSeries *)generateDataSeries:(SCIAxisAlignment)axisAlignment andIndex:(int)index {
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries.seriesName = [[NSString alloc] initWithFormat:@"Series %i", index];
    
    double gradient = axisAlignment == SCIAxisAlignment_Right ? index: -index;
    double start = axisAlignment == SCIAxisAlignment_Right ? 0.0 : 14000;
 
    SCDDoubleSeries *straightLine = [SCDDataManager getStraightLinesWithGradient:gradient yIntercept:start pointCount:SeriesPointCount];
    [dataSeries appendValuesX:straightLine.xValues y:straightLine.yValues];
    
    return dataSeries;
}

@end
