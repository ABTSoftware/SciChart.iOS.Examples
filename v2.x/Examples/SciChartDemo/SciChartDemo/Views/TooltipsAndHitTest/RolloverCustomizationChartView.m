//
//  RolloverCustomization.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 8/26/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import "RolloverCustomizationChartView.h"
#import <SciChart/SciChart.h>
#import "DataManager.h"
#import "RandomWalkGenerator.h"

static int const PointsCount = 200;

@implementation RolloverCustomizationChartView

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
        [self.surface.chartModifiers add:[self createRolloverModifier]];
        
        [line1 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [line2 addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

- (SCIRolloverModifier *)createRolloverModifier {
    SCITextFormattingStyle * textFormatting = [SCITextFormattingStyle new];
    textFormatting.fontSize = 12;
    textFormatting.fontName = @"Helvetica";
    textFormatting.color = UIColor.blackColor;
    
    SCIEllipsePointMarker * pointMarker = [SCIEllipsePointMarker new];
    pointMarker.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:UIColor.grayColor withThickness:0.5f];
    pointMarker.width = 10;
    pointMarker.height = 10;
    
    SCIRolloverModifier * rolloverModifier = [SCIRolloverModifier new];
    rolloverModifier.modifierName = @"Rollover modifier";
    rolloverModifier.style.tooltipSize = CGSizeMake(NAN, NAN);
    rolloverModifier.style.colorMode = SCITooltipColorMode_Default;
    rolloverModifier.style.tooltipColor = [UIColor fromARGBColorCode:0xffe2460c];
    rolloverModifier.style.tooltipOpacity = 0.8;
    rolloverModifier.style.dataStyle = textFormatting;
    rolloverModifier.style.tooltipBorderWidth = 1;
    rolloverModifier.style.tooltipBorderColor = [UIColor fromARGBColorCode:0xff6495ed];
    rolloverModifier.style.rolloverPen = [[SCISolidPenStyle alloc] initWithColor:UIColor.greenColor withThickness:0.5];
    rolloverModifier.style.pointMarker = pointMarker;
    rolloverModifier.style.useSeriesColorForMarker = YES;
    rolloverModifier.style.axisTooltipColor = [UIColor fromARGBColorCode:0xff6495ed];
    rolloverModifier.style.axisTextStyle = textFormatting;
    
    return rolloverModifier;
}

@end
