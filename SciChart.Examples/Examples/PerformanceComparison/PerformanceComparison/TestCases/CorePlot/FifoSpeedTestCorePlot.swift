// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FifoSpeedTestCorePlot.swift is part of the SCICHART® PerformanceComparison.
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

class FifoSpeedTestCorePlot: CorePlotSpeedTestBase, CPTScatterPlotDataSource {
    private let randomWalkGenerator = RandomWalkGenerator()
    private var xCount: Double = 0.0
    
    override func setUpChart(parent: UIView, testParameters: TestParameters, chartProviderParameters: IChartProviderParameters) {
        super.setUpChart(parent: parent, testParameters: testParameters, chartProviderParameters: chartProviderParameters)
        
        let visibleRange = graph.defaultPlotSpace as! CPTXYPlotSpace
        visibleRange.xRange = CPTPlotRange(location: NSNumber(value: 0), length: NSNumber(value: testParameters.pointCount))
        visibleRange.yRange = CPTPlotRange(location: NSNumber(value: 0), length: NSNumber(value: 1))
        
        let linePlot = CPTScatterPlot(frame: graph.bounds)
        linePlot.dataSource = self
        
        let lineStyle = CPTMutableLineStyle(style: linePlot.dataLineStyle)
        lineStyle.lineWidth = CGFloat(testParameters.strokeThikness)
        lineStyle.lineColor = CPTColor(cgColor: UIColor.random.cgColor)
        
        linePlot.dataLineStyle = lineStyle
        
        graph.add(linePlot)
    }
    
    override func initChart(testParameters: TestParameters) {
        let randomWalkData = randomWalkGenerator.getRandomWalkSeries(count: testParameters.pointCount, min: 0.0, max: 1.0)
        for i in 0..<randomWalkData.count {
            xValues.append(randomWalkData[i].x)
            yValues.append(randomWalkData[i].y)
            xCount += 1
        }
        
        graphHostingView.hostedGraph?.reloadData()
        graph.defaultPlotSpace?.scale(toFit: graph.allPlots())
    }
    
    override func updateChart(testParameters: TestParameters) {
        xValues.removeFirst()
        xValues.append(xCount)
            
        yValues.removeFirst()
        yValues.append(randomWalkGenerator.next(min: 0.0, max: 1.0))
            
        xCount += 1
        
        let visibleRange = graph.defaultPlotSpace as! CPTXYPlotSpace
        visibleRange.xRange = CPTPlotRange(location: NSNumber(value: Int(xCount) - testParameters.pointCount), length: NSNumber(value: testParameters.pointCount))
        
        graphHostingView.hostedGraph?.reloadData()
        graph.defaultPlotSpace?.scale(toFit: graph.allPlots())
    }
    
    // MARK: - CPTScatterPlotDataSource implementation
    
    func numberOfRecords(for plot: CPTPlot) -> UInt {
        return UInt(testParameters.pointCount)
    }
    
    func double(for plot: CPTPlot, field fieldEnum: UInt, record idx: UInt) -> Double {
        if (fieldEnum == UInt(CPTScatterPlotField.X.rawValue)) {
            return xValues[Int(idx)]
        }
        if (fieldEnum == UInt(CPTScatterPlotField.Y.rawValue)) {
            return yValues[Int(idx)]
        }
        return 0.0
    }
}
