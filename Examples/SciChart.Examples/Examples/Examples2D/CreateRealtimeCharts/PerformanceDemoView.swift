//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// PerformanceDemoView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

private let MaLow = 200;
private let MaHigh = 1000;
private let TimeInterval = 10.0;
private let MaxPointCount = 1000000;

class PerformanceDemoView: SCDPerformanceDemoViewControllerBase {
    
    private let _annotation = SCITextAnnotation()
    private let _maLow = SCDMovingAverage(length: MaLow)
    private var _maHigh = SCDMovingAverage(length: MaHigh)
    
    private var _timer: Timer?
    private var _isRunning = false
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        
        let rSeries1 = createRenderableSeries(withColorCode: 0xFF4083B7)
        let rSeries2 = createRenderableSeries(withColorCode: 0xFFFFA500)
        let rSeries3 = createRenderableSeries(withColorCode: 0xFFE13219)
        
        _annotation.set(x1: 0)
        _annotation.set(y1: 0)
        _annotation.coordinateMode = .relative
        _annotation.padding = SCIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
        _annotation.fontStyle = SCIFontStyle(fontSize: 14, andTextColor: .white)

        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries1)
            self.surface.renderableSeries.add(rSeries2)
            self.surface.renderableSeries.add(rSeries3)
            self.surface.annotations.add(self._annotation)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
        }
        
        _timer = Timer.scheduledTimer(timeInterval: TimeInterval / 1000, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        _isRunning = true
    }
    
    @objc func updateData(_ timer:Timer) {
        if (!_isRunning || getPointsCount() > MaxPointCount) { return }
        
        let xValues = SCIIntegerValues(capacity: Int(pointsCount))
        let firstYValues = SCIFloatValues(capacity: Int(pointsCount))
        let secondYValues = SCIFloatValues(capacity: Int(pointsCount))
        let thirdYValues = SCIFloatValues(capacity: Int(pointsCount))
        
        let mainSeries = surface.renderableSeries[0].dataSeries as! SCIXyDataSeries
        let maLowSeries = surface.renderableSeries[1].dataSeries as! SCIXyDataSeries
        let maHighSeries = surface.renderableSeries[2].dataSeries as! SCIXyDataSeries
        
        let xMath = mainSeries.xMath
        let yMath = mainSeries.yMath
        
        var xValue: Int32 = mainSeries.count > 0 ? Int32(xMath.toDouble(mainSeries.xValues.value(at: mainSeries.count - 1))) : 0
        var yValue: Float = mainSeries.count > 0 ? Float(yMath.toDouble(mainSeries.yValues.value(at: mainSeries.count - 1))) : 10
        for _ in 0 ..< pointsCount {
            xValue += 1
            yValue += Float(randf(0.0, 1.0) - 0.5)
            xValues.add(xValue)
            firstYValues.add(yValue)
            secondYValues.add(Float(_maLow.push(Double(yValue)).current()))
            thirdYValues.add(Float(_maHigh.push(Double(yValue)).current()))
        }
        
        mainSeries.append(x: xValues, y: firstYValues)
        maLowSeries.append(x: xValues, y: secondYValues)
        maHighSeries.append(x: xValues, y: thirdYValues)

        let count = mainSeries.count + maLowSeries.count + maHighSeries.count
        _annotation.text = "Amount of points: \(count)"
    }

    fileprivate func getPointsCount() -> Int {
        var result: Int = 0
        let rsCollection = self.surface.renderableSeries
        for i in 0 ..< rsCollection.count {
            result += rsCollection[i].dataSeries!.count
        }
        
        return result
    }
    
    fileprivate func updateIsRunningWith(_ isRunning: Bool) {
        _isRunning = isRunning
        
        updateAutoRangeBehavior(_isRunning)
        updateModifiers(!_isRunning)
    }
    
    fileprivate func updateAutoRangeBehavior(_ isEnabled: Bool) {
        let autoRangeMode: SCIAutoRange = isEnabled ? .always : .never
        
        surface.xAxes.item(at: 0).autoRange = autoRangeMode;
        surface.yAxes.item(at: 0).autoRange = autoRangeMode;
    }
    
    fileprivate func updateModifiers(_ isEnabled: Bool) {
        for i in 0 ..< surface.chartModifiers.count {
            surface.chartModifiers.item(at: i).isEnabled = isEnabled
        }
    }
    
    fileprivate func resetChart() {
        SCIUpdateSuspender.usingWith(surface) {
            for i in 0 ..< self.surface.renderableSeries.count {
                self.surface.renderableSeries[i].dataSeries!.clear()
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _timer?.invalidate()
        _timer = nil
    }
    
    override func onStartPress() {
        updateIsRunningWith(true)
    }
    
    override func onPausePress() {
        updateIsRunningWith(false)
    }
    
    override func onStopPress() {
        updateIsRunningWith(false)
        resetChart()
    }
}
