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

class RealtimeWaterfall3DChartView: SingleChartLayout3D  {

    private let PointsPerSlice = 128;
    private let SliceCount = 10;

    private let fftValues = SCDDataManager.loadFFT()
    private let waterfallDataSeries = SCIWaterfallDataSeries3D(xType: .double, yType: .double, zType: .double, xSize: 128, zSize: 10)
    
    private var tick = 0
    private var timer: Timer!
    
    private let fillColorPalette = SCIGradientColorPalette(colors: [0xFFFF0000, 0xFFFFA500, 0xFFFFFF00, 0xFFADFF2F, 0xFF006400], stops: [0.0, 0.25, 0.5, 0.75, 1.0], count: 5)
    private let strokeColorPalette = SCIGradientColorPalette(colors: [0xFFDC143C, 0xFFFF8C00, 0xFF32CD32, 0xFF32CD32], stops: [0.0, 0.33, 0.67, 1.0], count: 4)
    private let transperentColorPalette = SCIBrushColorPalette(brushStyle: SCISolidBrushStyle(colorCode: 0));
    private let solidStokeColorPalette = SCIBrushColorPalette(brushStyle: SCISolidBrushStyle(colorCode: 0xFF32CD32));
    private let solidFillColorPalette = SCIBrushColorPalette(brushStyle: SCISolidBrushStyle(colorCode: 0xAA00BFFF));

    override func initExample() {
        waterfallDataSeries.set(startX: 10)
        waterfallDataSeries.set(stepX: 1)
        waterfallDataSeries.set(startZ: 25)
        waterfallDataSeries.set(stepZ: 15)
        
        waterfallDataSeries.push(fftValues[0])
        
        let rs = SCIWaterfallRenderableSeries3D()
        rs.dataSeries = waterfallDataSeries
        rs.strokeThickness = 3.0
        rs.sliceThickness = 6.0
        rs.yColorMapping = fillColorPalette
        rs.yStrokeColorMapping = transperentColorPalette
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxis = SCINumericAxis3D()
            self.surface.yAxis = SCINumericAxis3D()
            self.surface.zAxis = SCINumericAxis3D()
            self.surface.zAxis.autoRange = .always
            self.surface.renderableSeries.add(rs)
            self.surface.chartModifiers.add(ExampleViewBase.createDefault3DModifiers())
            
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
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if (newWindow == nil) {
            timer.invalidate()
            timer = nil
        }
    }
}
