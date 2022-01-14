//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SurfaceMeshContours3DView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SurfaceMeshContours3DView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    override func initExample() {
        let w = 64;
        let h = 64;
        let ratio = 200.0 / 64.0;
        
        let ds = SCIUniformGridDataSeries3D(xType: .double, yType: .double, zType: .double, xSize: w, zSize: h)
        ds.set(stepX: 0.01)
        ds.set(stepZ: 0.01)
        
        for x in 0 ..< w {
            for z in 0 ..< h {
                let v = (1.0 + sin(Double(x) * 0.04 * ratio)) * 50.0 + (1.0 + sin(Double(z) * 0.1 * ratio)) * 50.0
                let cx: Double = Double(w) / 2.0
                let cy: Double = Double(h) / 2.0
                let r: Double = sqrt((Double(x) - cx) * (Double(x) - cx) + (Double(z) - cy) * (Double(z) - cy)) * ratio
                let exp: Double = Double.maximum(0.0, 1.0 - r * 0.008)
                let yValue: Double = v * exp
                
                ds.update(y: yValue, atX: x, z: z)
            }
        }
        
        let palette = SCIGradientColorPalette(
            colors: [0xFF00FFFF, 0xFF008000, 0xFF014421, 0xFFBDB76B, 0xFFDEB887, 0xFFE9967A, 0xFFADFF2F, 0xFFFF8C00, 0xFF8B4513, 0xFFA52A2A, 0xFFA52A2A],
            stops: [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        )
        
        let rSeries = SCISurfaceMeshRenderableSeries3D()
        rSeries.dataSeries = ds
        rSeries.drawMeshAs = .solidWithContours
        rSeries.contourStrokeThickness = 2.0
        rSeries.stroke = 0x77228B22
        rSeries.maximum = 150
        rSeries.strokeThickness = 2.0
        rSeries.drawSkirt = true
        rSeries.cellHardnessFactor = 1.0
        rSeries.meshColorPalette = palette
        rSeries.opacity = 0.8
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = SCINumericAxis3D()
            self.surface.yAxis = SCINumericAxis3D()
            self.surface.zAxis = SCINumericAxis3D()
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
            
            self.surface.camera.position.assignX(-1300, y: 1300, z: -1300)
            self.surface.worldDimensions.assignX(600, y: 300, z: 300)
        }
    }
}
