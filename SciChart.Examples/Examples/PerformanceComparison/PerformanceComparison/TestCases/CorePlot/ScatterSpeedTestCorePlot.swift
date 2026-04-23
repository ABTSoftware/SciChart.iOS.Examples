// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ScatterSpeedTestCorePlot.swift is part of the SCICHART® PerformanceComparison.
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

class ScatterSpeedTestCorePlot: CorePlotSpeedTestBase, CPTScatterPlotDataSource {
    
    override func setUpChart(parent: UIView, testParameters: TestParameters, chartProviderParameters: IChartProviderParameters) {
        super.setUpChart(parent: parent, testParameters: testParameters, chartProviderParameters: chartProviderParameters)
        
        let visibleRange = graph.defaultPlotSpace as! CPTXYPlotSpace
        visibleRange.xRange = CPTPlotRange(location: NSNumber(value: 0), length: NSNumber(value: testParameters.pointCount))
        visibleRange.yRange = CPTPlotRange(location: NSNumber(value: -50), length: NSNumber(value: 100))
        
        let linePlot = CPTScatterPlot(frame: graph.bounds)
        linePlot.dataSource = self
        
        let lineStyle = CPTMutableLineStyle(style: linePlot.dataLineStyle)
        lineStyle.lineWidth = CGFloat(0)
        
        linePlot.dataLineStyle = lineStyle
        
        graph.add(linePlot)
    }
    
    override func initChart(testParameters: TestParameters) {
        let brownianMotionData = BrownianMotionGenerator.getRandomData(min: -50, max: 50, count: testParameters.pointCount)
        
        for i in 0..<brownianMotionData.count {
            xValues.append(brownianMotionData[i].x)
            yValues.append(brownianMotionData[i].y)
        }
        
        graphHostingView.hostedGraph?.reloadData()
    }
    
    override func updateChart(testParameters: TestParameters) {
        for i in 0..<testParameters.pointCount {
            xValues[i] = xValues[i] + BrownianMotionGenerator.getRandomPoint(min: -1.0, max: 1.0)
            yValues[i] = yValues[i] + BrownianMotionGenerator.getRandomPoint(min: -0.5, max: 0.5)
        }
        
        graphHostingView.hostedGraph?.reloadData()
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
    
    func symbol(for plot: CPTScatterPlot, record idx: UInt) -> CPTPlotSymbol? {
        let plotSymbol = CPTPlotSymbol.ellipse()
        plotSymbol.size = CGSize(width: 6, height: 6)
        plotSymbol.fill = CPTFill(color: CPTColor.blue())
        plotSymbol.lineStyle = nil
        
        plot.plotSymbol = plotSymbol
        
        return plotSymbol
    }
}
