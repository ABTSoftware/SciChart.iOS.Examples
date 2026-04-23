// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AppendSpeedTestCharts.swift is part of the SCICHART® PerformanceComparison.
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

class AppendSpeedTestCharts: ChartsSpeedTestBase {
    private let randomWalkGenerator = RandomWalkGenerator()
    private var xCount: Double = 0.0
    
    var chartDataSet: LineChartDataSet!

    override func createChartView() -> ChartViewBase! {
        let chart = LineChartView()
        chart.rightAxis.enabled = false
        
        return chart
    }
    
    override func initChart(testParameters: TestParameters) {
        let randomWalkData = randomWalkGenerator.getRandomWalkSeries(count: testParameters.pointCount, min: -0.5, max: 0.5, includePrior: true)
        for i in 0..<randomWalkData.count {
            chartDataEntries.append(ChartDataEntry(x: Double(i), y: randomWalkData[i].y))
            xCount += 1
        }
        
        chartDataSet = LineChartDataSet(entries: chartDataEntries, label: nil)
        chartDataSet.setColor(.blue)
        chartDataSet.lineWidth = CGFloat(testParameters.strokeThikness)
        chartDataSet.drawCirclesEnabled = false
        
        chart.data = LineChartData(dataSets: [chartDataSet])
    }
    
    override func updateChart(testParameters: TestParameters) {
        for _ in 0..<testParameters.appendPoints {
            chartDataSet.append(ChartDataEntry(x: xCount, y: randomWalkGenerator.next(min: -0.5, max: 0.5, includePrior: true)))
            
            xCount += 1
        }
        
        // Both needed to trigger range calculations and chart redraw
        chart.data?.notifyDataChanged()
        chart.notifyDataSetChanged()
    }
}
