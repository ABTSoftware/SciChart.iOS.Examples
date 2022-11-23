//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
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

class RealTimeGhostTracesChartView: SCDSingleChartWithTopPanelViewController<SCIChartSurface> {
    
    private lazy var actionItem: SCDRealTimeGhostTracesToolbarItem = {
        let item = SCDRealTimeGhostTracesToolbarItem { [weak self] doubleValue in
            guard let self = self else { return }
            
            if (doubleValue > 0) {
                self._timer?.invalidate()
                self.startTimer(with: doubleValue)
            }
        }
        return item
    }()
    
    private var _timer: Timer?
    private var _lastAmplitude = 1.0
    private var _phase = 0.0
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }

#if os(OSX)
    override func provideExampleSpecificToolbarItems() -> [ISCDToolbarItem] {
        return [actionItem]
    }
#elseif os(iOS)
    override func providePanel() -> SCIView {
        return actionItem.createView()
    }
#endif
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .never
        yAxis.visibleRange = SCIDoubleRange.init(min: -2, max: 2)
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        
        let limeGreen: uint = 0xFF68bcae
        
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

        startTimer(with: actionItem.sliderValue)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        _timer?.invalidate()
        _timer = nil
    }
    
    private func startTimer(with sliderValue: Double) {
        _timer = Timer.scheduledTimer(timeInterval: sliderValue / 1000, target: self, selector: #selector(updateData), userInfo: nil, repeats: true)
    }
    
    @objc private func updateData(_ timer: Timer) {
        SCIUpdateSuspender.usingWith(surface) {
            let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)

            var randomAmplitude:Double = self._lastAmplitude + (SCDRandomUtil.nextDouble() - 0.5)
            if (randomAmplitude < -2.0) {
                randomAmplitude = -2.0
            } else if (randomAmplitude > 2.0) {
                randomAmplitude = 2.0;
            }
            
            let noisySinewave = SCDDataManager.getNoisySinewave(withAmplitude: randomAmplitude, phase: self._phase, pointCount: 1000, noiseAmplitude: 0.25)
            self._lastAmplitude = randomAmplitude;
            
            dataSeries.append(x: noisySinewave.xValues, y: noisySinewave.yValues)
            self.reassignRenderSeriesWith(dataSeries: dataSeries)
        }
    }
    
    private func reassignRenderSeriesWith(dataSeries: SCIXyDataSeries) {
        let rSeries = surface.renderableSeries
        
        // shift old dataSeries
        rSeries.item(at: 9).dataSeries = rSeries.item(at: 8).dataSeries
        rSeries.item(at: 8).dataSeries = rSeries.item(at: 7).dataSeries
        rSeries.item(at: 7).dataSeries = rSeries.item(at: 6).dataSeries
        rSeries.item(at: 6).dataSeries = rSeries.item(at: 5).dataSeries
        rSeries.item(at: 5).dataSeries = rSeries.item(at: 4).dataSeries
        rSeries.item(at: 4).dataSeries = rSeries.item(at: 3).dataSeries
        rSeries.item(at: 3).dataSeries = rSeries.item(at: 2).dataSeries
        rSeries.item(at: 2).dataSeries = rSeries.item(at: 1).dataSeries
        rSeries.item(at: 1).dataSeries = rSeries.item(at: 0).dataSeries
        
        // use new dataSeries to draw first renderableSeries
        rSeries.item(at: 0).dataSeries = dataSeries
    }
    
    private func addLineRenderableSeries(_ colorCode: UInt32, opacity: Float) {
        let lineRenderSeries = SCIFastLineRenderableSeries()
        lineRenderSeries.opacity = opacity
        lineRenderSeries.strokeStyle = SCISolidPenStyle.init(color: colorCode, thickness: 1)
        
        surface.renderableSeries.add(lineRenderSeries)
    }
}
