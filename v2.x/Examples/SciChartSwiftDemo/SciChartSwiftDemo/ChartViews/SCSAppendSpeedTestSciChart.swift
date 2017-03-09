//
//  SCSAppendSpeedTestChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/29/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSAppendSpeedTestSciChart: SCSTestBaseView {
    
    let randomWalkGenerator = SCSRandomWalkGenerator()
    let dataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
    
    var xCount: Int = 0
    var appendCount: Int32 = 0
    var parameters: SCSTestParameters!
    
    
    // MARK: SpeedTestProtocol
    
    override func run(_ testParameters: SCSTestParameters) {
        parameters = testParameters
        appendCount = Int32(testParameters.appendPoints)
        
        var i = 0;
        while i < parameters.pointCount {
            dataSeries.appendX(SCIGeneric(xCount), y: SCIGeneric(randomWalkGenerator.next(-0.5, max: 0.5, includePrior: true)))
            xCount += 1
            i += 1
        }
        
        if let renderebleSeries = chartSurface.renderableSeries.firstObject() as? SCIFastLineRenderableSeries {
            
            
            renderebleSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFFffffff, withThickness: Float(parameters.strokeThikness))
            
        }
        
        chartSurface.invalidateElement()
    }
    
    override func updateChart() {
        if let delegate = delegate {
            delegate.chartExampleStarted()
            var i: Int32 = 0;
            while i < appendCount {
                dataSeries.appendX(SCIGeneric(xCount), y: SCIGeneric(randomWalkGenerator.next(-0.5, max: 0.5, includePrior: true)))
                xCount += 1
                i += 1
            }
            chartSurface.invalidateElement()
        }
    }
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addSeries()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        
        let axisStyle = generateDefaultAxisStyle()
        
        let axisX = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle);
        axisX.autoRange = .always
        axisX.animatedChangeDuration = 1.0/30.0*2
        axisX.animateVisibleRangeChanges = true
        
        chartSurface.xAxes.add(axisX)
        
        let axisY = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle);
        axisY.autoRange = .always
        axisY.animatedChangeDuration = 1.0/30.0*2
        axisY.animateVisibleRangeChanges = true
        
        chartSurface.yAxes.add(axisY)
        
        addDefaultModifiers()
        
    }
    
    fileprivate func addSeries() {

        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries
        
        chartSurface.renderableSeries.add(renderSeries)
        
    }
    
}
