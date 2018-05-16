//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSNxMSeriesSpeedTestSciChart.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit
import SciChart

class SCSNxMSeriesSpeedTestSciChart: SCSTestBaseView {
    
    let randomWalkGenerator = SCSRandomWalkGenerator()
    
//    var delegate: SCSDrawingProtocolDelegate?
//    var chartProviderName: String = "SciChart"
    
    var parameters: SCSTestParameters!
    var rangeMin = Double.nan
    var rangeMax = Double.nan
    var updateNumber = 0
    let surface = SCIChartSurface()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSurface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addSurface()
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
            self.addAxes()
            self.addDefaultModifiers()
            self.addSeries()
        }
    }
    
    override func updateChart() {
        
        if let delegate = delegate {
            delegate.chartExampleStarted()
        }
        
        if rangeMin.isNaN {
            rangeMin = SCIGenericDouble(surface.yAxes.item(at: 0).visibleRange.min)
            rangeMax = SCIGenericDouble(surface.yAxes.item(at: 0).visibleRange.max)
        }
        
        let scaleFactor = fabs(sin(Double(updateNumber)*0.1)) + 0.5
        
        if let yAxis = surface.yAxes[0] {
            yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(rangeMin * scaleFactor),
                                                 max: SCIGeneric(rangeMax * scaleFactor))
        }
        
        
        updateNumber += 1
        
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let axisX = SCINumericAxis()
        axisX.autoRange = .once
        surface.xAxes.add(axisX)
        
        let axisY = SCINumericAxis()
        axisY.autoRange = .once
        surface.yAxes.add(axisY)
    }
    
    fileprivate func addSeries() {
        var color: UInt32 = 0xFF0F0505
        var series: Int32 = 0
        while series < Int32(parameters.seriesNumber) {
            
            let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
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
            renderSeries.strokeStyle = SCISolidPenStyle(colorCode: color, withThickness: 0.5)
            
            surface.renderableSeries.add(renderSeries)
            
            color = color + 0x00000101;
            
            series += 1
            
        }
        
        
        
    }
    
    func addDefaultModifiers() {
        // The example should be without modifiers.
    }
    
    
}

