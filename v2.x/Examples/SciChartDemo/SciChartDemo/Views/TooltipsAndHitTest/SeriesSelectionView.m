//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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
#import <SciChart/SciChart.h>
#import "DataManager.h"

static double const SeriesPointCount = 50;
static int const SeriesCount = 80;

@implementation SeriesSelectionView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.autoRange = SCIAutoRange_Always;
    
    id<SCIAxis2DProtocol> leftAxis = [SCINumericAxis new];
    leftAxis.axisId = @"yLeftAxis";
    leftAxis.axisAlignment = SCIAxisAlignment_Left;
    
    id<SCIAxis2DProtocol> rightAxis = [SCINumericAxis new];
    rightAxis.axisId = @"yRightAxis";
    rightAxis.axisAlignment = SCIAxisAlignment_Right;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:leftAxis];
        [self.surface.yAxes add:rightAxis];
        [self.surface.chartModifiers add:[SCISeriesSelectionModifier new]];
    
        UIColor * initialColor = [UIColor blueColor];
        for (int i = 0; i < SeriesCount; i++) {
            SCIAxisAlignment axisAlignment = i % 2 == 0 ? SCIAxisAlignment_Left : SCIAxisAlignment_Right;
            
            SCIXyDataSeries * dataSeries = [self generateDataSeries:axisAlignment andIndex:i];
            
            SCIEllipsePointMarker * pointMarker = [SCIEllipsePointMarker new];
            pointMarker.fillStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFF00DC];
            pointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColor: [UIColor whiteColor] withThickness:1.0];
            pointMarker.height = 10;
            pointMarker.width = 10;
        
            SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
            rSeries.dataSeries = dataSeries;
            rSeries.yAxisId = axisAlignment == SCIAxisAlignment_Left ? @"yLeftAxis" : @"yRightAxis";
            rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:initialColor withThickness:1.0];
            rSeries.selectedStyle = rSeries.style;
            rSeries.selectedStyle.pointMarker = pointMarker;
            rSeries.hitTestProvider.hitTestMode = SCIHitTest_Interpolate;
            
            [self.surface.renderableSeries add:rSeries];
            
            CGFloat red, green, blue, alpha;
            [initialColor getRed:&red green:&green blue:&blue alpha:&alpha];
            
            CGFloat newR = red == 1.0 ? 1.0 : red + 0.0125;
            CGFloat newB = blue == 0.0 ? 0.0 : blue - 0.0125;
            initialColor = [[UIColor alloc] initWithRed:newR green:green blue:newB alpha:alpha];
            
            [rSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        }
    }];
}

- (SCIXyDataSeries *)generateDataSeries:(SCIAxisAlignment)axisAlignment andIndex:(int)index {
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    dataSeries.seriesName = [[NSString alloc] initWithFormat:@"Series %i", index];
    
    double gradient = axisAlignment == SCIAxisAlignment_Right ? index: -index;
    double start = axisAlignment == SCIAxisAlignment_Right ? 0.0 : 14000;
 
    DoubleSeries * straightLine = [DataManager getStraightLinesWithGradient:gradient yIntercept:start pointCount:SeriesPointCount];
    [dataSeries appendRangeX:straightLine.xValues Y:straightLine.yValues Count:straightLine.size];
    
    return dataSeries;
}

@end
