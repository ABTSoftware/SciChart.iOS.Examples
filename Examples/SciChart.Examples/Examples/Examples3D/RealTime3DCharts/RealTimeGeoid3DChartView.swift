//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealTimeGeoid3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class RealTimeGeoid3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    private let Size: UInt32 = 100
    private let HeightOffsetScale = 0.5
    private var frames = 0
    private let buffer = SCIDoubleValues()
    private var timer: Timer!
    private var globeHeightMap: SCIDoubleValues!
    private var ds: SCIEllipsoidDataSeries3D!
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.visibleRange = SCIDoubleRange(min: -8.0, max: 8.0)
        xAxis.autoRange = .never
        
        let yAxis = SCINumericAxis3D()
        yAxis.visibleRange = SCIDoubleRange(min: -8.0, max: 8.0)
        yAxis.autoRange = .never
        
        let zAxis = SCINumericAxis3D()
        zAxis.visibleRange = SCIDoubleRange(min: -8.0, max: 8.0)
        zAxis.autoRange = .never
        
        ds = SCIEllipsoidDataSeries3D(dataType: .double, uSize: Int(Size), vSize: Int(Size))
        ds.set(a: 6.0)
        ds.set(b: 6.0)
        ds.set(c: 6.0)
        globeHeightMap = getGlobeHightMap()
        ds.copy(from: globeHeightMap)
        
        let palette = SCIGradientColorPalette(
            colors: [0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000],
            stops: [0.0, 0.1, 0.3, 0.5, 0.7, 0.9, 1.0]
        )
        
        let rSeries = SCIFreeSurfaceRenderableSeries3D()
        rSeries.dataSeries = ds
        rSeries.drawMeshAs = .solidMesh
        rSeries.stroke = 0x77228B22
        rSeries.contourStroke = 0x77228B22
        rSeries.strokeThickness = 2.0
        rSeries.meshColorPalette = palette
        rSeries.paletteMinimum = SCIVector3(x: 0.0, y: 6.0, z: 0.0)
        rSeries.paletteMaximum = SCIVector3(x: 0.0, y: 7.0, z: 0.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
            
            self.surface.worldDimensions.assignX(200, y: 200, z: 200)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    func getGlobeHightMap() -> SCIDoubleValues {
        let bitmap = #imageLiteral(resourceName: "image.globe.heightmap").sciBitmap()
        let stepU = bitmap.width / Size
        let stepV = bitmap.height / Size
        
        let globeheightMap = SCIDoubleValues()
        globeheightMap.count = Int(Size * Size)
        
        for v in 0 ..< Size {
            for u in 0 ..< Size {
                let index = Int(v * Size + u)
                let x = u * stepU
                let y = v * stepV

                globeheightMap.set(Double(SCIColor.red(bitmap.pixelAt(x: x, y: y))) / 255.0, at: index)
            }
        }
        
        return globeheightMap
    }
    
    @objc fileprivate func updateData(_ timer: Timer) {
        SCIUpdateSuspender.usingWith(surface) {
            self.frames += 1
            let freq = (sin(Double(self.frames) * 0.1) + 1.0) / 2.0
            let exp  = freq * 10.0
            
            let offset = self.frames % Int(self.Size)
            let size = self.globeHeightMap.count
            
            self.buffer.count = size
            
            for i in 0 ..< size {
                var currentIndex = Int(i) + offset
                if (currentIndex >= size ){
                    currentIndex -= Int(self.Size)
                }
                
                let currentValue = self.globeHeightMap.getValueAt(currentIndex)
                self.buffer.set(currentValue + pow(currentValue, exp) * self.HeightOffsetScale, at: i)
            }
            self.ds.copy(from: self.buffer)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer.invalidate()
        timer = nil
    }
}
