// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// NxMSeriesSpeedTestCharts.swift is part of the SCICHART® PerformanceComparison.
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

class NxMSeriesSpeedTestCharts: ChartsSpeedTestBase {
    private let randomWalkGenerator = RandomWalkGenerator()
    
    private var updateNumber = 0
    private var rangeMin = Double.nan
    private var rangeMax = Double.nan
    
    private var leftAxis: YAxis!
    
    override func createChartView() -> ChartViewBase! {
        let chart = LineChartView()
        chart.rightAxis.enabled = false
        leftAxis = chart.leftAxis
        
        return chart
    }
    
    override func initChart(testParameters: TestParameters) {
        (chart as! LineChartView).setVisibleXRange(minXRange: 0.0, maxXRange: Double(testParameters.pointCount))
        
        var dataSets = [LineChartDataSet]()
        for _ in 0..<testParameters.seriesNumber {
            chartDataEntries = [ChartDataEntry]()
            
            randomWalkGenerator.reset()
            let randomWalkData = randomWalkGenerator.getRandomWalkSeries(count: testParameters.pointCount, min: -0.5, max: 0.5, includePrior: true)
            for i in 0..<randomWalkData.count {
                chartDataEntries.append(ChartDataEntry(x: randomWalkData[i].x, y: randomWalkData[i].y))
            }
            
            let dataSet = LineChartDataSet(entries: chartDataEntries, label: nil)
            dataSet.setColor(UIColor.random)
            dataSet.lineWidth = CGFloat(testParameters.strokeThikness)
            dataSet.drawCirclesEnabled = false

            dataSets.append(dataSet)
        }
        
        chart.data = LineChartData(dataSets: dataSets)
    }
    
    override func updateChart(testParameters: TestParameters) {
        if (rangeMin.isNaN) {
            rangeMin = leftAxis.axisMinimum
            rangeMax = leftAxis.axisMaximum
        }
        let scaleFactor = fabs(sin(Double(updateNumber) * 0.1)) + 0.5;
        
        leftAxis.axisMinimum = rangeMin * scaleFactor
        leftAxis.axisMaximum = rangeMax * scaleFactor

        chart.notifyDataSetChanged()
        updateNumber += 1
    }
}
