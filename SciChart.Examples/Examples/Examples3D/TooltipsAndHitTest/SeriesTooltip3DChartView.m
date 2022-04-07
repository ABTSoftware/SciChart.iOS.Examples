//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SeriesTooltip3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SeriesTooltip3DChartView.h"
#include <GLKit/GLKMathUtils.h>

unsigned int BlueColor = 0xFF0084CF;
unsigned int RedColor = 0xFFEE1110;
int SegmentsCount = 25;

#define YAngle GLKMathDegreesToRadians(-65)
#define CosYAngle cos(YAngle)
#define SinYAngle sin(YAngle)

@implementation SeriesTooltip3DChartView

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.2 max:0.2];
    xAxis.maxAutoTicks = 5;
    xAxis.axisTitle = @"X - Axis";
    
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    yAxis.axisTitle = @"Y - Axis";
    
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.2 max:0.2];
    zAxis.axisTitle = @"Z - Axis";
    
    SCIXyzDataSeries3D *ds = [[SCIXyzDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double];
    SCIPointMetadataProvider3D *metadataProvider = [SCIPointMetadataProvider3D new];

    double rotationAngle = 360.0 / 45.0;
    double currentAngle = 0.0;
    
    for (int i = (-SegmentsCount); i < (SegmentsCount + 1); i++) {
        [self appendPoint:ds x:-4 y:i currentAngle:currentAngle];
        [self appendPoint:ds x:4 y:i currentAngle:currentAngle];
        
        SCIPointMetadata3D *metaData1 = [[SCIPointMetadata3D alloc] initWithVertexColor:BlueColor andScale:1.0];
        [metadataProvider.metadata addObject:metaData1];
        
        SCIPointMetadata3D *metaData2 = [[SCIPointMetadata3D alloc] initWithVertexColor:RedColor andScale:1.0];
        [metadataProvider.metadata addObject:metaData2];
        
        currentAngle = (int)(currentAngle + rotationAngle) % 360;
    }
    
    SCISpherePointMarker3D *pointMarker = [SCISpherePointMarker3D new];
    pointMarker.size = 8.f;
    
    SCIPointLineRenderableSeries3D *rSeries = [SCIPointLineRenderableSeries3D new];
    rSeries.dataSeries = ds;
    rSeries.pointMarker = pointMarker;
    rSeries.metadataProvider = metadataProvider;
    rSeries.isLineStrips = NO;
    rSeries.strokeThickness  = 4.0;
    
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
        
        self.surface.camera = [SCICamera3D new];
        [self.surface.camera.position assignX:-160 y:190 z:-520];
        [self.surface.camera.target assignX:-45 y:150 z:0];
        [self.surface.worldDimensions assignX:600 y:300 z:180];
    }];
}

- (void)appendPoint:(SCIXyzDataSeries3D *)ds x:(double)x y:(double)y currentAngle:(double)currentAngle {
    double radAngle = GLKMathDegreesToRadians(currentAngle);
    double temp = x * cos(radAngle);
    
    double xValue = temp * CosYAngle - y * SinYAngle;
    double yValue = temp * SinYAngle + y * CosYAngle;
    double zValue = x * sin(radAngle);
    
    [ds appendX:@(xValue) y:@(yValue) z:@(zValue)];
}

@end
