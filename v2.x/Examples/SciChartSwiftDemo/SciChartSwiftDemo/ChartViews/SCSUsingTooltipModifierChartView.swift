//
//  SCSUsingTooltipModifierChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import SciChart

class SCSUsingTooltipModifierChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addModifiers()
        addAxes()
        initializeSurfaceRenderableSeries()
    }
    
    fileprivate func addAxes() {
        chartSurface.xAxes.add(SCINumericAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    func addModifiers() {
        let toolTipModifier = SCITooltipModifier()
        toolTipModifier.style.colorMode = .seriesColorToDataView
        chartSurface.chartModifier = toolTipModifier
    }
    
    func initializeSurfaceRenderableSeries() {
        self.attachLissajousCurveSeries()
        self.attachSinewaveSeries()
    }
    
    func attachSinewaveSeries() {
        let dataCount = 500
        let freq = 10
        let amplitude = 1.5
        let phase = 1.0
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        dataSeries.seriesName = "Sinewave"
        var i = 0;
        while (i < dataCount) {
            let x = 10.0 * Double(i) / Double(dataCount)
            let wn = 2.0 * M_PI / (Double(dataCount) / Double(freq))
            let y = amplitude * sin(Double(i) * wn + phase)
            dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
            i += 1;
        }
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.style.linePen = SCISolidPenStyle(color: UIColor(red:255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0), withThickness: 0.5)
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = nil
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: UIColor(red: 255.0 / 255.0, green: 51.0 / 255.0, blue: 51.0 / 255.0, alpha: 1.0))
        ellipsePointMarker.height = 5
        ellipsePointMarker.width = 5
        rSeries.style.drawPointMarkers = true
        rSeries.style.pointMarker = ellipsePointMarker
        rSeries.dataSeries = dataSeries
        chartSurface.renderableSeries.add(rSeries)
        chartSurface.invalidateElement()
    }
    
    func attachLissajousCurveSeries() {
        let dataCount = 500
        let alpha = 0.8
        let beta = 0.2
        let delta = 0.43
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        dataSeries.acceptUnsortedData = true
        dataSeries.seriesName = "Lissajou"
        var i = 0
        while (i < dataCount) {
            let x = sin(alpha * Double(i) * 0.1 + delta)
            let y = sin(beta * Double(i) * 0.1)
            dataSeries.appendX(SCIGeneric((x + 1.0) * 5.0), y: SCIGeneric(y))
            i += 1
        }
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.style.linePen = SCISolidPenStyle(color: UIColor(red: 70.0 / 255.0, green: 130.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0), withThickness: 0.5)
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.strokeStyle = nil
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(color: UIColor(red: 70.0 / 255.0, green: 130.0 / 255.0, blue: 180.0 / 255.0, alpha: 1.0))
        ellipsePointMarker.height = 5
        ellipsePointMarker.width = 5
        rSeries.style.drawPointMarkers = true
        rSeries.style.pointMarker = ellipsePointMarker
        rSeries.dataSeries = dataSeries
        chartSurface.renderableSeries.add(rSeries)
        chartSurface.invalidateElement()
    }
    

}
