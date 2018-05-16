//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FanChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "FanChartView.h"
#import "RandomWalkGenerator.h"

@interface VarPoint : NSObject

@property(readonly, nonatomic) NSDate * date;
@property(readonly, nonatomic) double actual;
@property(readonly, nonatomic) double varMax;
@property(readonly, nonatomic) double var4;
@property(readonly, nonatomic) double var3;
@property(readonly, nonatomic) double var2;
@property(readonly, nonatomic) double var1;
@property(readonly, nonatomic) double varMin;

- (instancetype)initWithDate:(NSDate *)date actual:(double)actual var4:(double)var4 var3:(double)var3 var2:(double)var2 var1:(double)var1 varMin:(double)varMin varMax:(double)varMax;

@end

@implementation VarPoint

- (instancetype)initWithDate:(NSDate *)date actual:(double)actual var4:(double)var4 var3:(double)var3 var2:(double)var2 var1:(double)var1 varMin:(double)varMin varMax:(double)varMax {
    self = [super init];
    if (self) {
        _date = date;
        _actual = actual;
        _var4 = var4;
        _var3 = var3;
        _var2 = var2;
        _var1 = var1;
        _varMin = varMin;
        _varMax = varMax;
    }
    return self;
}

@end

@implementation FanChartView

- (void)initExample {
    id<SCIAxis2DProtocol> xAxis = [SCIDateTimeAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    
    SCIXyDataSeries * actualDataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
    SCIXyyDataSeries * var3DataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
    SCIXyyDataSeries * var2DataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
    SCIXyyDataSeries * var1DataSeries = [[SCIXyyDataSeries alloc] initWithXType:SCIDataType_DateTime YType:SCIDataType_Double];
    
    NSArray * varianceData = [self getVarianceData];
    for (int i = 0; i < varianceData.count; i++) {
        VarPoint * dataPoint = (VarPoint *)[varianceData objectAtIndex:i];

        [actualDataSeries appendX:SCIGeneric(dataPoint.date) Y:SCIGeneric(dataPoint.actual)];
        [var3DataSeries appendX:SCIGeneric(dataPoint.date) Y1:SCIGeneric(dataPoint.varMin) Y2:SCIGeneric(dataPoint.varMax)];
        [var2DataSeries appendX:SCIGeneric(dataPoint.date) Y1:SCIGeneric(dataPoint.var1) Y2:SCIGeneric(dataPoint.var4)];
        [var1DataSeries appendX:SCIGeneric(dataPoint.date) Y1:SCIGeneric(dataPoint.var2) Y2:SCIGeneric(dataPoint.var3)];
    }

    SCIFastBandRenderableSeries * projectedVar3 = [SCIFastBandRenderableSeries new];
    projectedVar3.dataSeries = var3DataSeries;
    projectedVar3.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:UIColor.clearColor withThickness:1];
    projectedVar3.strokeY1Style = [[SCISolidPenStyle alloc] initWithColor:UIColor.clearColor withThickness:1];
    projectedVar3.fillY1BrushStyle  = [[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:1.f green:0.4f blue:0.4f alpha:0.5]];
    
    SCIFastBandRenderableSeries * projectedVar2 = [SCIFastBandRenderableSeries new];
    projectedVar2.dataSeries = var2DataSeries;
    projectedVar2.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:UIColor.clearColor withThickness:1];
    projectedVar2.strokeY1Style = [[SCISolidPenStyle alloc] initWithColor:UIColor.clearColor withThickness:1];
    projectedVar2.fillY1BrushStyle  = [[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:1.f green:0.4f blue:0.4f alpha:0.5]];
    
    SCIFastBandRenderableSeries * projectedVar1 = [SCIFastBandRenderableSeries new];
    projectedVar1.dataSeries = var1DataSeries;
    projectedVar1.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:UIColor.clearColor withThickness:1];
    projectedVar1.strokeY1Style = [[SCISolidPenStyle alloc] initWithColor:UIColor.clearColor withThickness:1];
    projectedVar1.fillY1BrushStyle  = [[SCISolidBrushStyle alloc] initWithColor:[UIColor colorWithRed:1.f green:0.4f blue:0.4f alpha:0.5]];
    
    SCIFastLineRenderableSeries * lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = actualDataSeries;
    lineSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColor:UIColor.redColor withThickness:1];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xAxis];
        [self.surface.yAxes add:yAxis];
        [self.surface.renderableSeries add:projectedVar3];
        [self.surface.renderableSeries add:projectedVar2];
        [self.surface.renderableSeries add:projectedVar1];
        [self.surface.renderableSeries add:lineSeries];
        self.surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIZoomPanModifier new], [SCIZoomExtentsModifier new], [SCIPinchZoomModifier new]]];
        
        [projectedVar3 addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [projectedVar2 addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [projectedVar1 addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        [lineSeries addAnimation:[[SCIWaveRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}

// Create a table of Variance data. Each row in the table consists of
//
//  DateTime, Actual (Y-Value), Projected Min, Variance 1, 2, 3, 4 and Projected Maximum
//
//        DateTime    Actual     Min     Var1    Var2    Var3    Var4    Max
//        Jan-11      y0        -        -        -        -        -        -
//        Feb-11      y1        -        -        -        -        -        -
//        Mar-11      y2        -        -        -        -        -        -
//        Apr-11      y3        -        -        -        -        -        -
//        May-11      y4        -        -        -        -        -        -
//        Jun-11      y5        min0  var1_0  var2_0  var3_0  var4_0  max_0
//        Jul-11      y6        min1  var1_1  var2_1  var3_1  var4_1  max_1
//        Aug-11      y7        min2  var1_2  var2_2  var3_2  var4_2  max_2
//        Dec-11      y8        min3  var1_3  var2_3  var3_3  var4_3  max_3
//        Jan-12      y9        min4  var1_4  var2_4  var3_4  var4_4  max_4
- (NSArray *)getVarianceData {
    NSMutableArray * result = [NSMutableArray new];
    
    int count = 10;
    NSDate * date = [NSDate date];
    double yValue;
    
    SCIArrayController * yValues = [[[RandomWalkGenerator new] getRandomWalkSeries:count] getYArray];
    
    for (int i = 0; i <= count; i++) {
        date = [date dateByAddingTimeInterval: 3600*24];
        yValue = SCIGenericDouble([yValues valueAt:i]);
        
        double varMax = NAN;
        double var4 = NAN;
        double var3 = NAN;
        double var2 = NAN;
        double var1 = NAN;
        double varMin = NAN;
        
        if (i > 4) {
            varMax = yValue + (i - 5) * 0.3;
            var4 = yValue + (i - 5) * 0.2;
            var3 = yValue + (i - 5) * 0.1;
            var2 = yValue - (i - 5) * 0.1;
            var1 = yValue - (i - 5) * 0.2;
            varMin = yValue - (i - 5) * 0.3;
        }
        
        [result addObject:[[VarPoint alloc] initWithDate:date actual:yValue var4:var4 var3:var3 var2:var2 var1:var1 varMin:varMin varMax:varMax]];
    }
    
    return result;
}

@end
