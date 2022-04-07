//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SurfaceMesh3DFloorAndCeilingChatView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SurfaceMesh3DFloorAndCeilingChatView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    override func initExample() {
        let xSize: Int = 11
        let zSize: Int = 4
        
        let xAxis = SCINumericAxis3D()
        xAxis.maxAutoTicks = 7
        let yAxis = SCINumericAxis3D()
        yAxis.visibleRange = SCIDoubleRange(min: -4, max: 4)
        let zAxis = SCINumericAxis3D()
        
        let ds = SCIUniformGridDataSeries3D(xType: .double, yType: .double, zType: .double, xSize: xSize, zSize: zSize)
        ds.set(startX: 0)
        ds.set(stepX: 0.09)
        ds.set(startZ: 1)
        ds.set(stepZ: 0.75)
        
        let data = [
            [-1.43, -2.95, -2.97, -1.81, -1.33, -1.53, -2.04, 2.08, 1.94, 1.42, 1.58],
            [1.77, 1.76, -1.1, -0.26, 0.72, 0.64, 3.26, 3.2, 3.1, 1.94, 1.54],
            [0, 0, 0, 0, 0, 3.7, 3.7, 3.7, 3.7, -0.48, -0.48],
            [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
        ]
        
        for z in 0 ..< zSize {
            for x in 0 ..< xSize {
                ds.update(y: data[z][x], atX: x, z: z)
            }
        }
        
        let palette = SCIGradientColorPalette(
            colors: [0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000],
            stops: [0.0, 0.1, 0.2, 0.4, 0.6, 0.8, 1.0]
        )
        
        let rSeries = SCISurfaceMeshRenderableSeries3D()
        rSeries.dataSeries = ds
        rSeries.heightScaleFactor = 0.0
        rSeries.drawMeshAs = .solidWireframe
        rSeries.stroke = 0xFF228B22
        rSeries.strokeThickness = 2.0
        rSeries.maximum = 4
        rSeries.meshColorPalette = palette
        rSeries.opacity = 0.7
        
        let rSeries1 = SCISurfaceMeshRenderableSeries3D()
        rSeries1.dataSeries = ds
        rSeries1.drawMeshAs = .solidWireframe
        rSeries1.stroke = 0xFF228B22
        rSeries1.strokeThickness = 2.0
        rSeries1.maximum = 4
        rSeries1.drawSkirt = false
        rSeries1.meshColorPalette = palette
        rSeries1.opacity = 0.9

        let rSeries2 = SCISurfaceMeshRenderableSeries3D()
        rSeries2.dataSeries = ds
        rSeries2.heightScaleFactor = 0.0
        rSeries2.drawMeshAs = .solidWireframe
        rSeries2.stroke = 0xFF228B22
        rSeries2.strokeThickness = 2.0
        rSeries2.maximum = 4
        rSeries2.yOffset = 400
        rSeries2.meshColorPalette = palette
        rSeries2.opacity = 0.7

        let zoomExtents = SCIZoomExtentsModifier3D()
        zoomExtents.resetPosition = SCIVector3(x: -1300, y: 1300, z: -1300)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(items: rSeries, rSeries1, rSeries2)
            self.surface.chartModifiers.add(items: SCIPinchZoomModifier3D(), SCIOrbitModifier3D(), zoomExtents)
            
            self.surface.camera = SCICamera3D()
            self.surface.camera.position.assignX(-1300, y: 1300, z: -1300)
            self.surface.worldDimensions.assignX(1100, y: 400, z: 400)
        }
    }
}
