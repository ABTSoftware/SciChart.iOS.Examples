//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealTimeGhostTracesChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class RealTimeGhostTracesChartView: RealtimeGhostTracesLayout {
    
    private var _timer: Timer?
    private var _lastAmplitude = 1.0
    private var _phase = 0.0
    
    override func commonInit() {
        weak var wSelf = self
        self.speedChanged = { sender in wSelf?.onSpeedChanged(sender!) }
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .never
        yAxis.visibleRange = SCIDoubleRange.init(min: SCIGeneric(-2), max: SCIGeneric(2))
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        
        let limeGreen: uint = 0xFF32CD32
        
        addLineRenderableSeries(limeGreen, opacity: 1.0)
        addLineRenderableSeries(limeGreen, opacity: 0.9)
        addLineRenderableSeries(limeGreen, opacity: 0.8)
        addLineRenderableSeries(limeGreen, opacity: 0.7)
        addLineRenderableSeries(limeGreen, opacity: 0.62)
        addLineRenderableSeries(limeGreen, opacity: 0.55)
        addLineRenderableSeries(limeGreen, opacity: 0.45)
        addLineRenderableSeries(limeGreen, opacity: 0.35)
        addLineRenderableSeries(limeGreen, opacity: 0.25)
        addLineRenderableSeries(limeGreen, opacity: 0.15)

        _timer = Timer.scheduledTimer(timeInterval: 0.02, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow == nil {
            _timer?.invalidate()
            _timer = nil
        }
    }
    
    private func onSpeedChanged(_ sender:UISlider) {
        _timer?.invalidate()
        _timer = Timer.scheduledTimer(timeInterval: Double(sender.value) / 1000.0, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc fileprivate func updateData(_ timer:Timer) {
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)

            var randomAmplitude:Double = self._lastAmplitude + (RandomUtil.nextDouble() - 0.5)
            if (randomAmplitude < -2.0) {
                randomAmplitude = -2.0
            } else if (randomAmplitude > 2.0) {
                randomAmplitude = 2.0;
            }
            
            let noisySinewave = DataManager.getNoisySinewave(withAmplitude: randomAmplitude, phase: self._phase, pointCount: 1000, noiseAmplitude: 0.25)
            self._lastAmplitude = randomAmplitude;
            
            dataSeries.appendRangeX(noisySinewave!.xValues, y: noisySinewave!.yValues, count: noisySinewave!.size)
            self.reassignRenderSeriesWith(dataSeries: dataSeries)
        }
    }
    
    fileprivate func reassignRenderSeriesWith(dataSeries: SCIXyDataSeries) {
        let rs = surface.renderableSeries
        
        // shift old dataSeries
        rs.item(at: 9).dataSeries = rs.item(at: 8).dataSeries
        rs.item(at: 8).dataSeries = rs.item(at: 7).dataSeries
        rs.item(at: 7).dataSeries = rs.item(at: 6).dataSeries
        rs.item(at: 6).dataSeries = rs.item(at: 5).dataSeries
        rs.item(at: 5).dataSeries = rs.item(at: 4).dataSeries
        rs.item(at: 4).dataSeries = rs.item(at: 3).dataSeries
        rs.item(at: 3).dataSeries = rs.item(at: 2).dataSeries
        rs.item(at: 2).dataSeries = rs.item(at: 1).dataSeries
        rs.item(at: 1).dataSeries = rs.item(at: 0).dataSeries
        
        // use new dataSeries to draw first renderableSeries
        rs.item(at: 0).dataSeries = dataSeries
    }
    
    fileprivate func addLineRenderableSeries(_ colorCode: UInt32, opacity: Float){
        let lineRenderSeries = SCIFastLineRenderableSeries()
        lineRenderSeries.opacity = opacity
        lineRenderSeries.strokeStyle = SCISolidPenStyle.init(colorCode: colorCode, withThickness: 1)
        
        surface.renderableSeries.add(lineRenderSeries)
    }
}
