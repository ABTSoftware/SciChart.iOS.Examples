//
//  SCSUsingCursorModifierChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 9/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import SciChart

class SCSUsingCursorModifierChartView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addModifiers()
        addAxes()
        initializeSurfaceRenderableSeries()
    }
    
    fileprivate func addAxes() {
        let axisStyle = generateDefaultAxisStyle()
        chartSurface.xAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle))
        chartSurface.yAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle))
    }
    
    func addModifiers() {
        let cursorModifier = SCICursorModifier()
        cursorModifier.style.colorMode = .seriesColorToDataView
        chartSurface.chartModifier = cursorModifier
    }
    
    func initializeSurfaceRenderableSeries() {
        let greenLine = rSeriesCreateWithColor(UIColor.green)
        greenLine.dataSeries.seriesName = "Green"
        generateSinewaveSeriesWithAmplitude(300, phase: 1.0, dataCout: 300, noiseAmplitude: 0.25, intoDataSeries: greenLine.dataSeries)
        let redLine = rSeriesCreateWithColor(UIColor.red)
        redLine.dataSeries.seriesName = "Red"
        generateSinewaveSeriesWithAmplitude(100, phase: 2.0, dataCout: 300, noiseAmplitude: 0.0, intoDataSeries: redLine.dataSeries)
        let grayLine = rSeriesCreateWithColor(UIColor.gray)
        grayLine.dataSeries.seriesName = "Gray"
        generateSinewaveSeriesWithAmplitude(200, phase: 1.5, dataCout: 300, noiseAmplitude: 0.0, intoDataSeries: grayLine.dataSeries)
        chartSurface.invalidateElement()
    }
    
    func rSeriesCreateWithColor(_ color: UIColor) -> SCIRenderableSeriesBase {
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.style.linePen = SCISolidPenStyle(color: color, withThickness: 0.5)
        rSeries.dataSeries = dataSeries
        chartSurface.renderableSeries.add(rSeries)
        return rSeries
    }
    
    func generateSinewaveSeriesWithAmplitude<DT: SCIDataSeriesProtocol>(_ amplitude: Double, phase: Double, dataCout dataCount: Int32, noiseAmplitude noise: Double, intoDataSeries dataSeries: DT) {
        let freq = 10
        var i :Int32 = 0
        while (i < dataCount) {
            let x = 10.0 * Double(i) / Double(dataCount)
            let wn = 2 * M_PI / (Double(dataCount) / Double(freq))
            var y = amplitude * sin(Double(i) * wn + phase)
            if noise > 0 {
                y = y + SCSDataManager.randomize(-5, max: 5) * noise - noise * 0.5
            }
            dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
            i += 1
        }
    }

}


