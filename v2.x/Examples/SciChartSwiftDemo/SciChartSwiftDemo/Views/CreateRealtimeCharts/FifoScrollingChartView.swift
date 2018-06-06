//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FifoScrollingChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class FifoScrollingChartView: RealtimeChartLayout {
    
    private let FifoCapacicty: Int32 = 50
    private let TimeInterval = 30.0
    private let OneOverTimeInterval = 1.0 / 30
    private let VisibleRangeMax = 50.0 * 1.0 / 30.0
    private let GrowBy = 50.0 * 1.0 / 30.0 * 0.1
    
    private var _timer: Timer?
    private var _ds1: SCIXyDataSeries!
    private var _ds2: SCIXyDataSeries!
    private var _ds3: SCIXyDataSeries!
    
    private var _t = 0.0
    private var _isRunning = false
    
    override func commonInit() {
        weak var wSelf = self
        self.playCallback = { wSelf?._isRunning = true }
        self.pauseCallback = { wSelf?._isRunning = false }
        self.stopCallback = {
            wSelf?._isRunning = false
            wSelf?.resetChart()
        }
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .never
        xAxis.visibleRange = SCIDoubleRange.init(min: SCIGeneric(-GrowBy), max: SCIGeneric(VisibleRangeMax + GrowBy))
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always

        _ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds1.fifoCapacity = FifoCapacicty
        _ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds2.fifoCapacity = FifoCapacicty
        _ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds3.fifoCapacity = FifoCapacicty
        
        let rs1 = SCIFastLineRenderableSeries()
        rs1.dataSeries = _ds1
        rs1.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4083B7, withThickness: 2)
        
        let rs2 = SCIFastLineRenderableSeries()
        rs2.dataSeries = _ds2
        rs2.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFFA500, withThickness: 2)
        
        let rs3 = SCIFastLineRenderableSeries()
        rs3.dataSeries = _ds3
        rs3.strokeStyle = SCISolidPenStyle(colorCode: 0xFFE13219, withThickness: 2)
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rs1)
            self.surface.renderableSeries.add(rs2)
            self.surface.renderableSeries.add(rs3)
        }
        
        _timer = Timer.scheduledTimer(timeInterval: TimeInterval / 1000, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        _isRunning = true
    }
    
    @objc func updateData(_ timer:Timer) {
        if (!_isRunning) { return }
        
        let y1: Double = 3.0 * sin(((2 * .pi) * 1.4) * _t) + RandomUtil.nextDouble() * 0.5
        let y2: Double = 2.0 * cos(((2 * .pi) * 0.8) * _t) + RandomUtil.nextDouble() * 0.5
        let y3: Double = 1.0 * sin(((2 * .pi) * 2.2) * _t) + RandomUtil.nextDouble() * 0.5
        
        _ds1.appendX(SCIGeneric(_t), y: SCIGeneric(y1))
        _ds2.appendX(SCIGeneric(_t), y: SCIGeneric(y2))
        _ds3.appendX(SCIGeneric(_t), y: SCIGeneric(y3))
        
        _t += OneOverTimeInterval;
        
        let xAxis = surface.xAxes.item(at: 0)
        if (_t > VisibleRangeMax) {
            xAxis?.visibleRange.setMinTo(SCIGeneric(SCIGenericDouble(xAxis!.visibleRange.min) + OneOverTimeInterval), maxTo: SCIGeneric(SCIGenericDouble(xAxis!.visibleRange.max) + OneOverTimeInterval))
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if newWindow == nil {
            _timer?.invalidate()
            _timer = nil
        }
    }
    
    fileprivate func resetChart() {
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self._ds1.clear()
            self._ds2.clear()
            self._ds3.clear()
        }
    }
}
