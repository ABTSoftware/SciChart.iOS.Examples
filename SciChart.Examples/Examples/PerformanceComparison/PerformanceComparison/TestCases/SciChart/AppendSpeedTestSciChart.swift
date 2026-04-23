// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AppendSpeedTestSciChart.swift is part of the SCICHART® PerformanceComparison.
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

class AppendSpeedTestSciChart: SciChartSpeedTestBase {
    private let randomWalkGenerator = RandomWalkGenerator()
    private var xCount = 0
    
    let xBuffer = SCIDoubleValues()
    let yBuffer = SCIDoubleValues()
    
    override func setUpChart(parent: UIView, testParameters: TestParameters, chartProviderParameters: IChartProviderParameters) {
        super.setUpChart(parent: parent, testParameters: testParameters, chartProviderParameters: chartProviderParameters)
        
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.strokeStyle = SCISolidPenStyle(color: UIColor.white, thickness: testParameters.strokeThikness)
        rSeries.dataSeries = dataSeries
        rSeries.resamplingMode = super.resamplingMode
        
        SCIUpdateSuspender.usingWith(self.surface!) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
        }
    }
    
    override func initChart(testParameters: TestParameters) {
        let randomWalkData = randomWalkGenerator.getRandomWalkSeries(count: testParameters.pointCount, min: -0.5, max: 0.5, includePrior: true)
        for i in 0 ..< randomWalkData.count {
            xBuffer.add(randomWalkData[i].x)
            yBuffer.add(randomWalkData[i].y)
        }
        xCount = randomWalkData.count
        
        SCIUpdateSuspender.usingWith(self.surface) {
            self.dataSeries.append(x: self.xBuffer, y: self.yBuffer)
        }
    }
    
    override func updateChart(testParameters: TestParameters) {
        xBuffer.clear()
        yBuffer.clear()
        
        for _ in 0 ..< testParameters.appendPoints {
            xBuffer.add(Double(xCount))
            yBuffer.add(randomWalkGenerator.next(min: -0.5, max: 0.5, includePrior: true))
            xCount += 1
        }
        
        SCIUpdateSuspender.usingWith(self.surface) {
            self.dataSeries.append(x: self.xBuffer, y: self.yBuffer)
        }
    }
}
