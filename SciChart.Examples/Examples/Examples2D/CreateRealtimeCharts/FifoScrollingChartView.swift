//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

private let FifoCapacicty: Int = 50
private let TimeInterval = 30.0
private let OneOverTimeInterval = 1.0 / 30
private let VisibleRangeMax = 50.0 * 1.0 / 30.0
private let GrowBy = 50.0 * 1.0 / 30.0 * 0.1

class FifoScrollingChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    private var _timer: Timer?
    private var _ds1: SCIXyDataSeries!
    private var _ds2: SCIXyDataSeries!
    private var _ds3: SCIXyDataSeries!
    
    private var _t = 0.0
    private var _isRunning = false
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func provideExampleSpecificToolbarItems() -> [ISCDToolbarItem] {
        return [SCDToolbarButtonsGroup(toolbarItems: [
            SCDToolbarButton(title: "Start", image: SCIImage(named: "chart.play"), andAction: { [weak self] in self?._isRunning = true }),
            SCDToolbarButton(title: "Pause", image: SCIImage(named: "chart.pause"), andAction: { [weak self] in self?._isRunning = false }),
            SCDToolbarButton(title: "Stop", image: SCIImage(named: "chart.stop"), andAction: { [weak self] in
                self?._isRunning = false
                self?.resetChart()
            })
        ])]
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .never
        xAxis.visibleRange = SCIDoubleRange.init(min: -GrowBy, max: VisibleRangeMax + GrowBy)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always

        _ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds1.fifoCapacity = FifoCapacicty
        _ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds2.fifoCapacity = FifoCapacicty
        _ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds3.fifoCapacity = FifoCapacicty
        
        let rSeries1 = SCIFastLineRenderableSeries()
        rSeries1.dataSeries = _ds1
        rSeries1.strokeStyle = SCISolidPenStyle(color: 0xFFe97064, thickness: 2)
        
        let rSeries2 = SCIFastLineRenderableSeries()
        rSeries2.dataSeries = _ds2
        rSeries2.strokeStyle = SCISolidPenStyle(color: 0xFF47bde6, thickness: 2)
        
        let rSeries3 = SCIFastLineRenderableSeries()
        rSeries3.dataSeries = _ds3
        rSeries3.strokeStyle = SCISolidPenStyle(color: 0xFFae418d, thickness: 2)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries1)
            self.surface.renderableSeries.add(rSeries2)
            self.surface.renderableSeries.add(rSeries3)
        }
        
        _timer = Timer.scheduledTimer(timeInterval: TimeInterval / 1000, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        _isRunning = true
    }
    
    @objc func updateData(_ timer: Timer) {
        if (!_isRunning) { return }
        
        let y1: Double = 3.0 * sin(((2 * .pi) * 1.4) * _t) + SCDRandomUtil.nextDouble() * 0.5
        let y2: Double = 2.0 * cos(((2 * .pi) * 0.8) * _t) + SCDRandomUtil.nextDouble() * 0.5
        let y3: Double = 1.0 * sin(((2 * .pi) * 2.2) * _t) + SCDRandomUtil.nextDouble() * 0.5
        
        _ds1.append(x: _t, y: y1)
        _ds2.append(x: _t, y: y2)
        _ds3.append(x: _t, y: y3)
        
        _t += OneOverTimeInterval;
        
        let xAxis = surface.xAxes.item(at: 0)
        if (_t > VisibleRangeMax) {
            xAxis.visibleRange.setDoubleMinTo(xAxis.visibleRange.minAsDouble + OneOverTimeInterval, maxTo: xAxis.visibleRange.maxAsDouble + OneOverTimeInterval)
        }
    }
    
    fileprivate func resetChart() {
        SCIUpdateSuspender.usingWith(surface) {
            self._ds1.clear()
            self._ds2.clear()
            self._ds3.clear()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _timer?.invalidate()
        _timer = nil
    }
}
