//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingChartModifiers3DView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "UsingChartModifiers3DView.h"
#import "TwoButtonsPanel.h"
#import "SCDDataManager.h"

@implementation UsingChartModifiers3DView

- (void)commonInit {
    TwoButtonsPanel *panel = [[TwoButtonsPanel alloc] initWithFrame:CGRectZero];
    [panel.leftButton setTitle:@"Rotate Horizontal" forState:UIControlStateNormal];
    [panel.rightButton setTitle:@"Rotate Vertical" forState:UIControlStateNormal];
    [panel.leftButton addTarget:self action:@selector(onRotateHorizontal) forControlEvents:UIControlEventTouchUpInside];
    [panel.rightButton addTarget:self action:@selector(onRotateVertical) forControlEvents:UIControlEventTouchUpInside];
    
    self.panel = panel;
}

- (void)initExample {
    SCINumericAxis3D *xAxis = [SCINumericAxis3D new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    SCINumericAxis3D *yAxis = [SCINumericAxis3D new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    SCINumericAxis3D *zAxis = [SCINumericAxis3D new];
    zAxis.growBy = [[SCIDoubleRange alloc] initWithMin:0.1 max:0.1];
    
    SCIXyzDataSeries3D *ds = [[SCIXyzDataSeries3D alloc] initWithXType:SCIDataType_Double yType:SCIDataType_Double zType:SCIDataType_Double];
    SCIPointMetadataProvider3D *metadataProvider = [SCIPointMetadataProvider3D new];
    
    const int Count = 25;
    for (int i = 0; i < Count; ++i) {
        const unsigned int color = [SCDDataManager randomColor];
        
        for (double j = 1; j < Count; ++j) {
            const double y = pow(j, 0.3);
            [ds appendX:@(i) y:@(y) z:@(j)];
            
            SCIPointMetadata3D *metadata = [[SCIPointMetadata3D alloc] initWithVertexColor:color andScale:2.0];
            [metadataProvider.metadata addObject:metadata];
        }
    }
    
    SCISpherePointMarker3D *pointMarker = [SCISpherePointMarker3D new];
    pointMarker.size = 2.f;
    
    SCIScatterRenderableSeries3D *rs = [SCIScatterRenderableSeries3D new];
    rs.dataSeries = ds;
    rs.pointMarker = pointMarker;
    rs.metadataProvider = metadataProvider;
    
    SCIZoomExtentsModifier3D *zoomExtentsModifier3D = [SCIZoomExtentsModifier3D new];
    zoomExtentsModifier3D.animationDuration = 0.8;
    zoomExtentsModifier3D.resetPosition = [[SCIVector3 alloc] initWithX:200 y:200 z:200];
    zoomExtentsModifier3D.resetTarget = [[SCIVector3 alloc] initWithX:0 y:0 z:0];
    
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = xAxis;
        self.surface.yAxis = yAxis;
        self.surface.zAxis = zAxis;
        [self.surface.renderableSeries add:rs];
        [self.surface.chartModifiers add:[SCIPinchZoomModifier3D new]];
        [self.surface.chartModifiers add:[[SCIOrbitModifier3D alloc] initWithDefaultNumberOfTouches:1]];
        [self.surface.chartModifiers add:[[SCIFreeLookModifier3D alloc] initWithDefaultNumberOfTouches:2]];
        [self.surface.chartModifiers add:zoomExtentsModifier3D];
    }];
}

- (void)onRotateHorizontal {
    id<ISCICameraController> camera = self.surface.camera;
    float orbitalYaw = camera.orbitalYaw;
    
    if (orbitalYaw < 360) {
        camera.orbitalYaw = orbitalYaw + 90;
    } else {
        camera.orbitalYaw = 360 - orbitalYaw;
    }
}

- (void)onRotateVertical {
    id<ISCICameraController> camera = self.surface.camera;
    float orbitalPitch = camera.orbitalPitch;
    
    if (orbitalPitch < 89) {
        camera.orbitalPitch = orbitalPitch + 90;
    } else {
        camera.orbitalPitch = -90;
    }
}

@end
