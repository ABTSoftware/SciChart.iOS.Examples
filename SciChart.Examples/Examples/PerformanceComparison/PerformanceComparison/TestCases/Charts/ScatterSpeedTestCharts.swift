// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ScatterSpeedTestCharts.swift is part of the SCICHART® PerformanceComparison.
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

class ScatterSpeedTestCharts: ChartsSpeedTestBase {
    private let randomWalkGenerator = RandomWalkGenerator()
    
    private var updateNumber = 0
    private var rangeMin = Double.nan
    private var rangeMax = Double.nan
    
    private var leftAxis: YAxis!
    var chartDataSet: ScatterChartDataSet!
    
    override func createChartView() -> ChartViewBase! {
        let chart = ScatterChartView()
        chart.rightAxis.enabled = false
        leftAxis = chart.leftAxis
        
        return chart
    }
    
    override func initChart(testParameters: TestParameters) {
        let brownianMotionData = BrownianMotionGenerator.getRandomData(min: -50, max: 50, count: testParameters.pointCount)
    
        for i in 0..<brownianMotionData.count {
            chartDataEntries.append(ChartDataEntry(x: brownianMotionData[i].x, y: brownianMotionData[i].y))
        }
        
        chartDataSet = ScatterChartDataSet(entries: chartDataEntries, label: nil)
        chartDataSet.setColor(.blue)
        chartDataSet.setScatterShape(.circle)
        chartDataSet.scatterShapeHoleColor = .white
        chartDataSet.scatterShapeHoleRadius = 2.5
        chartDataSet.scatterShapeSize = 8.0
        
        chart.data = ScatterChartData(dataSets: [chartDataSet])
    }
    
    override func updateChart(testParameters: TestParameters) {
        for entry in chartDataEntries {
            entry.x = entry.x + BrownianMotionGenerator.getRandomPoint(min: -1.0, max: 1.0)
            entry.y = entry.y + BrownianMotionGenerator.getRandomPoint(min: -0.5, max: 0.5)
        }
        
        chartDataSet.replaceEntries(chartDataEntries)
        
        // Both needed to trigger range calculations and chart redraw
        chart.data?.notifyDataChanged()
        chart.notifyDataSetChanged()
    }
}
