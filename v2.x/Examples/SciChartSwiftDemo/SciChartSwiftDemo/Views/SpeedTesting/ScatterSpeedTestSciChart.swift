//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ScatterSpeedTestSciChart.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class ScatterSpeedTestSciChart: SingleChartLayout {
    
    let PointsCount: Int32 = 20000
    
    var _timer: Timer!
    let _scatterDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        
        let doubleSeries = BrownianMotionGenerator.getRandomData(withMin: -50, max: 50, count: PointsCount)
        _scatterDataSeries.acceptUnsortedData = true
        _scatterDataSeries.appendRangeX(doubleSeries!.xValues, y: doubleSeries!.yValues, count: doubleSeries!.size)
        
        let marker = SCICoreGraphicsPointMarker()
        marker.width = 6
        marker.height = 6
        
        let rSeries = SCIXyScatterRenderableSeries()
        rSeries.dataSeries = _scatterDataSeries
        rSeries.pointMarker = marker
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
        }
        
        _timer = Timer.scheduledTimer(timeInterval: 0.002, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateData(_ timer: Timer) {
        for i in 0..<_scatterDataSeries.count() {
            let x = _scatterDataSeries.xValues().value(at: i)
            let y = _scatterDataSeries.yValues().value(at: i)
            
            _scatterDataSeries.update(at: i, x: SCIGeneric(SCIGenericDouble(x) + randf(-1.0, 1.0)), y: SCIGeneric(SCIGenericDouble(y) + randf(-0.5, 0.5)))
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if (newWindow == nil) {
            _timer.invalidate()
            _timer = nil
        }
    }
}
