//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class PerformanceDemoView: RealtimeChartLayout {
    
    private let MaLow: Int32 = 200;
    private let MaHigh: Int32 = 1000;
    private let TimeInterval = 10.0;
    private let MaxPointCount = 1000000;
    private let AppendPointsCount = 100;
    
    private var _maLow: MovingAverage?
    private var _maHigh: MovingAverage?
    
    private var _timer: Timer?
    private var _isRunning = false
    
    // needed to update Y position of annotation;
    private var _maxYValue: Float = 0.0
    private var _annotation = SCITextAnnotation()

    override func commonInit() {
        _maLow = MovingAverage(length: MaLow)
        _maHigh = MovingAverage(length: MaHigh)
        
        weak var wSelf = self
        self.playCallback = { wSelf?.updateIsRunningWith(true) }
        self.pauseCallback = { wSelf?.updateIsRunningWith(false) }
        self.stopCallback = {
            wSelf?.updateIsRunningWith(false)
            wSelf?.resetChart()
        }
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        
        let rs1 = SCIFastLineRenderableSeries()
        rs1.dataSeries = SCIXyDataSeries(xType: .int32, yType: .float)
        rs1.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4083B7, withThickness: 1)
        
        let rs2 = SCIFastLineRenderableSeries()
        rs2.dataSeries = SCIXyDataSeries(xType: .int32, yType: .float)
        rs2.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFFA500, withThickness: 1)
        
        let rs3 = SCIFastLineRenderableSeries()
        rs3.dataSeries = SCIXyDataSeries(xType: .int32, yType: .float)
        rs3.strokeStyle = SCISolidPenStyle(colorCode: 0xFFE13219, withThickness: 1)
        
        _annotation.x1 = SCIGeneric(0)
        _annotation.style.textColor = UIColor.white
        _annotation.style.textStyle.fontSize = 14
        _annotation.style.backgroundColor = UIColor.clear
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rs1)
            self.surface.renderableSeries.add(rs2)
            self.surface.renderableSeries.add(rs3)
            self.surface.annotations.add(self._annotation)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomPanModifier(), SCIZoomExtentsModifier()])
        }
        
        _timer = Timer.scheduledTimer(timeInterval: TimeInterval / 1000, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
        _isRunning = true
    }
    
    @objc func updateData(_ timer:Timer) {
        if (!_isRunning || getPointsCount() > MaxPointCount) { return }
        
        var xValues = [Int](repeating: 0, count: AppendPointsCount)
        var firstYValues = [Float](repeating: 0, count: AppendPointsCount)
        var secondYValues = [Float](repeating: 0, count: AppendPointsCount)
        var thirdYValues = [Float](repeating: 0, count: AppendPointsCount)
        
        let mainSeries = surface.renderableSeries[0].dataSeries as! SCIXyDataSeries
        let maLowSeries = surface.renderableSeries[1].dataSeries as! SCIXyDataSeries
        let maHighSeries = surface.renderableSeries[2].dataSeries as! SCIXyDataSeries
        
        var xValue = mainSeries.count() > 0 ? Int(SCIGenericInt(mainSeries.xValues().value(at: mainSeries.count() - 1))) : 0
        var yValue = mainSeries.count() > 0 ? SCIGenericFloat(mainSeries.yValues().value(at: mainSeries.count() - 1)) : 10
        for i in 0..<AppendPointsCount {
            xValue += 1
            yValue += Float(randf(0.0, 1.0) - 0.5)
            xValues[i] = xValue
            firstYValues[i] = yValue
            secondYValues[i] = Float(_maLow!.push(Double(yValue)).current())
            thirdYValues[i] = Float(_maHigh!.push(Double(yValue)).current())
            if (yValue > _maxYValue) {
                _maxYValue = yValue
            }
        }
        
        mainSeries.appendRangeX(xValues, y: firstYValues)
        maLowSeries.appendRangeX(xValues, y: secondYValues)
        maHighSeries.appendRangeX(xValues, y: thirdYValues)

        let count = mainSeries.count() + maLowSeries.count() + maHighSeries.count()
        _annotation.text = String(format: "Amount of points: %li", count)
        _annotation.y1 = SCIGeneric(_maxYValue);
    }

    fileprivate func getPointsCount() -> Int32 {
        let rsCollection = self.surface.renderableSeries
        
        var result: Int32 = 0
        for i in 0..<rsCollection.count() {
            result += rsCollection[UInt32(i)].dataSeries.count()
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
        for i in 0..<surface.chartModifiers.count() {
            surface.chartModifiers.item(at: i)?.isEnabled = isEnabled
        }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: window)
        if newWindow == nil {
            _timer?.invalidate()
            _timer = nil
        }
    }
    
    fileprivate func resetChart() {
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            for i in 0..<self.surface.renderableSeries.count() {
                self.surface.renderableSeries[UInt32(i)].dataSeries.clear()
            }
        }
    }
}
