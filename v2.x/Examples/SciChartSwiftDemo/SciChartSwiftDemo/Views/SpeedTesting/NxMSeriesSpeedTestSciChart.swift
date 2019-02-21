//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// NxMSeriesSpeedTestSciChart.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class NxMSeriesSpeedTestSciChart: SingleChartLayout {
    
    let PointsCount: Int32 = 100
    let SeriesCount: Int32 = 100

    var _timer: Timer!
    var _yAxis: SCINumericAxis!

    var _updateNumber = 0
    var _rangeMin = Double.nan
    var _rangeMax = Double.nan
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        _yAxis = SCINumericAxis()
        let randomWalk = RandomWalkGenerator()!
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(self._yAxis)
            
            var color: Int64 = 0xFF0F0505
            for _ in 0..<self.SeriesCount {
                randomWalk.reset()
                let doubleSeries = randomWalk.getRandomWalkSeries(self.PointsCount)
                let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
                dataSeries.appendRangeX(doubleSeries!.xValues, y: doubleSeries!.yValues, count: doubleSeries!.size)
                
                color = color + 0x00000101
                
                let rSeries = SCIFastLineRenderableSeries()
                rSeries.dataSeries = dataSeries
                rSeries.strokeStyle = SCISolidPenStyle(colorCode: UInt32(color), withThickness: 0.5)
                
                self.surface.renderableSeries.add(rSeries)
            }
        }
        
        _timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateData(_ timer: Timer) {
        if (_rangeMin.isNaN) {
            _rangeMin = _yAxis.visibleRange.minAsDouble()
            _rangeMax = _yAxis.visibleRange.maxAsDouble()
        }
        let scaleFactor = fabs(sin(Double(_updateNumber) * 0.1)) + 0.5;
        _yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(_rangeMin * scaleFactor), max: SCIGeneric(_rangeMax * scaleFactor))
        _updateNumber += 1
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if (newWindow == nil) {
            _timer.invalidate()
            _timer = nil
        }
    }
}
