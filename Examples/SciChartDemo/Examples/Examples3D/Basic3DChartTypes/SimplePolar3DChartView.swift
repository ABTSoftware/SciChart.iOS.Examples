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

class SimplePolar3DChartView: SingleChartLayout3D {
    
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
        
        let colors: [UInt32] = [0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000]
        let stops: [Float] = [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0]
        let palette = SCIGradientColorPalette(colors: colors, stops: stops, count: 7)
        
        let rs0 = SCIFreeSurfaceRenderableSeries3D()
        rs0.dataSeries = meshDataSeries
        rs0.drawMeshAs = .solidWireframe
        rs0.stroke = 0x77228B22
        rs0.contourInterval = 0.1
        rs0.contourStroke = 0x77228B22
        rs0.strokeThickness = 2.0
        rs0.lightingFactor = 0.8
        rs0.meshColorPalette = palette
        
        rs0.paletteMinMaxMode = .relative
        rs0.paletteMinimum = SCIVector3(x: 0.0, y: 0.0, z: 0.0)
        rs0.paletteMaximum = SCIVector3(x: 0.0, y: 0.5, z: 0.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rs0)
            self.surface.chartModifiers.add(ExampleViewBase.createDefault3DModifiers())
            
            self.surface.worldDimensions.assignX(200, y: 50, z: 200)
        }
    }
}
