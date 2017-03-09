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
    let dataSeries = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
    var parameters: SCSTestParameters!
    
    // MARK: SpeedTestProtocol
    
    override func run(_ testParameters: SCSTestParameters) {
        parameters = testParameters
        addSeries()
        chartSurface.invalidateElement()
        dataSeries.acceptUnsortedData = true
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
        
        
        chartSurface.invalidateElement()
    }
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
    }
    
    // MARK: Private Functions
    
    fileprivate func randomize(_ min: Double, max: Double) -> Double {
        return (Double(arc4random()) / 0x100000000) * (max - min) + min
    }
    
    fileprivate func addAxes() {
        
        let axisStyle = generateDefaultAxisStyle()
        
        let axisX = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle);
        axisX.autoRange = .once
        chartSurface.xAxes.add(axisX)
        
        let axisY = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle);
        axisY.visibleRange = SCIDoubleRange(min: SCIGeneric(-50), max: SCIGeneric(50))
        chartSurface.yAxes.add(axisY)
        
        addDefaultModifiers()
        
    }
    
    fileprivate func addSeries() {
        
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let randomData = randomWalkGenerator.getXyData(parameters.pointCount, min: -50.0, max: 50.0)
        
        var i = 0
        while i < parameters.pointCount {
            
            let x = randomData[0][i]
            let y = randomData[1][i]
            
            dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
            
            i += 1
        }
        
        let renderSeries = SCIXyScatterRenderableSeries()
        renderSeries.dataSeries = dataSeries
        
        let ellipse = SCIEllipsePointMarker()
        ellipse.drawBorder = true
        ellipse.fillBrush = SCISolidBrushStyle(color: UIColor.black)
        ellipse.borderPen = SCISolidPenStyle(color: UIColor.blue, withThickness: 0.5)
        ellipse.detalization = 10
        ellipse.height = 6.0
        ellipse.width = 6.0
        let marker = SCICoreGraphicsPointMarker()
        marker.height = 6.0
        marker.width = 6.0
        
        renderSeries.style.pointMarker = marker
        
        chartSurface.renderableSeries.add(renderSeries)
        
    }
    
}

