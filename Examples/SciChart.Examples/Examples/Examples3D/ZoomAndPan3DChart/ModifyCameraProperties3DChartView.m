//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ModifyCameraProperties3DChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "ModifyCameraProperties3DChartView.h"
#import "SCDCamera3DControlPanelView.h"

@implementation ModifyCameraProperties3DChartView {
    SCDCamera3DControlPanelView *_panel;
}

- (Class)associatedType { return SCIChartSurface3D.class; }

- (void)initExample {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = [SCINumericAxis3D new];
        self.surface.yAxis = [SCINumericAxis3D new];
        self.surface.zAxis = [SCINumericAxis3D new];
        [self.surface.chartModifiers add:[SCDExampleBaseViewController createDefaultModifiers3D]];
        
        [self.surface.camera setCameraUpdateListener:self];
    }];
    
    [self updatePanelFromCamera];
}

- (SCIView *)providePanel {
    SCDCamera3DControlPanelView *panel = [SCDCamera3DControlPanelView new];
    
    [panel.pitchSlider addTarget:self valueChangeAction:@selector(updateCameraFromControlPanelValues)];
    [panel.yawSlider addTarget:self valueChangeAction:@selector(updateCameraFromControlPanelValues)];
    [panel.radiusSlider addTarget:self valueChangeAction:@selector(updateCameraFromControlPanelValues)];
    [panel.fovSlider addTarget:self valueChangeAction:@selector(updateCameraFromControlPanelValues)];
    [panel.orthoWidthSlider addTarget:self valueChangeAction:@selector(updateCameraFromControlPanelValues)];
    [panel.orthoHeightSlider addTarget:self valueChangeAction:@selector(updateCameraFromControlPanelValues)];
    [panel.projectionModeSegmentControl addTarget:self valueChangeAction:@selector(updateCameraFromControlPanelValues)];
    [panel.coordinateSystemModeSegmentControl addTarget:self valueChangeAction:@selector(updateCameraFromControlPanelValues)];
    
    _panel = panel;
    return panel;
}

- (void)updateCameraFromControlPanelValues {
    __weak typeof(self) wSelf = self;
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        wSelf.surface.camera.orbitalPitch = self->_panel.pitchSlider.doubleValue;
        wSelf.surface.camera.orbitalYaw = self->_panel.yawSlider.doubleValue;
        wSelf.surface.camera.radius = self->_panel.radiusSlider.doubleValue;
        wSelf.surface.camera.fieldOfView = self->_panel.fovSlider.doubleValue;
        wSelf.surface.camera.orthoWidth = self->_panel.orthoWidthSlider.doubleValue;
        wSelf.surface.camera.orthoHeight = self->_panel.orthoHeightSlider.doubleValue;
        wSelf.surface.camera.projectionMode = self->_panel.projectionModeSegmentControl.selectedSegment == 0
            ? SCICameraProjectionMode_Perspective
            : SCICameraProjectionMode_Orthogonal;
        wSelf.surface.viewport.isLeftHandedCoordinateSystem = self->_panel.coordinateSystemModeSegmentControl.selectedSegment == 0;
    }];
    
    [self updatePanelFromCamera];
}

- (void)onCameraUpdated:(id<ISCICameraController>)camera {
    [self updatePanelFromCamera];
}

- (void)updatePanelFromCamera {
    id<ISCICameraController> camera = self.surface.camera;

    _panel.pitchSlider.doubleValue = camera.orbitalPitch;
    _panel.yawSlider.doubleValue = camera.orbitalYaw;
    _panel.radiusSlider.doubleValue = camera.radius;
    _panel.fovSlider.doubleValue = camera.fieldOfView;
    _panel.orthoHeightSlider.doubleValue = camera.orthoHeight;
    _panel.orthoWidthSlider.doubleValue = camera.orthoWidth;
    _panel.projectionModeSegmentControl.selectedSegment = camera.projectionMode == SCICameraProjectionMode_Perspective ? 0 : 1;
    _panel.coordinateSystemModeSegmentControl.selectedSegment = self.surface.viewport.isLeftHandedCoordinateSystem ? 0 : 1;
    _panel.postionLabel.text = [NSString stringWithFormat:@"X: %.1f, Y: %.1f, Z: %.1f", camera.position.x, camera.position.y, camera.position.z];

    [_panel updateUI];
}

@end
