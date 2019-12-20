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
#import "Camera3DControlPanelView.h"

@implementation ModifyCameraProperties3DChartView {
    Camera3DControlPanelView *_panel;
}

- (void)commonInit {
    _panel = [Camera3DControlPanelView new];
    [_panel.pitchSlider addTarget:self action:@selector(updateCameraFromControlPanelValues) forControlEvents:UIControlEventValueChanged];
    [_panel.yawSlider addTarget:self action:@selector(updateCameraFromControlPanelValues) forControlEvents:UIControlEventValueChanged];
    [_panel.radiusSlider addTarget:self action:@selector(updateCameraFromControlPanelValues) forControlEvents:UIControlEventValueChanged];
    [_panel.fovSlider addTarget:self action:@selector(updateCameraFromControlPanelValues) forControlEvents:UIControlEventValueChanged];
    [_panel.orthoWidthSlider addTarget:self action:@selector(updateCameraFromControlPanelValues) forControlEvents:UIControlEventValueChanged];
    [_panel.orthoHeightSlider addTarget:self action:@selector(updateCameraFromControlPanelValues) forControlEvents:UIControlEventValueChanged];
    [_panel.projectionModeSegmentControl addTarget:self action:@selector(updateCameraFromControlPanelValues) forControlEvents:UIControlEventValueChanged];
    [_panel.coordinateSystemModeSegmentControl addTarget:self action:@selector(updateCameraFromControlPanelValues) forControlEvents:UIControlEventValueChanged];
    
    self.panel = _panel;
}

- (void)initExample {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.xAxis = [SCINumericAxis3D new];
        self.surface.yAxis = [SCINumericAxis3D new];
        self.surface.zAxis = [SCINumericAxis3D new];
        [self.surface.chartModifiers add:ExampleViewBase.createDefault3DModifiers];
        
        [self.surface.camera setCameraUpdateListener:self];
    }];
    
    [self updatePanelFromCamera];
}

- (void)updateCameraFromControlPanelValues {
    [SCIUpdateSuspender usingWithSuspendable:self.surface withBlock:^{
        self.surface.camera.orbitalPitch = _panel.pitchSlider.value;
        self.surface.camera.orbitalYaw = _panel.yawSlider.value;
        self.surface.camera.radius = _panel.radiusSlider.value;
        self.surface.camera.fieldOfView = _panel.fovSlider.value;
        self.surface.camera.orthoWidth = _panel.orthoWidthSlider.value;
        self.surface.camera.orthoHeight = _panel.orthoHeightSlider.value;
        self.surface.camera.projectionMode = _panel.projectionModeSegmentControl.selectedSegmentIndex == 0
            ? SCICameraProjectionMode_Perspective
            : SCICameraProjectionMode_Orthogonal;
        self.surface.viewport.isLeftHandedCoordinateSystem = _panel.coordinateSystemModeSegmentControl.selectedSegmentIndex == 0;
    }];
}

- (void)updatePanelFromCamera {
    id<ISCICameraController> camera = self.surface.camera;
    
    _panel.pitchSlider.value = camera.orbitalPitch;
    _panel.yawSlider.value = camera.orbitalYaw;
    _panel.radiusSlider.value = camera.radius;
    _panel.fovSlider.value = camera.fieldOfView;
    _panel.orthoHeightSlider.value = camera.orthoHeight;
    _panel.orthoWidthSlider.value = camera.orthoWidth;
    _panel.projectionModeSegmentControl.selectedSegmentIndex = camera.projectionMode == SCICameraProjectionMode_Perspective ? 0 : 1;
    _panel.coordinateSystemModeSegmentControl.selectedSegmentIndex = self.surface.viewport.isLeftHandedCoordinateSystem ? 0 : 1;
    _panel.postionLabel.text = [NSString stringWithFormat:@"X: %.1f, Y: %.1f, Z: %.1f", camera.position.x, camera.position.y, camera.position.z];
    
    [_panel updateUI];
}

- (void)onCameraUpdated:(id<ISCICameraController>)camera {
    [self updatePanelFromCamera];
}

@end
