//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// OscilloscopeChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

enum DataSource {
    case Fourier
    case Lisajous
}

class OscilloscopeChartView: SCDOscilloscopeChartViewControllerBase {
    var _selectedSource: DataSource = .Fourier
    
    let _dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
    let _dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
    
    let _rSeries = SCIFastLineRenderableSeries()
    
    let _timeInterval = 30.0;
    var _timer: Timer!
    
    var _phase0 = 0.0
    var _phase1 = 0.0
    var _phaseIncrement = .pi * 0.1
    
    let _xAxis = SCINumericAxis()
    let _yAxis = SCINumericAxis()
    
    override func initExample() {
        _xAxis.autoRange = .never
        _xAxis.axisTitle = "Time (ms)"
        _xAxis.visibleRange = SCIDoubleRange(min: 2.5, max: 4.5)
        
        _yAxis.autoRange = .never
        _yAxis.axisTitle = "Voltage (mV)"
        _yAxis.visibleRange = SCIDoubleRange(min: -12.5, max: 12.5)

        _dataSeries1.acceptsUnsortedData = true
        _dataSeries2.acceptsUnsortedData = true
                
        surface.xAxes.add(_xAxis)
        surface.yAxes.add(_yAxis)
        surface.renderableSeries.add(_rSeries)
        
        _timer = Timer.scheduledTimer(timeInterval: _timeInterval / 1000.0, target: self, selector: #selector(updateOscilloscopeData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateOscilloscopeData() {
        let doubleSeries = SCDDoubleSeries()
        if (_selectedSource == .Lisajous) {
            SCDDataManager.setLissajousCurve(doubleSeries, alpha: 0.12, beta: _phase1, delta: _phase0, count: 2500)
            _dataSeries1.clear()
            _dataSeries1.append(x: doubleSeries.xValues, y: doubleSeries.yValues)
            _rSeries.dataSeries = _dataSeries1
        } else {
            SCDDataManager.setFourierSeries(doubleSeries, amplitude: 2.0, phaseShift: _phase0, count: 1000)
            _dataSeries2.clear()
            _dataSeries2.append(x: doubleSeries.xValues, y: doubleSeries.yValues)
            _rSeries.dataSeries = _dataSeries2
        }
        
        _phase0 += _phaseIncrement
        _phase1 += _phaseIncrement * 0.005
    }
    
    override func onFourierSeriesSelected() {
        _selectedSource = .Fourier
        surface.xAxes[0].visibleRange = SCIDoubleRange(min: 2.5, max: 4.5)
        surface.yAxes[0].visibleRange = SCIDoubleRange(min: -12.5, max: 12.5)
        _phaseIncrement = .pi * 0.1
    }
    
    override func onLissajousSelected() {
        _selectedSource = .Lisajous
        surface.xAxes[0].visibleRange = SCIDoubleRange(min: -1.2, max: 1.2)
        surface.yAxes[0].visibleRange = SCIDoubleRange(min: -1.2, max: 1.2)
        _phaseIncrement = .pi * 0.2
    }
    
    override func onIsDigitalLineChanged(_ isDigitalLine: Bool) {
        _rSeries.isDigitalLine = isDigitalLine
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _timer.invalidate()
        _timer = nil
    }
}
