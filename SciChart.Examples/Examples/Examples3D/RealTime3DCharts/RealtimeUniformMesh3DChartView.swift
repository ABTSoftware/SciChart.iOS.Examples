//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeUniformMesh3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class RealtimeUniformMesh3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
    
    private let w = 50
    private let h = 50
    private var frames = 0;
    
    private var timer: Timer!
    private var dataSeries: SCIUniformGridDataSeries3D!
    private let buffer = SCIDoubleValues()
    
    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis3D()
        yAxis.visibleRange = SCIDoubleRange(min: 0, max: 1.0)
        
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        zAxis.autoRange = .always
   
        dataSeries = SCIUniformGridDataSeries3D(xType: .double, yType: .double, zType: .double, xSize: w, zSize: h)
        
        let palette = SCIGradientColorPalette(
            colors: [0xFF1D2C6B, 0xFF0000FF, 0xFF00FFFF, 0xFFADFF2F, 0xFFFFFF00, 0xFFFF0000, 0xFF8B0000],
            stops: [0, 0.1, 0.3, 0.5, 0.7, 0.9, 1]
        )
        
        let rSeries = SCISurfaceMeshRenderableSeries3D()
        rSeries.dataSeries = dataSeries
        rSeries.stroke = 0x7FFFFFFF
        rSeries.strokeThickness = 2.0
        rSeries.drawSkirt = false
        rSeries.minimum = 0
        rSeries.maximum = 0.5
        rSeries.shininess = 64
        rSeries.meshColorPalette = palette
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.033, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateData(_ timer: Timer) {
        SCIUpdateSuspender.usingWith(surface) {
            self.frames += 1
            
            let wc = Double(self.w) * 0.5
            let hc = Double(self.h) * 0.5
            let freq = sin(Double(self.frames) * 0.1) * 0.1 + 0.1
            
            let indexCalculator = self.dataSeries.indexCalculator

            self.buffer.count = indexCalculator.size
            for i in 0 ..< self.h {
                for j in 0 ..< self.w {
                    let x = Double((wc - Double(i)) * (wc - Double(i))) + Double((hc - Double(j))*(hc - Double(j)))
                    let radius = sqrt(x)
                    let d = Double.pi * radius * freq
                    let value = sin(d) / d

                    let index = indexCalculator.getIndex(atU: i, v: j)
                    self.buffer.set(value.isNaN ? 1 : value, at: index)
                }
            }
            self.dataSeries.copy(from: self.buffer)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer.invalidate()
        timer = nil
    }
}
