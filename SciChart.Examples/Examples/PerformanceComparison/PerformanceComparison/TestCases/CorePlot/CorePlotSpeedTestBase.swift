// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CorePlotSpeedTestBase.swift is part of the SCICHART® PerformanceComparison.
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

class CorePlotSpeedTestBase: SpeedTestBase, ISpeedTest {
    var graphHostingView: CPTGraphHostingView!
    var graph: CPTXYGraph!
    
    var xValues = [Double]()
    var yValues = [Double]()
    
    var testParameters: TestParameters!
    
    func setUpChart(parent: UIView, testParameters: TestParameters, chartProviderParameters: IChartProviderParameters) {
        self.testParameters = testParameters
        
        graphHostingView = CPTGraphHostingView(frame: parent.bounds)
        graphHostingView.allowPinchScaling = false
        
        graph = CPTXYGraph(frame: graphHostingView.bounds)
        graph.backgroundColor = UIColor.white.cgColor

        graphHostingView.hostedGraph = graph
        
        graph.paddingLeft = 0.0;
        graph.paddingTop = 0.0;
        graph.paddingRight = 0.0;
        graph.paddingBottom = 0.0;

        let axisSet = graph.axisSet as! CPTXYAxisSet
        axisSet.xAxis?.labelingPolicy = .automatic
        axisSet.yAxis?.labelingPolicy = .automatic
        
        setUpChartView(chartView: graphHostingView, parentView: parent)
    }
    
    func initChart(testParameters: TestParameters) {
        preconditionFailure("This method must be overridden")
    }
    
    func updateChart(testParameters: TestParameters) {
        preconditionFailure("This method must be overridden")
    }
    
    func clear() {
        graphHostingView.removeFromSuperview()
        graphHostingView = nil
        graph = nil
    }
}
