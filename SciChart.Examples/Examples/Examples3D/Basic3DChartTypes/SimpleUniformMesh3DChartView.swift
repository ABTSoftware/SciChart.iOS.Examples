//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SimpleUniformMesh3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SimpleUniformMesh3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    let Size: Int = 25
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.visibleRange = SCIDoubleRange(min: 0, max: 0.3)
        
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let ds = SCIUniformGridDataSeries3D(xType: .double, yType: .double, zType: .double, xSize: Size, zSize: Size)
        
        for x in 0 ..< Size {
            for z in 0 ..< Size {
                let xVal = Double(25 * x / Size)
                let zVal = Double(25 * z / Size)
                let y = sin(xVal * 0.2) / ((zVal + 1.0) * 2.0)
                ds.update(y: y, atX: x, z: z)
            }
        }
        
        let palette = SCIGradientColorPalette(
            colors: [0xFF274b92, 0xFFb4bfed, 0xFF84d2f6, 0xFFe2f4fd, 0xFF67e5b5, 0xFFc43360, 0xFFd6dee8],
            stops: [0, 0.1, 0.3, 0.5, 0.7, 0.9, 1]
        )
        
        let rSeries = SCISurfaceMeshRenderableSeries3D()
        rSeries.dataSeries = ds
        rSeries.drawMeshAs = .solidWireframe
        rSeries.stroke = 0x7747bde6
        rSeries.contourStroke = 0x7747bde6
        rSeries.strokeThickness = 2.0
        rSeries.drawSkirt = false
        rSeries.meshColorPalette = palette
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
        }
    }
}
