//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// Cylindroid3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class Cylindroid3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }

    let SizeU: Int = 40
    let SizeV: Int = 20
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.visibleRange = SCIDoubleRange(min: -7.0, max: 7.0)
        let yAxis = SCINumericAxis3D()
        yAxis.visibleRange = SCIDoubleRange(min: -7.0, max: 7.0)
        let zAxis = SCINumericAxis3D()
        zAxis.visibleRange = SCIDoubleRange(min: -7.0, max: 7.0)
        
        let meshDataSeries = SCICylindroidDataSeries3D(xzType: .double, yType: .double, uSize: SizeU, vSize: SizeV)
        meshDataSeries.set(a: 3.0)
        meshDataSeries.set(b: 3.0)
        meshDataSeries.set(h: 7.0)
        
        for u in 0 ..< SizeU {
            for v in 0 ..< SizeV {
                let weight = 1.0 - abs(2.0 * Double(v) / Double(SizeV) - 1.0)
                let offset = 1 - SCDRandomUtil.nextDouble()
                meshDataSeries.setDisplacement(offset * weight, atU: u, v: v)
            }
        }
        
        let palette = SCIGradientColorPalette(
            colors: [0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000],
            stops: [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0]
        )
        
        let rSeries = SCIFreeSurfaceRenderableSeries3D()
        rSeries.dataSeries = meshDataSeries
        rSeries.drawMeshAs = .solidWireframe
        rSeries.stroke = 0x77228B22
        rSeries.contourInterval = 0.1
        rSeries.contourStroke = 0x77228B22
        rSeries.strokeThickness = 2.0
        rSeries.lightingFactor = 0.8
        rSeries.meshColorPalette = palette
        
        rSeries.paletteMinMaxMode = .relative
        rSeries.paletteMinimum = SCIVector3(x: 3.0, y: 0.0, z: 0.0)
        rSeries.paletteMaximum = SCIVector3(x: 4.0, y: 0.0, z: 0.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
            
            self.surface.worldDimensions.assignX(200, y: 200, z: 200)
        }
    }
}
