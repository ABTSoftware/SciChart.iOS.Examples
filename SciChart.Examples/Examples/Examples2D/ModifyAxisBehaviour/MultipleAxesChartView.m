//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// MultipleAxesChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "MultipleAxesChartView.h"
#import "SCDRandomUtil.h"

static NSString * const TopAxisId = @"xTopAxis";
static NSString * const BottomAxisId = @"xBottomAxis";
static NSString * const LeftAxisId = @"yLeftAxis";
static NSString * const RightAxisId = @"yRightAxis";

@implementation MultipleAxesChartView

- (Class)associatedType { return SCIChartSurface.class; }

- (BOOL)showDefaultModifiersInToolbar { return NO; }

- (void)initExample {
    
    id<ISCIAxis> xBottomAxis = [SCINumericAxis new];
    xBottomAxis.axisId = BottomAxisId;
    xBottomAxis.axisAlignment = SCIAxisAlignment_Bottom;
    xBottomAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColorCode:0xFFae418d];
    xBottomAxis.titleStyle = [[SCIFontStyle alloc] initWithFontSize:18 andTextColorCode:0xFFae418d];
    
    id<ISCIAxis> xTopAxis = [SCINumericAxis new];
    xTopAxis.axisId = TopAxisId;
    xTopAxis.axisAlignment = SCIAxisAlignment_Top;
    xTopAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColorCode:0xFF68bcae];
    xTopAxis.titleStyle = [[SCIFontStyle alloc] initWithFontSize:18 andTextColorCode:0xFF68bcae];
    
    id<ISCIAxis> yLeftAxis = [SCINumericAxis new];
    yLeftAxis.axisId = LeftAxisId;
    yLeftAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yLeftAxis.axisAlignment = SCIAxisAlignment_Left;
    yLeftAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColorCode:0xFFe97064];
    yLeftAxis.titleStyle = [[SCIFontStyle alloc] initWithFontSize:18 andTextColorCode:0xFFe97064];
    
    id<ISCIAxis> yRightAxis = [SCINumericAxis new];
    yRightAxis.axisId = RightAxisId;
    yRightAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yRightAxis.axisAlignment = SCIAxisAlignment_Right;
    yRightAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:12 andTextColorCode:0xFF47bde6];
    yRightAxis.titleStyle = [[SCIFontStyle alloc] initWithFontSize:18 andTextColorCode:0xFF47bde6];

    SCIModifierGroup *modifierGroup = SCDExampleBaseViewController.createDefaultModifiers;
    [modifierGroup.childModifiers addAll:[SCILegendModifier new], [SCIXAxisDragModifier new], [SCIYAxisDragModifier new], nil];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes add:xTopAxis];
        [self.surface.xAxes add:xBottomAxis];
        [self.surface.yAxes add:yLeftAxis];
        [self.surface.yAxes add:yRightAxis];
        
        [self.surface.renderableSeries add:[self getRenderableSeriesWithXAxisId:BottomAxisId yAxisId:LeftAxisId seriesName:@"Red line" color:0xFFae418d]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithXAxisId:BottomAxisId yAxisId:LeftAxisId seriesName:@"Green line" color:0xFF68bcae]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithXAxisId:TopAxisId yAxisId:RightAxisId seriesName:@"Orange line" color:0xFFe97064]];
        [self.surface.renderableSeries add:[self getRenderableSeriesWithXAxisId:TopAxisId yAxisId:RightAxisId seriesName:@"Blue line" color:0xFF47bde6]];
        
        [self.surface.chartModifiers add:modifierGroup];
    }];
}

- (SCIFastLineRenderableSeries *)getRenderableSeriesWithXAxisId:(NSString *)xAxisId yAxisId:(NSString *)yAxisId seriesName:(NSString *)seriesName color:(uint)color {
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    dataSeries.seriesName = seriesName;
    
    double randomWalk = 10;
    for (int i = 0; i < 150; i++) {
        randomWalk += [SCDRandomUtil nextDouble] - 0.498;
        [dataSeries appendX:@(i) y:@(randomWalk)];
    }
    
    SCIFastLineRenderableSeries *rSeries = [SCIFastLineRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:color thickness: 1.0];
    rSeries.xAxisId = xAxisId;
    rSeries.yAxisId = yAxisId;
    rSeries.dataSeries = dataSeries;

    [SCIAnimations sweepSeries:rSeries duration:3.0 andEasingFunction:[SCICubicEase new]];
    
    return rSeries;
}

@end
