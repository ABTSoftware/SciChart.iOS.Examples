//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ErrorBarsChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class ErrorBarsChartView: SCDErrorBarsChartViewControllerBase {
    
    override func initExample() {
        let dataSeries0 = SCIHlDataSeries(xType: .double, yType: .double)
        let dataSeries1 = SCIHlDataSeries(xType: .double, yType: .double)
        
        let data = SCDDataManager.getFourierSeries(withAmplitude: 1.0, phaseShift: 0.1, xStart: 5.0, xEnd: 5.15, count: 5000)
        fillSeries(dataSeries: dataSeries0, sourceData: data, scale: 1.0)
        fillSeries(dataSeries: dataSeries1, sourceData: data, scale: 1.3)
        
        let color: uint = 0xFFC6E6FF
        
        let pMarker = SCIEllipsePointMarker()
        pMarker.size = CGSize(width: 5, height: 5)
        pMarker.fillStyle = SCISolidBrushStyle(color: color)

        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = dataSeries0
        lineSeries.pointMarker = pMarker
        lineSeries.strokeStyle = SCISolidPenStyle(color: color, thickness: 1.0)
        
        errorBars0 = SCIFastErrorBarsRenderableSeries()
        errorBars0.dataSeries = dataSeries0
        errorBars0.strokeStyle = SCISolidPenStyle(color: color, thickness: strokeThickness)
        errorBars0.errorDirection = .vertical
        errorBars0.errorType = .absolute
        errorBars0.dataPointWidth = dataPointWidth
        
        errorBars1 = SCIFastErrorBarsRenderableSeries()
        errorBars1.dataSeries = dataSeries1
        errorBars1.strokeStyle = SCISolidPenStyle(color: color, thickness: strokeThickness)
        errorBars1.errorDirection = .vertical
        errorBars1.errorType = .absolute
        errorBars1.dataPointWidth = dataPointWidth
        
        let sMarker = SCIEllipsePointMarker()
        sMarker.size = CGSize(width: 7, height: 7)
        sMarker.fillStyle = SCISolidBrushStyle(color:0x00FFFFFF)
        sMarker.strokeStyle = SCISolidPenStyle(color: color, thickness: 1.0)
        
        let scatterSeries = SCIXyScatterRenderableSeries()
        scatterSeries.dataSeries = dataSeries1
        scatterSeries.pointMarker = sMarker
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(SCINumericAxis())
            self.surface.yAxes.add(SCINumericAxis())
            self.surface.renderableSeries.add(items: lineSeries, scatterSeries, self.errorBars0, self.errorBars1)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            
            SCIAnimations.scale(lineSeries, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(scatterSeries, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(self.errorBars0, duration: 3.0, andEasingFunction: SCIElasticEase())
            SCIAnimations.scale(self.errorBars1, duration: 3.0, andEasingFunction: SCIElasticEase())
        }
    }
    
    fileprivate func fillSeries(dataSeries: ISCIHlDataSeries, sourceData: SCDDoubleSeries, scale: Double) {
        let xValues = sourceData.xValues
        let yValues = sourceData.yValues
        
        let highValues = SCIDoubleValues()
        let lowValues = SCIDoubleValues()
        for i in 0 ..< xValues.count {
            yValues.set(yValues.getValueAt(i) * scale, at: i)
            highValues.add(randf(0.0, 1.0) * 0.2)
            lowValues.add(randf(0.0, 1.0) * 0.2)
        }
        
        dataSeries.append(x: xValues, y: yValues, high: highValues, low: lowValues)
    }
}
