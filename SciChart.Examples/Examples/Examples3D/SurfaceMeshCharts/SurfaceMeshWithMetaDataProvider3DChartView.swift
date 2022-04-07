//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SurfaceMeshWithMetaDataProvider3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

let Size = 49

class SurfaceMeshWithMetaDataProvider3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    let UpdateMeshesInterval = 0.01
    var timer: Timer?
    
    let meshDataSeries0 = SCIUniformGridDataSeries3D(xType: .double, yType: .double, zType: .double, xSize: Size, zSize: Size)
    let meshDataSeries1 = SCIUniformGridDataSeries3D(xType: .double, yType: .double, zType: .double, xSize: Size, zSize: Size)
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.drawMajorBands = false
        xAxis.drawLabels = false
        xAxis.drawMajorGridLines = false
        xAxis.drawMajorTicks = false
        xAxis.drawMinorGridLines = false
        xAxis.drawMinorTicks = false
        xAxis.planeBorderThickness = 0.0
        
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.drawMajorBands = false
        yAxis.drawLabels = false
        yAxis.drawMajorGridLines = false
        yAxis.drawMajorTicks = false
        yAxis.drawMinorGridLines = false
        yAxis.drawMinorTicks = false
        yAxis.planeBorderThickness = 0.0
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        zAxis.drawMajorBands = false
        zAxis.drawLabels = false
        zAxis.drawMajorGridLines = false
        zAxis.drawMajorTicks = false
        zAxis.drawMinorGridLines = false
        zAxis.drawMinorTicks = false
        zAxis.planeBorderThickness = 0.0
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        
        for x in (24...48).reversed() {
            let y = pow(Double(x) - 23.7, 0.3)
            let y2 = pow(49.5 - Double(x), 0.3)
            
            meshDataSeries0.update(y: y, atX: x, z: 24)
            meshDataSeries1.update(y: y2 - 1.505, atX: x, z: 24)
        }
        
        for x in (0...24).reversed() {
            for z in (26...49).reversed() {
                let y = pow(Double(z) - 23.7, 0.3)
                let y2 = pow(50.5 - Double(z), 0.3) + 1.505

                meshDataSeries0.update(y: y, atX: x + 24, z: 49 - z)
                meshDataSeries0.update(y: y, atX: z - 1, z: 24 - x)
                
                meshDataSeries1.update(y: y2, atX: x + 24, z: 49 - z)
                meshDataSeries1.update(y: y2, atX: z - 1, z: 24 - x)
                
                meshDataSeries0.update(y: y, atX: 24 - x, z: 49 - z)
                meshDataSeries0.update(y: y, atX: 49 - z, z: 24 - x)
                
                meshDataSeries1.update(y: y2, atX: 24 - x, z: 49 - z)
                meshDataSeries1.update(y: y2, atX: 49 - z, z: 24 - x)
                
                meshDataSeries0.update(y: y, atX: x + 24, z: z - 1)
                meshDataSeries0.update(y: y, atX: z - 1, z: x + 24)
                
                meshDataSeries1.update(y: y2, atX: x + 24, z: z - 1)
                meshDataSeries1.update(y: y2, atX: z - 1, z: x + 24)
                
                meshDataSeries0.update(y: y, atX: 24 - x, z: z - 1)
                meshDataSeries0.update(y: y, atX: 49 - z, z: 24 + x)
                
                meshDataSeries1.update(y: y2, atX: 24 - x, z: z - 1)
                meshDataSeries1.update(y: y2, atX: 49 - z, z: 24 + x)
            }
        }
        
        let colors: [UInt32] = [0xFF00008B, 0xFF0000FF, 0xFF5F9EA0, 0xFF00FFFF, 0xFF32CD32, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF6347, 0xFFCD5C5C, 0xFFFF0000, 0xFF8B0000]
        let stops: [Float] = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
        let palette0 = SCIGradientColorPalette(colors: colors, stops: stops)
        let palette1 = SCIGradientColorPalette(colors: colors, stops: stops)
        
        let rSeries = SCISurfaceMeshRenderableSeries3D()
        rSeries.dataSeries = meshDataSeries0
        rSeries.drawMeshAs = .solidMesh
        rSeries.drawSkirt = false
        rSeries.meshColorPalette = palette0
        rSeries.metadataProvider = SurfaceMeshMetaDataProvider3D()
        
        let rSeries1 = SCISurfaceMeshRenderableSeries3D()
        rSeries1.dataSeries = meshDataSeries1
        rSeries1.drawMeshAs = .solidMesh
        rSeries1.drawSkirt = false
        rSeries1.meshColorPalette = palette1
        rSeries1.metadataProvider = SurfaceMeshMetaDataProvider3D()
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(items: rSeries, rSeries1)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: UpdateMeshesInterval, repeats: true, block: { [weak self] (timer) in
            guard let sSurface = self?.surface else { return }
            SCIUpdateSuspender.usingWith(sSurface) {
                rSeries.invalidateMetadata()
                rSeries1.invalidateMetadata()
            }
        })
    }
    
    private class SurfaceMeshMetaDataProvider3D: SCIMetadataProvider3DBase<SCISurfaceMeshRenderableSeries3D>, ISCISurfaceMeshMetadataProvider3D {
        
        init() {
            super.init(renderableSeriesType: SCISurfaceMeshRenderableSeries3D.self)
        }
        
        func updateMeshColors(_ cellColors: SCIUnsignedIntegerValues) {
            guard let currentRenderPassData = renderableSeries?.currentRenderPassData as? SCISurfaceMeshRenderPassData3D else {
                return
            }
            
            let countX = currentRenderPassData.countX - 1
            let countZ = currentRenderPassData.countZ - 1
            
            cellColors.count = currentRenderPassData.pointsCount
            for x in 0 ..< countX {
                for z in 0 ..< countX {
                    let index = x * countZ + z;
                    var color: UInt32 = 0;
                    if  ((x >= 20 && x <= 26 && z > 0 && z < 47) || (z >= 20 && z <= 26 && x > 0 && x < 47)) {
                        color = 0x00FFFFFF;
                    } else {
                        color = SCDDataManager.randomColor()
                    }
                    
                    cellColors.set(color, at: index)
                }
            }
        }
    }
}
