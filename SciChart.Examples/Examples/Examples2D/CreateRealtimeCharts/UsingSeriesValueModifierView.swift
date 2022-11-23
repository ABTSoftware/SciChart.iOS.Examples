//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2021. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// UsingSeriesValueModifierView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

private let FifoCapacity: Int = 100
// Data Sample Rate (sec) - 20 Hz
private let TimeInterval = 0.05

class UsingSeriesValueModifierView: SCDSingleChartViewController<SCIChartSurface> {
    
    private var _timer: Timer?
    private var _ds1: SCIXyDataSeries!
    private var _ds2: SCIXyDataSeries!
    private var _ds3: SCIXyDataSeries!
    
    private var _t = 0.0
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        xAxis.axisTitle = "Time (Seconds)"
        xAxis.textFormatting = "0.0"
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        yAxis.axisTitle = "Amplitude (Volts)"
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.textFormatting = "0.00"
        yAxis.cursorTextFormatting = "0.00"
        
        _ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds1.fifoCapacity = FifoCapacity
        _ds1.seriesName = "Orange Series"
        _ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds2.fifoCapacity = FifoCapacity
        _ds2.seriesName = "Blue Series"
        _ds3 = SCIXyDataSeries(xType: .double, yType: .double)
        _ds3.fifoCapacity = FifoCapacity
        _ds3.seriesName = "Green Series"
        
        let rSeries1 = SCIFastLineRenderableSeries()
        rSeries1.dataSeries = _ds1
        rSeries1.strokeStyle = SCISolidPenStyle(color: 0xFFe97064, thickness: 2)
        
        let rSeries2 = SCIFastLineRenderableSeries()
        rSeries2.dataSeries = _ds2
        rSeries2.strokeStyle = SCISolidPenStyle(color: 0xFF47bde6, thickness: 2)
        
        let rSeries3 = SCIFastLineRenderableSeries()
        rSeries3.dataSeries = _ds3
        rSeries3.strokeStyle = SCISolidPenStyle(color: 0xFF68bcae, thickness: 2)
        
        let legendModifier = SCILegendModifier()
        legendModifier.margins = SCIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries1)
            self.surface.renderableSeries.add(rSeries2)
            self.surface.renderableSeries.add(rSeries3)
            self.surface.chartModifiers.add(items: SCISeriesValueModifier(), legendModifier)
        }
        
        _timer = Timer.scheduledTimer(timeInterval: TimeInterval, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc func updateData(_ timer: Timer) {
        let y1: Double = 3.0 * sin(((2 * .pi) * 1.4) * _t * 0.02)
        let y2: Double = 2.0 * cos(((2 * .pi) * 0.8) * _t * 0.02)
        let y3: Double = 1.0 * sin(((2 * .pi) * 2.2) * _t * 0.02)
        
        _ds1.append(x: _t, y: y1)
        _ds2.append(x: _t, y: y2)
        _ds3.append(x: _t, y: y3)
        
        _t += TimeInterval;
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _timer?.invalidate()
        _timer = nil
    }
}
