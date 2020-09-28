//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// Style3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "Style3DChartView.h"

@implementation Style3DChartView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    xAxis.minorsPerMajor = 5;
    xAxis.maxAutoTicks = 7;
    xAxis.textSize = 13;
    xAxis.textColor = 0xFF00FF00;
    xAxis.textFont = @"RobotoCondensed-BoldItalic";
    xAxis.axisBandsStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFF556B2F];
    xAxis.majorTickLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00FF00 thickness:1.0];
    xAxis.majorTickLineLength = 8.0;
    xAxis.majorTickLineStyle =  [[SCISolidPenStyle alloc] initWithColorCode:0xFFC71585 thickness:1.0];
    xAxis.majorTickLineLength = 4.0;
    xAxis.majorGridLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF00FF00 thickness:1.0];
    xAxis.minorGridLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF9400D3 thickness:1.0];
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.minorsPerMajor = 5;
    yAxis.maxAutoTicks = 7;
    yAxis.textSize = 13;
    yAxis.textColor = 0xFFB22222;
    yAxis.textFont = @"RobotoCondensed-BoldItalic";
    yAxis.axisBandsStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFFF6347];
    yAxis.majorTickLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFB22222 thickness:1.0];
    yAxis.majorTickLineLength = 8.0;
    yAxis.majorTickLineStyle =  [[SCISolidPenStyle alloc] initWithColorCode:0xFFCD5C5C thickness:1.0];
    yAxis.majorTickLineLength = 4.0;
    yAxis.majorGridLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF006400 thickness:1.0];
    yAxis.minorGridLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF8CBED6 thickness:1.0];
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    zAxis.minorsPerMajor = 5;
    zAxis.maxAutoTicks = 7;
    zAxis.textSize = 13;
    zAxis.textColor = 0xFFDB7093;
    zAxis.textFont = @"RobotoCondensed-BoldItalic";
    zAxis.axisBandsStyle = [[SCISolidBrushStyle alloc] initWithColorCode:0xFFADFF2F];
    zAxis.majorTickLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFDB7093 thickness:1.0];
    zAxis.majorTickLineLength = 8.0;
    zAxis.majorTickLineStyle =  [[SCISolidPenStyle alloc] initWithColorCode:0xFF7FFF00 thickness:1.0];
    zAxis.majorTickLineLength = 4.0;
    zAxis.majorGridLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFF5F5DC thickness:1.0];
    zAxis.minorGridLineStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFFA52A2A thickness:1.0];
    
    self.surface.backgroundBrushStyle = [[SCILinearGradientBrushStyle alloc] initWithStart:CGPointMake(0.5, 1.0) end:CGPointMake(0.5, 0.0) startColorCode:0xFF3D4703 endColorCode:0x00000000];
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
    }];
}

@end
