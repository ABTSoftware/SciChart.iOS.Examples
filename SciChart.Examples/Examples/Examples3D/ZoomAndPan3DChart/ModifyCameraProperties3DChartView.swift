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

class ModifyCameraProperties3DChartView: SCDSingleChartWithTopPanelViewController<SCIChartSurface3D>, ISCICameraUpdateListener {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }

    let panel = SCDCamera3DControlPanelView()
    
    override func initExample() {
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = SCINumericAxis3D()
            self.surface.yAxis = SCINumericAxis3D()
            self.surface.zAxis = SCINumericAxis3D()
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
            
            self.surface.camera.setCameraUpdateListener(self)
        }

        updatePanelFromCamera()
    }
    
    override func providePanel() -> SCIView? {
        panel.pitchSlider.addTarget(self, valueChangeAction: #selector(updateCameraFromControlPanelValues))
        panel.yawSlider.addTarget(self, valueChangeAction: #selector(updateCameraFromControlPanelValues))
        panel.radiusSlider.addTarget(self, valueChangeAction: #selector(updateCameraFromControlPanelValues))
        panel.fovSlider.addTarget(self, valueChangeAction: #selector(updateCameraFromControlPanelValues))
        panel.orthoHeightSlider.addTarget(self, valueChangeAction: #selector(updateCameraFromControlPanelValues))
        panel.orthoWidthSlider.addTarget(self, valueChangeAction: #selector(updateCameraFromControlPanelValues))
        panel.projectionModeSegmentControl.addTarget(self, valueChangeAction: #selector(updateCameraFromControlPanelValues))
        panel.coordinateSystemModeSegmentControl.addTarget(self, valueChangeAction: #selector(updateCameraFromControlPanelValues))
        
        return panel
    }
    
    @objc fileprivate func updateCameraFromControlPanelValues() {
        SCIUpdateSuspender.usingWith(surface) { [weak self] in
            guard let surface = self?.surface, let panel = self?.panel else { return }
            
            surface.camera.orbitalPitch = Float(panel.pitchSlider.doubleValue)
            surface.camera.orbitalYaw = Float(panel.yawSlider.doubleValue)
            surface.camera.radius = Float(panel.radiusSlider.doubleValue)
            surface.camera.fieldOfView = Float(panel.fovSlider.doubleValue)
            surface.camera.orthoWidth = Float(panel.orthoWidthSlider.doubleValue)
            surface.camera.orthoHeight = Float(panel.orthoHeightSlider.doubleValue)
            surface.camera.projectionMode = panel.projectionModeSegmentControl.selectedSegment == 0
                ? .perspective
                : .orthogonal
            surface.viewport.isLeftHandedCoordinateSystem = panel.coordinateSystemModeSegmentControl.selectedSegment == 0
        }
        
        updatePanelFromCamera()
    }
    
    func onCameraUpdated(_ camera: ISCICameraController) {
        updatePanelFromCamera()
    }
    
    fileprivate func updatePanelFromCamera() {
        let camera = surface.camera
        
        panel.pitchSlider.doubleValue = Double(camera.orbitalPitch)
        panel.yawSlider.doubleValue = Double(camera.orbitalYaw)
        panel.radiusSlider.doubleValue = Double(camera.radius)
        panel.fovSlider.doubleValue = Double(camera.fieldOfView)
        panel.orthoHeightSlider.doubleValue = Double(camera.orthoHeight)
        panel.orthoWidthSlider.doubleValue = Double(camera.orthoWidth)
        panel.projectionModeSegmentControl.selectedSegment = camera.projectionMode == .perspective ? 0 : 1
        panel.coordinateSystemModeSegmentControl.selectedSegment = surface.viewport.isLeftHandedCoordinateSystem == true ? 0 : 1
        panel.postionLabel.text = String(format: "X: %.1f, Y: %.1f, Z: %.1f", arguments: [camera.position.x, camera.position.y, camera.position.z])
        
        panel.updateUI()
    }
}
