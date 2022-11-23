//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DateAxis3DView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "DateAxis3DView.h"

int Temperatures[7][24] = {
    // day 1
    {
        8, 8, 7, 7, 6, 6, 6, 6,
        6, 6, 6, 7, 7, 7, 8, 9,
        9, 10, 10, 10, 10, 10, 9, 9
    },
    // day 2
    {
        9, 7, 7, 7, 6, 6, 6, 6,
        7, 7, 8, 9, 9, 12, 15, 16,
        16, 16, 17, 16, 15, 13, 12, 11,
    },
    // day 3
    {
        11, 10, 9, 11, 7, 7, 7, 9,
        11, 13, 15, 16, 17, 18, 17, 18,
        19, 19, 18, 10, 10, 11, 10, 10
    },
    // day 4
    {
        11, 10, 11, 10, 11, 10, 10, 11,
        11, 13, 13, 13, 15, 15, 15, 16,
        17, 18, 17, 17, 15, 13, 12, 11
    },
    // day 5
    {
        13, 14, 12, 12, 11, 12, 12, 12,
        13, 15, 17, 18, 20, 21, 21, 22,
        22, 21, 20, 19, 17, 16, 15, 16
    },
    // day 6
    {
        16, 16, 16, 15, 14, 14, 14, 12,
        13, 13, 14, 14, 13, 15, 15, 15,
        15, 15, 14, 15, 15, 14, 14, 14
    },
    // day 7
    {
        14, 15, 14, 13, 14, 13, 13, 14,
        14, 16, 18, 17, 16, 18, 20, 19,
        16, 16, 16, 16, 15, 14, 13, 12
    }
};

@implementation DateAxis3DView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    SCIDateAxis3D *xAxis = [SCIDateAxis3D new];
    xAxis.subDayTextFormatting = @"HH:mm";
    xAxis.maxAutoTicks = 8;
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.0 max:0.1];
    
    SCIDateAxis3D *zAxis = [SCIDateAxis3D new];
    zAxis.textFormatting = @"dd MMM";
    zAxis.maxAutoTicks = 8;
    
    const int daysCount = 7;
    const int measurementsCount = 24;
    
    SCIWaterfallDataSeries3D *ds = [[SCIWaterfallDataSeries3D alloc] initWithXType:SCIDataType_Date yType:SCIDataType_Double zType:SCIDataType_Date xSize:measurementsCount zSize:daysCount];
    ds.startX = [NSDate dateWithYear:2019 month:5 day:1];
    ds.stepX = [[NSDate alloc] initWithTimeIntervalSince1970:[SCIDateIntervalUtil fromMinutes:30]];
    ds.startZ = [NSDate dateWithYear:2019 month:5 day:1];
    ds.stepZ = [[NSDate alloc] initWithTimeIntervalSince1970:[SCIDateIntervalUtil fromDays:1]];
    
    for (int z = 0; z < daysCount; ++z) {
        int *templeratures = Temperatures[z];
        for (int x = 0; x < measurementsCount; ++x) {
            [ds updateYValue:@(templeratures[x]) atXIndex:x zIndex:z];
        }
    }
    
    unsigned int colors[5] = { 0xFFc43360, 0xFFbf7436, 0xFFe8c667, 0xFFb4efdb, 0xFF68bcae};
    float stops[5] = { 0.f, 0.25f, 0.5f, 0.75f, 1.0f};
    SCIGradientColorPalette *palette = [[SCIGradientColorPalette alloc] initWithColors:colors stops:stops count:5];
    
    SCIWaterfallRenderableSeries3D *rSeries = [SCIWaterfallRenderableSeries3D new];
    rSeries.dataSeries = ds;
    rSeries.stroke = 0xFF274b92;
    rSeries.strokeThickness = 1.0;
    rSeries.sliceThickness = 2.0;
    rSeries.yColorMapping = palette;
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
    }];
}

@end
