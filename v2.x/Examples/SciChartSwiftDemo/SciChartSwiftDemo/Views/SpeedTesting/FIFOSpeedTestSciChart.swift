//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FIFOSpeedTestSciChart.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class FIFOSpeedTestSciChart: SingleChartLayout {
    
    let PointsCount: Int32 = 1000
    
    var _timer: Timer!
    
    let _dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
    let _randomWalk = RandomWalkGenerator()!
    
    var _xCount: Int32 = 0

    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        
        let doubleSeries = _randomWalk.getRandomWalkSeries(PointsCount)
        
        _dataSeries.fifoCapacity = PointsCount
        _dataSeries.appendRangeX(doubleSeries!.xValues, y: doubleSeries!.yValues, count: doubleSeries!.size)
        _xCount += PointsCount
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = _dataSeries
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
        }
        
        _timer = Timer.scheduledTimer(timeInterval: 0.002, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }

    @objc fileprivate func updateData(_ timer: Timer) {
        _dataSeries.appendX(SCIGeneric(_xCount), y: SCIGeneric(_randomWalk.next()))
        _xCount += 1
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if (newWindow == nil) {
            _timer.invalidate()
            _timer = nil
        }
    }
}
