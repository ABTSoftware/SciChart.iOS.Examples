// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// NxMSeriesSpeedTestCorePlot.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit
import CorePlot

class NxMSeriesSpeedTestCorePlot: CorePlotSpeedTestBase, CPTScatterPlotDataSource {
    private let randomWalkGenerator = RandomWalkGenerator()
    
    private var updateNumber = 0
    private var rangeMin = Double.nan
    private var rangeMax = Double.nan

    override func setUpChart(parent: UIView, testParameters: TestParameters, chartProviderParameters: IChartProviderParameters) {
        super.setUpChart(parent: parent, testParameters: testParameters, chartProviderParameters: chartProviderParameters)
        
        let visibleRange = graph.defaultPlotSpace as! CPTXYPlotSpace
        visibleRange.xRange = CPTPlotRange(location: NSNumber(value: 0), length: NSNumber(value: testParameters.pointCount))
        visibleRange.yRange = CPTPlotRange(location: NSNumber(value: -2), length: NSNumber(value: 4))
    }
    
    override func initChart(testParameters: TestParameters) {
        for i in 0..<testParameters.seriesNumber {
            randomWalkGenerator.reset()
            let randomWalkData = randomWalkGenerator.getRandomWalkSeries(count: testParameters.pointCount, min: -0.5, max: 0.5, includePrior: true)
            for j in 0..<randomWalkData.count {
                xValues.append(randomWalkData[j].x)
                yValues.append(randomWalkData[j].y)
            }
            
            let linePlot = CPTScatterPlot(frame: graph.bounds)
            linePlot.identifier = NSString(string: "\(i)")
            linePlot.dataSource = self
            
            let lineStyle = CPTMutableLineStyle(style: linePlot.dataLineStyle)
            lineStyle.lineWidth = CGFloat(testParameters.strokeThikness)
            lineStyle.lineColor = CPTColor(cgColor: UIColor.random.cgColor)
            
            linePlot.dataLineStyle = lineStyle
            
            graph.add(linePlot)
        }
        
        graphHostingView.hostedGraph?.reloadData()
    }
    
    override func updateChart(testParameters: TestParameters) {
        let visibleRange = graph.defaultPlotSpace as! CPTXYPlotSpace
        if (rangeMin.isNaN) {
            rangeMin = visibleRange.yRange.minLimitDouble
            rangeMax = visibleRange.yRange.maxLimitDouble
        }
        let scaleFactor = fabs(sin(Double(updateNumber) * 0.1)) + 0.5;
        
        visibleRange.yRange = CPTPlotRange(location: NSNumber(value: rangeMin * scaleFactor), length: NSNumber(value: (rangeMax - rangeMin) * scaleFactor))
        
        graphHostingView.hostedGraph?.reloadData()
        updateNumber += 1
    }
    
    // MARK: - CPTScatterPlotDataSource implementation
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(testParameters.pointCount)
    }
    
    func double(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Double {
        var seriesIndex: UInt = 0
        for i in 0..<testParameters.seriesNumber {
            if ((plot.identifier as! NSString).isEqual(to: "\(i)")) {
                seriesIndex = UInt(i)
            }
        }
        
        if (fieldEnum == UInt(CPTScatterPlotField.X.rawValue)) {
            return xValues[Int(seriesIndex * UInt(testParameters.pointCount) + idx)]
        }
        if (fieldEnum == UInt(CPTScatterPlotField.Y.rawValue)) {
            return yValues[Int(seriesIndex * UInt(testParameters.pointCount) + idx)]
        }
        return 0.0
    }
}
