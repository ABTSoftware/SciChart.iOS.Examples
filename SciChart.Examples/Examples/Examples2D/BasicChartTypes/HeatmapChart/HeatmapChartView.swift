//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// HeatmapChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class HeatmapChartView: SCDHeatmapChartViewControllerBase {
    
    static let height: Int = 200
    static let width: Int = 300
    let seriesPerPeriod = 30
    let timeInterval = 0.04
    
    var _dataSeries = SCIUniformHeatmapDataSeries(xType: .int, yType: .int, zType: .double, xSize: width, ySize: height)
    var _timerIndex: Int = 0
    var timer: Timer!
    var _running: Bool = false
    var _valuesArray = [SCIDoubleValues]()
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        let colors = [
            SCIColor.fromARGBColorCode(0xFF14233C),
            SCIColor.fromARGBColorCode(0xFF264B93),
            SCIColor.fromARGBColorCode(0xFF50C7E0),
            SCIColor.fromARGBColorCode(0xFF67BDAF),
            SCIColor.fromARGBColorCode(0xFFDC7969),
            SCIColor.fromARGBColorCode(0xFFF48420),
            SCIColor.fromARGBColorCode(0xFFEC0F6C)
        ]
        
        let heatmapRenderableSeries = SCIFastUniformHeatmapRenderableSeries()
        heatmapRenderableSeries.dataSeries = _dataSeries
        heatmapRenderableSeries.minimum = 0.0
        heatmapRenderableSeries.maximum = 200.0
        heatmapRenderableSeries.colorMap = SCIColorMap(colors: colors, andStops: [0.0, 0.2, 0.3, 0.5, 0.7, 0.9, 1.0])
        
        for i in 0 ..< seriesPerPeriod {
            _valuesArray.append(createValues(index: i))
        }
        
        heatmapColourMap.minimum = heatmapRenderableSeries.minimum
        heatmapColourMap.maximum = heatmapRenderableSeries.maximum
        heatmapColourMap.colourMap = heatmapRenderableSeries.colorMap
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        surface.renderableSeries.add(heatmapRenderableSeries)
        surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
        surface.chartModifiers.add(SCICursorModifier())
    }
    
    fileprivate func createValues(index: Int) -> SCIDoubleValues! {
        let values = SCIDoubleValues(capacity: HeatmapChartView.width * HeatmapChartView.height)
        
        let angle = .pi * 2.0 * Double(index) / Double(seriesPerPeriod)
        let cx = 150.0
        let cy = 100.0
        let cpMax = 200.0;
        // When appending data to SCIDoubleValues for the heatmap, always go Y then X
        for y in 0 ..< HeatmapChartView.height {
            for x in 0 ..< HeatmapChartView.width {
                let v = (1 + sin(Double(x) * 0.04 + angle)) * 50 + (1 + sin(Double(y) * 0.1 + angle)) * 50 * (1 + sin(angle * 2))
                let r = sqrt((Double(x) - cx) * (Double(x) - cx) + (Double(y) - cy) * (Double(y) - cy))
                let exp = max(0, 1 - r * 0.008)
                let zValue = v * exp + Double(arc4random_uniform(10));
                values.add(zValue > cpMax ? cpMax : zValue)                
            }
        }
        
        return values;
    }
    
    @objc func updateHeatmapData() {
        SCIUpdateSuspender.usingWith(surface) {
            let values = self._valuesArray[self._timerIndex % self.seriesPerPeriod]
            self._dataSeries.update(z: values)
            self._timerIndex += 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateHeatmapData), userInfo: nil, repeats: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if timer != nil {
            timer.invalidate()
            timer = nil
        }
    }
}
