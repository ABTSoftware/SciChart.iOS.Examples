//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealtimeWaterfall3DChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class RealtimeWaterfall3DChartView: SCDWaterfall3DChartViewControllerBase {
    
    override var associatedType: AnyClass { return SCIChartSurface3D.self }

    private let PointsPerSlice = 128;
    private let SliceCount = 10;

    private let fftValues = SCDDataManager.loadFFT()
    private let waterfallDataSeries = SCIWaterfallDataSeries3D(xType: .double, yType: .double, zType: .double, xSize: 128, zSize: 10)
    
    private var tick = 0
    private var timer: Timer!

    override func initExample() {
        waterfallDataSeries.set(startX: 10)
        waterfallDataSeries.set(stepX: 1)
        waterfallDataSeries.set(startZ: 25)
        waterfallDataSeries.set(stepZ: 15)
        
        waterfallDataSeries.push(fftValues[0])
        
        rSeries = SCIWaterfallRenderableSeries3D()
        rSeries.dataSeries = waterfallDataSeries
        rSeries.strokeThickness = 1.0
        setupColorPalettes()
        setupPointMarker()
        setupSliceThickness()
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = SCINumericAxis3D()
            self.surface.yAxis = SCINumericAxis3D()
            self.surface.zAxis = SCINumericAxis3D()
            self.surface.zAxis.autoRange = .always
            self.surface.renderableSeries.add(self.rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers3D())
            
            self.surface.camera.position.assignX(-115, y: 250, z: -570)
            self.surface.worldDimensions.assignX(200, y: 100, z: 200)
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.04, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateData(_ timer: Timer) {
        self.tick += 1
        SCIUpdateSuspender.usingWith(surface) {
            let index = self.tick % self.fftValues.count
            self.waterfallDataSeries.push(self.fftValues[index])
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        timer.invalidate()
        timer = nil
    }
}
