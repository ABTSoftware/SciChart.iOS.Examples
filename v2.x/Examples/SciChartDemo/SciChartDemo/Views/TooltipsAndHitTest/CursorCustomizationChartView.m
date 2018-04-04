//
//  CursorCustomizationChartView.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 8/31/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <SciChart/SciChart.h>
#import "CursorCustomizationChartView.h"
#import "DataManager.h"
#import "RandomWalkGenerator.h"

static int const PointsCount = 200;

@implementation CursorCustomizationChartView

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
        [self.surface.chartModifiers add:[self createCursorModifier]];
        
        [line1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line2 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

- (SCICursorModifier *)createCursorModifier {
    NSNumberFormatter * formatter = [NSNumberFormatter new];
    formatter.maximumFractionDigits = 1;
    
    SCITextFormattingStyle * textFormatting = [SCITextFormattingStyle new];
    textFormatting.fontSize = 12;
    textFormatting.fontName = @"Helvetica";
    textFormatting.color = [UIColor blackColor];
    
    SCICursorModifier * cursorModifier = [SCICursorModifier new];
    cursorModifier.style.numberFormatter = formatter;
    cursorModifier.style.tooltipSize = CGSizeMake(NAN, NAN);
    cursorModifier.style.colorMode = SCITooltipColorMode_Default;
    cursorModifier.style.tooltipColor = [UIColor fromARGBColorCode:0xff6495ed];
    cursorModifier.style.tooltipOpacity = 0.8;
    cursorModifier.style.dataStyle = textFormatting;
    cursorModifier.style.tooltipBorderWidth = 1;
    cursorModifier.style.tooltipBorderColor = [UIColor fromARGBColorCode:0xffe2460c];
    cursorModifier.style.cursorPen = [[SCISolidPenStyle alloc] initWithColor:[UIColor fromARGBColorCode:0xffe2460c] withThickness:0.5];
    
    cursorModifier.style.axisVerticalTooltipColor = [UIColor fromARGBColorCode:0xffe2460c];
    cursorModifier.style.axisVerticalTextStyle = textFormatting;
    cursorModifier.style.axisHorizontalTooltipColor = [UIColor fromARGBColorCode:0xffe2460c];
    cursorModifier.style.axisHorizontalTextStyle = textFormatting;
    
    return cursorModifier;
}

@end

