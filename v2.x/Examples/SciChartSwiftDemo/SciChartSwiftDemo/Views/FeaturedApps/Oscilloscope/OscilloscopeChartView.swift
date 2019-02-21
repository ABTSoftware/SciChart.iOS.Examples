//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class OscilloscopeChartView: OscilloscopeLayout {
    
    var _selectedSource: DataSource = .Fourier
    var _isDigitalLine = false
    
    let _dataSeries1 = SCIXyDataSeries(xType: .double, yType: .double)
    let _dataSeries2 = SCIXyDataSeries(xType: .double, yType: .double)
    
    let _rSeries = SCIFastLineRenderableSeries()
    
    var _lastTimeDraw: TimeInterval = 0
    var _displayLink: CADisplayLink!
    
    var _phase0 = 0.0
    var _phase1 = 0.0
    var _phaseIncrement = .pi * 0.1
    
    var _xAxis: SCINumericAxis!
    var _yAxis: SCINumericAxis!
    
    override func commonInit() {
        weak var wSelf = self;
        self.seriesTypeTouched = { wSelf?.changeSeriesType() }
        self.rotateTouched = { wSelf?.rotateChart() }
        self.flippedVerticallyTouched = { wSelf?.flipChartVertically() }
        self.flippedHorizontallyTouched = { wSelf?.flipChartHorizontally() }
    }
    
    override func initExample() {
        _xAxis = SCINumericAxis()
        _yAxis = SCINumericAxis()
        _xAxis.autoRange = .never
        _xAxis.axisTitle = "Time (ms)"
        _xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(2.5), max: SCIGeneric(4.5))
        
        _yAxis.autoRange = .never
        _yAxis.axisTitle = "Voltage (mV)"
        _yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(-12.5), max: SCIGeneric(12.5))

        _dataSeries1.acceptUnsortedData = true
        _dataSeries2.acceptUnsortedData = true
        
        _rSeries.isDigitalLine = _isDigitalLine
        
        surface.xAxes.add(_xAxis)
        surface.yAxes.add(_yAxis)
        surface.renderableSeries.add(_rSeries)
        
        SCIThemeManager.applyDefaultTheme(toThemeable: surface)
    }
    
    @objc fileprivate func updateOscilloscopeData(_ displayLink: CADisplayLink) {
        _lastTimeDraw = _displayLink.timestamp
        
        let doubleSeries = DoubleSeries()
        if (_selectedSource == .Lisajous) {
            DataManager.setLissajousCurve(doubleSeries, alpha: 0.12, beta: _phase1, delta: _phase0, count: 2500)
            _dataSeries1.clear()
            _dataSeries1.appendRangeX(doubleSeries.xValues, y: doubleSeries.yValues, count: doubleSeries.size)
            _rSeries.dataSeries = _dataSeries1
        } else {
            DataManager.setFourierSeries(doubleSeries, amplitude: 2.0, phaseShift: _phase0, count: 1000)
            _dataSeries2.clear()
            _dataSeries2.appendRangeX(doubleSeries.xValues, y: doubleSeries.yValues, count: doubleSeries.size)
            _rSeries.dataSeries = _dataSeries2
        }
        
        _phase0 += _phaseIncrement
        _phase1 += _phaseIncrement * 0.005
    }
    
    fileprivate func changeSeriesType() {
        let alertController = UIAlertController(title: "Data Source", message: "Select data source or make the line Digital", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Fourier", style: .default, handler: {[unowned self] (action: UIAlertAction) -> Void in
            self._selectedSource = .Fourier
            self.surface.xAxes[0].visibleRange = SCIDoubleRange(min: SCIGeneric(2.5), max: SCIGeneric(4.5))
            self.surface.yAxes[0].visibleRange = SCIDoubleRange(min: SCIGeneric(-12.5), max: SCIGeneric(12.5))
        }))
        alertController.addAction(UIAlertAction(title: "Lisajous", style: .default, handler: {[unowned self] (action: UIAlertAction) -> Void in
            self._selectedSource = .Lisajous
            self.surface.xAxes[0].visibleRange = SCIDoubleRange(min: SCIGeneric(-1.2), max: SCIGeneric(1.2))
            self.surface.yAxes[0].visibleRange = SCIDoubleRange(min: SCIGeneric(-1.2), max: SCIGeneric(1.2))
        }))
        alertController.addAction(UIAlertAction(title: "Make line Digital", style: .default, handler: {[unowned self] (action: UIAlertAction) -> Void in
            self._isDigitalLine = !self._isDigitalLine
            self._rSeries.isDigitalLine = self._isDigitalLine
        }))
        
        var topVC = UIApplication.shared.delegate?.window??.rootViewController
        while ((topVC?.presentedViewController) != nil) {
            topVC = topVC?.presentedViewController
        }
        topVC?.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func rotateChart() {
        var xAlignment: Int = Int(surface.xAxes[0].axisAlignment.rawValue)
        xAlignment += 1
        if (xAlignment > 4) {
            xAlignment = 1;
        }
        surface.xAxes[0].axisAlignment = SCIAxisAlignment(rawValue: Int32(xAlignment))!
        
        var yAlignment: Int = Int(surface.yAxes[0].axisAlignment.rawValue)
        yAlignment += 1
        if (yAlignment > 4) {
            yAlignment = 1;
        }
        surface.yAxes[0].axisAlignment = SCIAxisAlignment(rawValue: Int32(yAlignment))!
    }
    
    func flipChartVertically() {
        let flip = surface.yAxes[0].flipCoordinates
        surface.yAxes[0].flipCoordinates = !flip
    }
    
    func flipChartHorizontally() {
        let flip = surface.xAxes[0].flipCoordinates
        surface.xAxes[0].flipCoordinates = !flip
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if(_displayLink == nil) {
            _lastTimeDraw = 0.0
            _displayLink = CADisplayLink.init(target: self, selector: #selector(updateOscilloscopeData))
            _displayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        } else {
            _displayLink.invalidate()
            _displayLink = nil;
        }
    }
}
