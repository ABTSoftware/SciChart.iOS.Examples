//
//  SCSSeriesAppendingTestSciChart.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/29/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSSeriesAppendingTestSciChart: SCSTestBaseView {
    
    let randomWalkGenerator = SCSRandomWalkGenerator()
    let paliteColors = [UIColor.init(red: 0.8980, green: 0.2941, blue: 0.1058, alpha: 1),
                        UIColor.init(red: 0.2509, green: 0.5137, blue: 0.7176, alpha: 1),
                        UIColor.init(red: 0.9960, green: 0.6470, blue: 0.0039, alpha: 1)]
    
    var parameters: SCSTestParameters!
    var xCount: Int = 0
    var appendCount: Int32 = 0
    var series: [SCIXyDataSeries] = []
    
    // MARK: SpeedTestProtocol
    
    override func run(_ testParameters: SCSTestParameters) {
        parameters = testParameters
        addSeries()
    }
    
    override func updateChart() {
        if let delegate = delegate {
            delegate.chartExampleStarted()
        }
        
        var generalCountPoints : Int32 = 0
        for episod in series {
            var i = xCount;
            while i < xCount + parameters.appendPoints {
                episod.appendX(SCIGeneric(i), y: SCIGeneric(randomWalkGenerator.next(-0.5, max: 0.5, includePrior: true)))
                i += 1
            }
            generalCountPoints = generalCountPoints + episod.count()
        }
        xCount += parameters.appendPoints
        
        invalidateElement()
        
        if generalCountPoints > 1000000 {
            stop()
        }
        
    }
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addDefaultModifiers()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        
        let axisX = SCINumericAxis()
        axisX.autoRange = .always
        axisX.animatedChangeDuration = 1.0/30.0*2
        axisX.animateVisibleRangeChanges = true
        xAxes.add(axisX)
        
        let axisY = SCINumericAxis()
        axisY.autoRange = .always
        axisY.animatedChangeDuration = 1.0/30.0*2
        axisY.animateVisibleRangeChanges = true
        yAxes.add(axisY)
    }
    
    fileprivate func addSeries() {

        var seriesCount = 0
        var colorIndex = 0
        
        while seriesCount < parameters.seriesNumber {
            
            let dataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
            
            series.append(dataSeries)
            
            dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
            let randomData: [[Double]] = randomWalkGenerator.getRandomWalkSeries(parameters.pointCount, min: -0.5, max: 0.5, includePrior: true)
            
            var i: Int = 0
            while i < parameters.pointCount {
                let x = randomData[0][i]
                let y = randomData[1][i]
                dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
                i += 1
            }
            
            let renderSeries = SCIFastLineRenderableSeries()
            renderSeries.dataSeries = dataSeries
            
            if colorIndex >= paliteColors.count {
                colorIndex = 0
            }
            
            renderSeries.strokeStyle = SCISolidPenStyle(color: paliteColors[colorIndex], withThickness: 0.5)
            renderableSeries.add(renderSeries)
            

            colorIndex += 1
            seriesCount += 1
            
        }
        xCount += parameters.pointCount
        
        invalidateElement()
        
    }
    
    override func addDefaultModifiers() {
        // The example should be without modifiers.
    }
    
}



