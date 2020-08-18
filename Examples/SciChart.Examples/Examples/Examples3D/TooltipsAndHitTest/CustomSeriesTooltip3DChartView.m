//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomSeriesTooltip3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "CustomSeriesTooltip3DChartView.h"
#import <SciChart/SCISeriesTooltip3DBase+Protected.h>
#import <SciChart/SCISeriesInfo3DProviderBase+Protected.h>
#import "SCDDataManager.h"
#import "SCDRandomUtil.h"

@interface CustomXyzSerieesTooltip3D : SCIXyzSeriesTooltip3D
@end
@implementation CustomXyzSerieesTooltip3D
- (void)internalUpdate:(SCISeriesInfo3D *)seriesInfo {
    NSMutableString *tootlipText = @"This is Custom Tooltip \n".mutableCopy;
    [tootlipText appendFormat:@"Vertex id: %d\n", ((SCIXyzSeriesInfo3D *)seriesInfo).vertexId];
    [tootlipText appendFormat:@"X: %@\n", seriesInfo.formattedXValue.rawString];
    [tootlipText appendFormat:@"Y: %@\n", seriesInfo.formattedYValue.rawString];
    [tootlipText appendFormat:@"Z: %@", seriesInfo.formattedZValue.rawString];
    self.text = tootlipText;
    [self setSeriesColor:seriesInfo.seriesColor.colorARGBCode];
}
@end

@interface CustomSeriesInfo3DProvider : SCIDefaultXyzSeriesInfo3DProvider
@end
@implementation CustomSeriesInfo3DProvider

- (id<ISCISeriesTooltip3D>)getSeriesTooltipInternalWithSeriesInfo:(SCISeriesInfo3D *)seriesInfo modifierType:(Class)modifierType {
    if (modifierType == SCITooltipModifier3D.class) {
        return [[CustomXyzSerieesTooltip3D alloc] initWithSeriesInfo:seriesInfo];
    } else {
        return [super getSeriesTooltipInternalWithSeriesInfo:seriesInfo modifierType:modifierType];
    }
}
@end

@implementation CustomSeriesTooltip3DChartView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.2 max:0.2];
    xAxis.visibleRange =  [[SCIDoubleRange alloc] initWithMin:-1.1 max:1.1];
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.2 max:0.2];
    yAxis.visibleRange =  [[SCIDoubleRange alloc] initWithMin:-1.1 max:1.1];
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.2 max:0.2];
    zAxis.visibleRange =  [[SCIDoubleRange alloc] initWithMin:-1.1 max:1.1];
    
    SCIXyzDataSeries3D *ds = [[SCIXyzDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double];
    for (int i = 0; i < 500; ++i) {
        double m1 = SCDDataManager.randomBool ? -1.0 : 1.0;
        double m2 = SCDDataManager.randomBool ? -1.0 : 1.0;
        
        double x1 = SCDRandomUtil.nextDouble * m1;
        double x2 = SCDRandomUtil.nextDouble * m2;
        
        double temp = 1.0 - x1 * x1 - x2 * x2;
        
        double x = 2.0 * x1 * sqrt(temp);
        double y = 2.0 * x2 * sqrt(temp);
        double z = 1.0 - 2.0 * (x1 * x1 + x2 * x2);
        
        [ds appendX:@(x) y:@(y) z:@(z)];
    }
    
    SCISpherePointMarker3D *pointMarker = [SCISpherePointMarker3D new];
    pointMarker.fillColor = 0x88FFFFFF;
    pointMarker.size = 7.f;
    
    SCIScatterRenderableSeries3D *rSeries = [SCIScatterRenderableSeries3D new];
    rSeries.dataSeries = ds;
    rSeries.pointMarker = pointMarker;
    rSeries.seriesInfoProvider = [CustomSeriesInfo3DProvider new];
    
    SCITooltipModifier3D *toolTipModifier = [SCITooltipModifier3D new];
    toolTipModifier.receiveHandledEvents = YES;
    toolTipModifier.crosshairMode = SCICrosshairMode_Lines;
    toolTipModifier.crosshairPlanesFill = [SCIColor fromARGBColorCode:0x33FF6600];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rSeries];
        [self.surface.chartModifiers addAll:toolTipModifier, [SCIPinchZoomModifier3D new], [SCIZoomExtentsModifier3D new], [[SCIOrbitModifier3D alloc] initWithDefaultNumberOfTouches:2], nil];
    }];
}

@end
