//
//  SCSLegendChartView.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 8/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import SciChart
import UIKit

class SCSLegendChartView: SCSBaseChartView {
    
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
        let legend = SCILegendCollectionModifier(position: [.left, .top], andOrientation: .vertical)
        chartSurface.chartModifier = legend
    }
    
    func initializeSurfaceRenderableSeries() {
        self.attachRenderebleSeriesWithYValue(1000, andColor: UIColor.yellow, seriesName: "Curve A", isVisible: true)
        self.attachRenderebleSeriesWithYValue(2000, andColor: UIColor.green, seriesName: "Curve B", isVisible: true)
        self.attachRenderebleSeriesWithYValue(3000, andColor: UIColor.red, seriesName: "Curve C", isVisible: true)
        self.attachRenderebleSeriesWithYValue(4000, andColor: UIColor.blue, seriesName: "Curve D", isVisible: false)
    }
    
    func attachRenderebleSeriesWithYValue(_ yValue: Double, andColor color: UIColor, seriesName: String, isVisible: Bool) {
        let dataCount = 10
        let dataSeries1 = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        var y = yValue
        var i = 1
        while i <= dataCount {
            let x = i
            y = yValue + y
            dataSeries1.appendX(SCIGeneric(x), y: SCIGeneric(y))
            i += 1
        }
        dataSeries1.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        dataSeries1.seriesName = seriesName
        let renderableSeries1 = SCIFastLineRenderableSeries()
        renderableSeries1.style.linePen = SCISolidPenStyle(color: color, withThickness: 0.7)
        renderableSeries1.dataSeries = dataSeries1
        renderableSeries1.isVisible = isVisible
        chartSurface.renderableSeries.add(renderableSeries1)
        chartSurface.invalidateElement()
    }
    
}
