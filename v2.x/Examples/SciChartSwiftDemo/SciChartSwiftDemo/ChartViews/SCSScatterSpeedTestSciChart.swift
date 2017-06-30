//
//  SCSScatterSpeedTestSciChart.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/29/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSScatterSpeedTestSciChart: SCSTestBaseView {
    
    let randomWalkGenerator = SCSBrownianMotionGenerator()
    let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
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
        SCIUpdateSuspender.usingWithSuspendable(surface) { [unowned self] in
            self.addDefaultModifiers()
            self.addSeries()
            self.dataSeries.acceptUnsortedData = true
        }
     
    }
    
    override func updateChart() {
        
        if let delegate = delegate {
            delegate.chartExampleStarted()
        }
        
        var i: Int32 = 0
        while i < dataSeries.count() {
            
            let x = SCIGenericDouble((dataSeries.xValues().value(at: i)))
            let y = SCIGenericDouble((dataSeries.yValues().value(at: i)))
            let randX = randomize(-1.0, max: 1.0)
            let randY = randomize(-1.0, max: 1.0)
            dataSeries.update(at: Int32(i),
                               x: SCIGeneric(x+randX),
                               y: SCIGeneric(y+randY))
            i += 1
        }
        
        surface.invalidateElement()
        
    }
    
    // MARK: Overrided Functions
    
        func completeConfiguration() {
        addSurface()
        addAxes()
    }
    
    // MARK: Private Functions
    
    fileprivate func randomize(_ min: Double, max: Double) -> Double {
        return RandomUtil.nextDouble() * (max - min) + min
    }
    
    fileprivate func addAxes() {
        
        let axisX = SCINumericAxis()
        axisX.autoRange = .once
        surface.xAxes.add(axisX)
        
        let axisY = SCINumericAxis()
        axisY.visibleRange = SCIDoubleRange(min: SCIGeneric(-50), max: SCIGeneric(50))
        surface.yAxes.add(axisY)
    }
    
    fileprivate func addSeries() {
        
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let randomData = randomWalkGenerator.getXyData(parameters.pointCount, min: -50.0, max: 50.0)
        
        for i in 0..<parameters.pointCount {
            
            let x = randomData[0][i]
            let y = randomData[1][i]
            
            dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
        }
        
        let renderSeries = SCIXyScatterRenderableSeries()
        renderSeries.dataSeries = dataSeries
        
        let ellipse = SCIEllipsePointMarker()
        ellipse.fillStyle = SCISolidBrushStyle(color: UIColor.black)
        ellipse.strokeStyle = SCISolidPenStyle(color: UIColor.blue, withThickness: 0.5)
        ellipse.detalization = 10
        ellipse.height = 6.0
        ellipse.width = 6.0
        let marker = SCICoreGraphicsPointMarker()
        marker.height = 6.0
        marker.width = 6.0
        
        renderSeries.style.pointMarker = marker
        
        surface.renderableSeries.add(renderSeries)
        
    }
    
    func addDefaultModifiers() {
        // The example should be without modifiers.
    }
    
}

