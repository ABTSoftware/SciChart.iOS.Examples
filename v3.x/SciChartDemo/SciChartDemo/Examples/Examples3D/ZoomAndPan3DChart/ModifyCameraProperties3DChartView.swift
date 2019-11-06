//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ModifyCameraProperties3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class ModifyCameraProperties3DChartView: TopPanel3DChartLayout {

    let cameraControlPanel = Camera3DControlPanelView(frame: .zero)
        
    override func commonInit() {
        cameraControlPanel.pitchSlider?.addTarget(self, action: #selector(updateCameraFromControlPanelValues), for: .valueChanged)
        cameraControlPanel.yawSlider?.addTarget(self, action: #selector(updateCameraFromControlPanelValues), for: .valueChanged)
        cameraControlPanel.radiusSlider?.addTarget(self, action: #selector(updateCameraFromControlPanelValues), for: .valueChanged)
        cameraControlPanel.fovSlider?.addTarget(self, action: #selector(updateCameraFromControlPanelValues), for: .valueChanged)
        cameraControlPanel.orthoHeightSlider?.addTarget(self, action: #selector(updateCameraFromControlPanelValues), for: .valueChanged)
        cameraControlPanel.orthoWidthSlider?.addTarget(self, action: #selector(updateCameraFromControlPanelValues), for: .valueChanged)
        cameraControlPanel.projectionModeSegmentControl?.addTarget(self, action: #selector(updateCameraFromControlPanelValues), for: .valueChanged)
        cameraControlPanel.coordinateSystemModeSegmentControl?.addTarget(self, action: #selector(updateCameraFromControlPanelValues), for: .valueChanged)
        
        self.panel = cameraControlPanel;
    }
    
    override func initExample() {
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = SCINumericAxis3D()
            self.surface.yAxis = SCINumericAxis3D()
            self.surface.zAxis = SCINumericAxis3D()
            self.surface.chartModifiers.add(ExampleViewBase.createDefault3DModifiers())
            
            self.surface.camera.setCameraUpdateListener(self)
        }

        updatePanelFromCamera()
    }
    
    private func updatePanelFromCamera() {
        let camera = surface.camera
        
        cameraControlPanel.pitchSlider?.value = camera.orbitalPitch
        cameraControlPanel.yawSlider?.value = camera.orbitalYaw
        cameraControlPanel.radiusSlider?.value = camera.radius
        cameraControlPanel.fovSlider?.value = camera.fieldOfView
        cameraControlPanel.orthoHeightSlider?.value = camera.orthoHeight
        cameraControlPanel.orthoWidthSlider?.value = camera.orthoWidth
        cameraControlPanel.projectionModeSegmentControl?.selectedSegmentIndex = camera.projectionMode == .perspective ? 0 : 1
        cameraControlPanel.coordinateSystemModeSegmentControl?.selectedSegmentIndex = surface.viewport.isLeftHandedCoordinateSystem == true ? 0 : 1
        cameraControlPanel.postionLabel?.text = String(format: "X: %.1f, Y: %.1f, Z: %.1f", arguments: [camera.position.x, camera.position.y, camera.position.z])
        
        cameraControlPanel.updateUI()
    }
    
    @objc private func updateCameraFromControlPanelValues() {
        guard let pitchSlider = cameraControlPanel.pitchSlider,
            let yavSlider = cameraControlPanel.yawSlider,
            let radiusSlider = cameraControlPanel.radiusSlider,
            let fovSlider = cameraControlPanel.fovSlider,
            let projctionModeSegment = cameraControlPanel.projectionModeSegmentControl,
            let coordinateModeSegment = cameraControlPanel.coordinateSystemModeSegmentControl,
            let orthoWidthSlider = cameraControlPanel.orthoWidthSlider,
            let orthoHeightSlider = cameraControlPanel.orthoHeightSlider else {
                return
        }
        
        SCIUpdateSuspender.usingWith(surface) { [weak self] in
            self?.surface.camera.orbitalPitch = pitchSlider.value
            self?.surface.camera.orbitalYaw = yavSlider.value
            self?.surface.camera.radius = radiusSlider.value
            self?.surface.camera.fieldOfView = fovSlider.value
            self?.surface.camera.orthoWidth = orthoWidthSlider.value
            self?.surface.camera.orthoHeight = orthoHeightSlider.value
            self?.surface.camera.projectionMode = projctionModeSegment.selectedSegmentIndex == 0 ? .perspective : .orthogonal
            self?.surface.viewport.isLeftHandedCoordinateSystem = coordinateModeSegment.selectedSegmentIndex == 0
        }
    }
}

extension ModifyCameraProperties3DChartView: ISCICameraUpdateListener {
    func onCameraUpdated(_ camera: ISCICameraController) {
        self.updatePanelFromCamera()
    }
}
