//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ECGChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

enum TraceAOrB {
    case TraceA
    case TraceB
}

class ECGChartView: SingleChartLayout {
    
    let TimeInterval = 0.02;

    var _series0: SCIXyDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
    var _series1: SCIXyDataSeries = SCIXyDataSeries(xType: .double, yType: .double)
    let _sourceData = DataManager.loadWaveformData()
    
    var _timer: Timer!
    var _currentIndex: Int = 0
    var _totalIndex = 0.0
    
    var _whichTrace: TraceAOrB = .TraceA
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .never
        xAxis.axisTitle = "Time (seconds)"
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(10))
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .never
        yAxis.axisTitle = "Voltage (mV)"
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(-0.5), max: SCIGeneric(1.5))
        
        _series0.fifoCapacity = 3850
        _series1.fifoCapacity = 3850
        
        let rSeries0 = SCIFastLineRenderableSeries()
        rSeries0.dataSeries = _series0;
        let rSeries1 = SCIFastLineRenderableSeries()
        rSeries1.dataSeries = _series1;
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries0)
            self.surface.renderableSeries.add(rSeries1)
            
            SCIThemeManager.applyDefaultTheme(toThemeable: self.surface)
        }
    }

    @objc fileprivate func appendData() {
        for _ in 0..<10 {
            appendPoint(400)
        }
    }

    fileprivate func appendPoint(_ sampleRate: Double) {
        if _currentIndex >= _sourceData!.count {
            _currentIndex = 0
        }
        
        // Get the next voltage and time, and append to the chart
        let voltage = Double(_sourceData![_currentIndex] as! String)!
        let time = fmod(_totalIndex / sampleRate, 10.0)

        if (_whichTrace == .TraceA) {
            _series0.appendX(SCIGeneric(time), y: SCIGeneric(voltage))
            _series1.appendX(SCIGeneric(time), y: SCIGeneric(Double.nan))
        } else {
            _series0.appendX(SCIGeneric(time), y: SCIGeneric(Double.nan))
            _series1.appendX(SCIGeneric(time), y: SCIGeneric(voltage))
        }
        
        _currentIndex += 1
        _totalIndex += 1
        
        if (Int(_totalIndex) % 4000 == 0) {
            _whichTrace = _whichTrace == .TraceA ? .TraceB : .TraceA;
        }
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if _timer == nil {
            _timer = Timer.scheduledTimer(timeInterval: TimeInterval, target: self, selector: #selector(appendData), userInfo: nil, repeats: true)
        } else {
            _timer.invalidate()
            _timer = nil
        }
    }
}
