//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TooltipCustomizationChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <SciChart/SciChart.h>
#import "TooltipCustomizationChartView.h"
#import "DataManager.h"
#import "RandomWalkGenerator.h"

static int const PointsCount = 200;

@implementation TooltipCustomizationChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    
    RandomWalkGenerator * randomWalkGenerator = [RandomWalkGenerator new];
    DoubleSeries * data1 = [randomWalkGenerator getRandomWalkSeries:PointsCount];
    [randomWalkGenerator reset];
    DoubleSeries * data2 = [randomWalkGenerator getRandomWalkSeries:PointsCount];
    
    SCIXyDataSeries * ds1 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds1.seriesName = @"Series #1";
    SCIXyDataSeries * ds2 = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double YType:SCIDataType_Double];
    ds2.seriesName = @"Series #2";
    
    [ds1 appendRangeX:data1.xValues Y:data1.yValues Count:data1.size];
    [ds2 appendRangeX:data2.xValues Y:data2.yValues Count:data2.size];
    
    SCIFastLineRenderableSeries * line1 = [SCIFastLineRenderableSeries new];
    line1.dataSeries = ds1;
    line1.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xff6495ed withThickness:2];
    
    SCIFastLineRenderableSeries * line2 = [SCIFastLineRenderableSeries new];
    line2.dataSeries = ds2;
    line2.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xffe2460c withThickness:2];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:line1];
        [self.surface.renderableSeries add:line2];
        [self.surface.chartModifiers add:[self createTooltipModifier]];
        
        [line1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line2 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

- (SCITooltipModifier *)createTooltipModifier {
    SCITextFormattingStyle * textFormatting = [SCITextFormattingStyle new];
    textFormatting.fontSize = 14;
    textFormatting.fontName = @"Helvetica";
    textFormatting.color = UIColor.blackColor;
    
    SCIEllipsePointMarker * pointMarker = [SCIEllipsePointMarker new];
    pointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:[UIColor grayColor] withThickness:0.5f];
    pointMarker.width = 10;
    pointMarker.height = 10;
    
    SCITooltipModifier * tooltipModifier = [SCITooltipModifier new];
    tooltipModifier.style.tooltipSize = CGSizeMake(NAN, NAN);
    tooltipModifier.style.colorMode = SCITooltipColorMode_Default;
    tooltipModifier.style.tooltipColor = [UIColor fromARGBColorCode:0xff6495ed];
    tooltipModifier.style.tooltipOpacity = 0.8;
    tooltipModifier.style.dataStyle = textFormatting;
    tooltipModifier.style.tooltipBorderWidth = 1;
    tooltipModifier.style.tooltipBorderColor = [UIColor fromARGBColorCode:0xffe2460c];
    tooltipModifier.style.targetMarker = pointMarker;
    
    return tooltipModifier;
}

@end
