//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SimplePolar3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class SimplePolar3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    let SizeU: Int = 30
    let SizeV: Int = 10
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.visibleRange = SCIDoubleRange(min: -7.0, max: 7.0)
        let yAxis = SCINumericAxis3D()
        yAxis.visibleRange = SCIDoubleRange(min: 0.0, max: 3.0)
        let zAxis = SCINumericAxis3D()
        zAxis.visibleRange = SCIDoubleRange(min: -7.0, max: 7.0)
        
        let meshDataSeries = SCIPolarDataSeries3D(xType: .double, heightType: .double, uSize: SizeU, vSize: SizeV, uMin: 0.0, uMax: Double.pi * 1.75)
        meshDataSeries.set(a: 1.0)
        meshDataSeries.set(b: 5.0)
        
        for u in 0 ..< SizeU {
            let weightU = 1.0 - abs(2.0 * Double(u) / Double(SizeU) - 1.0)
            for v in 0 ..< SizeV {
                let weightV = 1.0 - abs(2.0 * Double(v) / Double(SizeV) - 1.0)
                let offset =  SCDRandomUtil.nextDouble()
                meshDataSeries.setDisplacement(offset * weightU * weightV, atU: u, v: v)
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
        rSeries.paletteMinimum = SCIVector3(x: 0.0, y: 0.0, z: 0.0)
        rSeries.paletteMaximum = SCIVector3(x: 0.0, y: 0.5, z: 0.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
            
            self.surface.worldDimensions.assignX(200, y: 50, z: 200)
        }
    }
}
