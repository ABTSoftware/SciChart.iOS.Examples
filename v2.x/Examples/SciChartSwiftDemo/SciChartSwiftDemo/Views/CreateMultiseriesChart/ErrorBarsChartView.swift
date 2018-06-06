//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
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

class ErrorBarsChartView: SingleChartLayout {
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        
        let dataSeries0 = SCIHlDataSeries(xType: .double, yType: .double)
        let dataSeries1 = SCIHlDataSeries(xType: .double, yType: .double)
        
        let data: DoubleSeries = DataManager.getFourierSeries(withAmplitude: 1.0, phaseShift: 0.1, xStart: 5.0, xEnd: 5.15, count: 5000)
        
        fillSeries(dataSeries: dataSeries0, sourceData: data, scale: 1.0)
        fillSeries(dataSeries: dataSeries1, sourceData: data, scale: 1.3)
        
        let color: uint = 0xFFC6E6FF
        let errorBars0 = SCIFastErrorBarsRenderableSeries()
        errorBars0.strokeStyle = SCISolidPenStyle(colorCode: color, withThickness: 1.0)
        errorBars0.dataSeries = dataSeries0

        let pMarker = SCIEllipsePointMarker()
        pMarker.width = 5
        pMarker.height = 5
        pMarker.fillStyle = SCISolidBrushStyle(colorCode: color)

        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFC6E6FF, withThickness: 1.0)
        lineSeries.dataSeries = dataSeries0
        lineSeries.style.pointMarker = pMarker
        
        let errorBars1 = SCIFastErrorBarsRenderableSeries()
        errorBars1.strokeStyle = SCISolidPenStyle(colorCode: 0xFFC6E6FF, withThickness: 1.0)
        errorBars1.dataSeries = dataSeries1
        errorBars1.dataPointWidth = 0.7;
        
        let sMarker = SCIEllipsePointMarker()
        sMarker.width = 7
        sMarker.height = 7
        sMarker.fillStyle = SCISolidBrushStyle(colorCode:0x00FFFFFF)
        
        let scatterSeries = SCIXyScatterRenderableSeries()
        scatterSeries.dataSeries = dataSeries1
        scatterSeries.style.pointMarker = sMarker
        
        surface.renderableSeries.add(scatterSeries)
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(lineSeries)
            self.surface.renderableSeries.add(scatterSeries)
            self.surface.renderableSeries.add(errorBars0)
            self.surface.renderableSeries.add(errorBars1)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
            
            errorBars0.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            lineSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            errorBars1.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
            scatterSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic))
        }
    }
    
    fileprivate func fillSeries(dataSeries: SCIHlDataSeriesProtocol, sourceData: DoubleSeries, scale: Double) {
        let xValues: SCIArrayController = sourceData.getXArray()
        let yValues: SCIArrayController = sourceData.getYArray()
        
        for i in 0..<xValues.count() {
            let y = SCIGenericDouble(yValues.value(at: i)) * scale;
            dataSeries.appendX(xValues.value(at: i), y: SCIGeneric(y), high: SCIGeneric(drand48() * 0.2), low: SCIGeneric(drand48() * 0.2))
        }
    }
}
