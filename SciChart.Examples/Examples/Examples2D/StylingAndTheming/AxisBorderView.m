//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AxisBorderView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "AxisBorderView.h"

@implementation AxisBorderView

- (Class)associatedType { return SCIChartSurface.class; }

- (void)initExample {
    uint primaryColors[] = {
        0xFF4FBEE6, // Light blue
        0xFFAD3D8D, // Magenta
        0xFF6BBDAE, // Teal
        0xFFE76E63, // Coral red
        0xFF2C4B92  // Deep blue
    };
    
    float axisTitleSize = 12.0f;
    float labelSize = 10.0f;
    float tickSize = 8.0f;
    float tickThickness = 2.0f;
    
    // --- X Axes ---
    SCINumericAxis *xAxis1 = [SCINumericAxis new];
    xAxis1.axisId = @"xAxis1";
    xAxis1.axisTitle = @"X Axis";
    xAxis1.axisAlignment = SCIAxisAlignment_Bottom;
    xAxis1.drawMajorBands = NO;
    xAxis1.drawMajorGridLines = YES;
    xAxis1.drawMinorGridLines = NO;
    xAxis1.drawMajorTicks = YES;
    xAxis1.visibleRange = [[SCIDoubleRange alloc] initWithMin:-10 max:110];
    
    SCINumericAxis *xAxis2 = [SCINumericAxis new];
    xAxis2.axisId = @"xAxis2";
    xAxis2.axisTitle = @"Flipped X Axis";
    xAxis2.axisAlignment = SCIAxisAlignment_Bottom;
    xAxis2.flipCoordinates = YES;
    xAxis2.drawMajorBands = NO;
    xAxis2.drawMajorGridLines = NO;
    xAxis2.drawMinorGridLines = NO;
    xAxis2.drawMajorTicks = YES;
    xAxis2.visibleRange = [[SCIDoubleRange alloc] initWithMin:-10 max:110];
    // Apply only top border to distinguish this axis
    xAxis2.axisBorderStyle = [[SCIAxisBorderStyle alloc] initWithColor:primaryColors[1]
                                                          antiAliasing:YES
                                                          topThickness:0.8
                                                         leftThickness:0
                                                       bottomThickness:0
                                                        rightThickness:0];
    
    SCINumericAxis *xAxis3 = [SCINumericAxis new];
    xAxis3.axisId = @"xAxis3";
    xAxis3.axisTitle = @"Stacked X Axis";
    xAxis3.axisAlignment = SCIAxisAlignment_Right;
    xAxis3.drawMajorBands = NO;
    xAxis3.drawMajorGridLines = NO;
    xAxis3.drawMinorGridLines = NO;
    xAxis3.drawMajorTicks = YES;
    xAxis3.visibleRange = [[SCIDoubleRange alloc] initWithMin:-10 max:110];
    // Apply distinguish thickness for each side
    xAxis3.axisBorderStyle = [[SCIAxisBorderStyle alloc] initWithColor:primaryColors[2]
                                                          antiAliasing:YES
                                                          topThickness:1
                                                         leftThickness:0.5
                                                       bottomThickness:5
                                                        rightThickness:3];
    
    // --- Y Axes ---
    SCINumericAxis *yAxis1 = [SCINumericAxis new];
    yAxis1.axisId = @"yAxis1";
    yAxis1.axisTitle = @"Flipped Y Axis - Left Aligned";
    yAxis1.axisAlignment = SCIAxisAlignment_Left;
    yAxis1.axisTitlePlacement = SCIAxisTitlePlacement_Right;
    yAxis1.flipCoordinates = YES;
    yAxis1.drawMajorBands = NO;
    yAxis1.drawMajorGridLines = YES;
    yAxis1.drawMinorGridLines = NO;
    yAxis1.drawMajorTicks = YES;
    yAxis1.visibleRange = [[SCIDoubleRange alloc] initWithMin:-10 max:140];
    // Apply uniform border styling
    yAxis1.axisBorderStyle = [[SCIAxisBorderStyle alloc] initWithColor:primaryColors[0]
                                                             thickness:2.0];
    
    SCINumericAxis *yAxis2 = [SCINumericAxis new];
    yAxis2.axisId = @"yAxis2";
    yAxis2.axisTitle = @"Stacked Y Axis";
    yAxis2.axisAlignment = SCIAxisAlignment_Left;
    yAxis2.drawMajorBands = NO;
    yAxis2.drawMajorGridLines = NO;
    yAxis2.drawMinorGridLines = NO;
    yAxis2.drawMajorTicks = YES;
    yAxis2.visibleRange = [[SCIDoubleRange alloc] initWithMin:-10 max:140];
    // Apply uniform border styling
    yAxis2.axisBorderStyle = [[SCIAxisBorderStyle alloc] initWithColor:primaryColors[1]
                                                             thickness:8];
    
    SCINumericAxis *yAxis3 = [SCINumericAxis new];
    yAxis3.axisId = @"yAxis3";
    yAxis3.axisTitle = @"Y Axis - Top Aligned";
    yAxis3.axisAlignment = SCIAxisAlignment_Top;
    yAxis3.drawMajorBands = NO;
    yAxis3.drawMajorGridLines = NO;
    yAxis3.drawMinorGridLines = NO;
    yAxis3.drawMajorTicks = YES;
    yAxis3.visibleRange = [[SCIDoubleRange alloc] initWithMin:-10 max:140];
    // Apply only bottom border
    yAxis3.axisBorderStyle = [[SCIAxisBorderStyle alloc] initWithColor:primaryColors[2]
                                                          antiAliasing:YES
                                                          topThickness:0
                                                         leftThickness:0
                                                       bottomThickness:3
                                                        rightThickness:0];
    
    NSArray *xAxes = @[xAxis1, xAxis2, xAxis3];
    NSArray *yAxes = @[yAxis1, yAxis2, yAxis3];
    
    for (int i = 0; i < (int)xAxes.count; i++) {
        uint colorCode = primaryColors[i];
        SCINumericAxis *xAxis = xAxes[i];
        SCINumericAxis *yAxis = yAxes[i];
        
        xAxis.titleStyle = [[SCIFontStyle alloc] initWithFontSize:axisTitleSize andTextColorCode:colorCode];
        yAxis.titleStyle = [[SCIFontStyle alloc] initWithFontSize:axisTitleSize andTextColorCode:colorCode];
        
        xAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:labelSize andTextColorCode:colorCode];
        yAxis.tickLabelStyle = [[SCIFontStyle alloc] initWithFontSize:labelSize andTextColorCode:colorCode];
        
        xAxis.majorTickLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:colorCode thickness:tickThickness];
        yAxis.majorTickLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:colorCode thickness:tickThickness];
        
        xAxis.majorTickLineLength = tickSize;
        yAxis.majorTickLineLength = tickSize;
    }
    
    // --- Data Series ---
    SCIXyDataSeries *dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double];
    for (int j = 0; j < 100; j++) {
        double x = j;
        double y = sin(j * 0.1) * j + 50.0;
        [dataSeries appendX:@(x) y:@(y)];
    }
    
    // --- Line Series ---
    SCIFastLineRenderableSeries *lineSeries = [SCIFastLineRenderableSeries new];
    lineSeries.dataSeries = dataSeries;
    lineSeries.xAxisId = @"xAxis1";
    lineSeries.yAxisId = @"yAxis1";
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        [self.surface.xAxes addAll:xAxis1, xAxis2, xAxis3, nil];
        [self.surface.yAxes addAll:yAxis1, yAxis2, yAxis3, nil];
        [self.surface.renderableSeries add:lineSeries];
        [self.surface.chartModifiers addAll:[SCDExampleBaseViewController createDefaultModifiers], nil];
    }];
}

@end
