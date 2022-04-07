//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomFreeSurface3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class CustomFreeSurface3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let radialDistanceFunc: SCIUVFunc = { u, v in 5.0 + sin(5.0 * (u + v)) }
        let azimuthalAngleFunc: SCIUVFunc = { u, _ in u }
        let polarAngleFunc: SCIUVFunc = { _, v in v }
        
        let xFunc: SCIValueFunc = { r, theta, phi in r * sin(theta) * cos(phi) }
        let yFunc: SCIValueFunc = { r, theta, phi in r * cos(theta) }
        let zFunc: SCIValueFunc = { r, theta, phi in r * sin(theta) * sin(phi) }
        
        let ds = SCICustomSurfaceDataSeries3D(xType: .double, yType: .double, zType: .double, uSize: 30, vSize: 30, radialDistanceFunc: radialDistanceFunc, azimuthalAngleFunc: azimuthalAngleFunc, polarAngleFunc: polarAngleFunc, xFunc: xFunc, yFunc: yFunc, zFunc: zFunc, uMin: 0.0, uMax: Double.pi * 2, vMin: 0, vMax: Double.pi)
        
        let palette = SCIGradientColorPalette(
            colors: [0xFF00008B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000],
            stops: [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0]
        )
        
        let rSeries = SCIFreeSurfaceRenderableSeries3D()
        rSeries.dataSeries = ds
        rSeries.drawMeshAs = .solidWireframe
        rSeries.stroke = 0x77228B22
        rSeries.contourInterval = 0.1
        rSeries.contourStroke = 0x77228B22
        rSeries.strokeThickness = 2.0
        rSeries.lightingFactor = 0.8
        rSeries.meshColorPalette = palette
        
        rSeries.paletteMinMaxMode = .relative
        rSeries.paletteMinimum = SCIVector3(x: 0.0, y: 5.0, z: 0.0)
        rSeries.paletteMaximum = SCIVector3(x: 0.0, y: 7.0, z: 0.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
        }
    }
}
