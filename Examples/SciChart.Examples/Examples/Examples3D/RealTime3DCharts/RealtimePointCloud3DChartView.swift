//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimePointCloud3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class RealtimePointCloud3DChartView: SCDSingleChartViewController<SCIChartSurface3D> {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }
   
    private let dataSeries = SCIXyzDataSeries3D(xType: .double, yType: .double, zType: .double)
    private let xData = SCIDoubleValues()
    private let yData = SCIDoubleValues()
    private let zData = SCIDoubleValues()
    private var timer: Timer!

    override func initExample() {
        let xAxis = SCINumericAxis3D()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.autoRange = .once
        
        let yAxis = SCINumericAxis3D()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .once
        
        let zAxis = SCINumericAxis3D()
        zAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        zAxis.autoRange = .once
        
        let pointMarker3D = SCIEllipsePointMarker3D()
        pointMarker3D.fillColor = 0x77ADFF2F
        pointMarker3D.size = 3.0
    
        for _ in 0 ..< 1000 {
            let x = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            let y = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            let z = SCDDataManager.getGaussianRandomNumber(5, stdDev: 1.5)
            
            xData.add(x)
            yData.add(y)
            zData.add(z)
        }   
        dataSeries.append(x: xData, y: yData, z: zData)
        
        let rSeries = SCIScatterRenderableSeries3D()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = pointMarker3D
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = xAxis
            self.surface.yAxis = yAxis
            self.surface.zAxis = zAxis
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateData(_ timer: Timer) {
        for i in 0 ..< dataSeries.count {
            xData.set(xData.getValueAt(i) + SCDRandomUtil.nextDouble() - 0.5 , at: i)
            yData.set(yData.getValueAt(i) + SCDRandomUtil.nextDouble() - 0.5 , at: i)
            zData.set(zData.getValueAt(i) + SCDRandomUtil.nextDouble() - 0.5 , at: i)
        }
        dataSeries.update(x: xData, y: yData, z: zData, at: 0)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer.invalidate()
        timer = nil
    }
}
