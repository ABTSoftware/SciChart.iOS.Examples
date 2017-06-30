//
//  SCSFIFOSpeedTestSciChart.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/29/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSFIFOSpeedTestSciChart: SCSTestBaseView {
    
    let randomWalkGenerator = SCSRandomWalkGenerator()
    
    var dataSeries : SCIXyDataSeries!
    var xCount: Int = 0
    var appendCount: Int32 = 0
    var parameters: SCSTestParameters!
    let surface = SCIChartSurface()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    // MARK: initialize surface
    fileprivate func addSurface() {
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(surface)
    }

    // MARK: SpeedTestProtocol
    
    override func run(_ testParameters: SCSTestParameters) {
        parameters = testParameters
        appendCount = Int32(testParameters.appendPoints)
        
        addSeries()
        
        var i = 0;
        while i < parameters.pointCount {
            dataSeries.appendX(SCIGeneric(xCount), y: SCIGeneric(randomWalkGenerator.next(0.0, max: 1.0, includePrior: false)))
            xCount += 1
            i += 1
        }
        
        if let renderebleSeries = surface.renderableSeries.firstObject() as? SCIFastLineRenderableSeries {
            renderebleSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFFffffff, withThickness: Float(parameters.strokeThikness))
        }
        
        
    }
    
    override func updateChart() {
    
        if let delegate = delegate {
            
            delegate.chartExampleStarted()
            
            dataSeries.appendX(SCIGeneric(xCount), y: SCIGeneric(randomWalkGenerator.next(0.0, max: 1.0, includePrior: false)))
            xCount += 1
            
            
        }
        
    }
    
    // MARK: Overrided Functions
    
    func completeConfiguration() {
        addSurface()
        addAxes()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        
        let axisX = SCINumericAxis()
        axisX.autoRange = .always
        axisX.animatedChangeDuration = 1.0/30.0*2
        axisX.animateVisibleRangeChanges = true
        
        surface.xAxes.add(axisX)
        
        let axisY = SCINumericAxis()
        axisY.autoRange = .always
        axisY.animatedChangeDuration = 1.0/30.0*2
        axisY.animateVisibleRangeChanges = true
        
        surface.yAxes.add(axisY)
        
        addDefaultModifiers()
        
    }
    
    fileprivate func addSeries() {
        dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        dataSeries.fifoCapacity = 1500
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries
        
        surface.renderableSeries.add(renderSeries)
        
    }
    
    func addDefaultModifiers() {
        // The example should be without modifiers.
    }
    
}

