// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SciChartSpeedTestBase.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit
import SciChart

class SciChartSpeedTestBase: SpeedTestBase, ISpeedTest {
    var surface: SCIChartSurface!
    var dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
    var resamplingMode: SCIResamplingMode!
    
    func setUpChart(parent: UIView, testParameters: TestParameters, chartProviderParameters: IChartProviderParameters) {
        surface = SCIChartSurface(frame: parent.bounds)
        
        let sciChartParameters = chartProviderParameters as! SciChartParameters
        resamplingMode = sciChartParameters.resamplingMode
        // surface.renderSurface = sciChartParameters.useMetal ? SCIMetalRenderSurface() : SCIOpenGLRenderSurface()
        
        setUpChartView(chartView: surface, parentView: parent)
    }
    
    func initChart(testParameters: TestParameters) {
        preconditionFailure("This method must be overridden")
    }
    
    func updateChart(testParameters: TestParameters) {
        preconditionFailure("This method must be overridden")
    }
    
    func clear() {
        surface.removeFromSuperview()
        surface = nil
    }
}
