//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDDragAreaToZoomViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "DragAreaToZoomViewController.h"
#import "SCDRandomWalkGenerator.h"

@implementation DragAreaToZoomViewController

- (void)initExample {
    id<ISCIAxis> xAxis = [SCINumericAxis new];
    id<ISCIAxis> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCDDoubleSeries *data = [[[SCDRandomWalkGenerator new] setBias:0.0001] getRandomWalkSeries:10000];
    const id<ISCIXyDataSeries> dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    [dataSeries appendValuesX:data.xValues y:data.yValues];
    
    SCIFastLineRenderableSeries *rSeries = [SCIFastLineRenderableSeries new];
    rSeries.dataSeries = dataSeries;
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF68bcae thickness:1.0];
    
    self.rubberBand = [SCIRubberBandXyZoomModifier new];
    self.rubberBand.isXAxisOnly = self.isXAxisOnly;
    self.rubberBand.isAnimated = self.useAnimation;
    self.rubberBand.zoomExtentsY = self.zoomExtentsY;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers addAll:[SCIZoomExtentsModifier new], self.rubberBand, nil];
        
        [SCIAnimations sweepSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    }];
}

@end
