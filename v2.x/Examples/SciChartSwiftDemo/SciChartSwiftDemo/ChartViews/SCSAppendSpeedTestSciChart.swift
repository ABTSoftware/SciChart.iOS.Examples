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
    let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
    
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
        
        var i = 0;
        while i < parameters.pointCount {
            dataSeries.appendX(SCIGeneric(xCount), y: SCIGeneric(randomWalkGenerator.next(-0.5, max: 0.5, includePrior: true)))
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
            var i: Int32 = 0;
            while i < appendCount {
                dataSeries.appendX(SCIGeneric(xCount), y: SCIGeneric(randomWalkGenerator.next(-0.5, max: 0.5, includePrior: true)))
                xCount += 1
                i += 1
            }
            
        }
    }
    
    // MARK: Overrided Functions
    
    func completeConfiguration() {
        addSurface()
        SCIUpdateSuspender.usingWithSuspendable(surface) { [unowned self] in
            self.addAxes()
            self.addDefaultModifiers()
            self.addSeries()
        }
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
    }
    
    fileprivate func addSeries() {

        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries
        
        surface.renderableSeries.add(renderSeries)
    }
    
    func addDefaultModifiers() {
        // The example should be without modifiers.
    }
    
}
