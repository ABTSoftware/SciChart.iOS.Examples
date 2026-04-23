// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ChartsSpeedTestBase.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit
import Charts

class ChartsSpeedTestBase: SpeedTestBase, ISpeedTest {
    var chart: ChartViewBase!
    
    var chartDataEntries = [ChartDataEntry]()
    
    func setUpChart(parent: UIView, testParameters: TestParameters, chartProviderParameters: IChartProviderParameters) {
        chart = createChartView()
        chart.drawMarkers = false
        chart.legend.enabled = false
        
        chart.backgroundColor = .white
        
        setUpChartView(chartView: chart!, parentView: parent)
    }

    func createChartView() -> ChartViewBase! {
        preconditionFailure("This method must be overridden")
    }
    
    func initChart(testParameters: TestParameters) {
        preconditionFailure("This method must be overridden")
    }
    
    func updateChart(testParameters: TestParameters) {
        preconditionFailure("This method must be overridden")
    }
    
    func clear() {
        chart.removeFromSuperview()
        chart = nil
    }
}
