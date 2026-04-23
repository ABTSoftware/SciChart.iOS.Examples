// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// NxMSeriesSpeedTestSciChart.swift is part of the SCICHART® PerformanceComparison.
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

class NxMSeriesSpeedTestSciChart: SciChartSpeedTestBase {
    private let randomWalkGenerator = RandomWalkGenerator()
    
    private var updateNumber = 0
    private var rangeMin = Double.nan
    private var rangeMax = Double.nan
    
    override func initChart(testParameters: TestParameters) {
        rangeMin = Double.nan
        rangeMax = Double.nan
        
        let xBuffer = SCIDoubleValues(capacity: testParameters.pointCount)
        let yBuffer = SCIDoubleValues(capacity: testParameters.pointCount)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(SCINumericAxis())
            self.surface.yAxes.add(SCINumericAxis())
            
            for _ in 0..<testParameters.seriesNumber {
                self.dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
                
                xBuffer.clear()
                yBuffer.clear()
                self.randomWalkGenerator.reset()
                let randomWalkData = self.randomWalkGenerator.getRandomWalkSeries(count: testParameters.pointCount, min: -0.5, max: 0.5, includePrior: true)
                for i in 0 ..< randomWalkData.count {
                    xBuffer.add(randomWalkData[i].x)
                    yBuffer.add(randomWalkData[i].y)
                }
                self.dataSeries.append(x: xBuffer, y: yBuffer)
                
                let rSeries = SCIFastLineRenderableSeries()
                rSeries.strokeStyle = SCISolidPenStyle(color: UIColor.random, thickness: testParameters.strokeThikness)
                rSeries.dataSeries = self.dataSeries
                rSeries.resamplingMode = super.resamplingMode
                
                self.surface.renderableSeries.add(rSeries)
            }
        }
        
        surface.zoomExtents()
    }
    
    override func updateChart(testParameters: TestParameters) {
        let yAxis = surface.yAxes[0]
        if (rangeMin.isNaN) {
            rangeMin = yAxis.visibleRange.minAsDouble
            rangeMax = yAxis.visibleRange.maxAsDouble
        }
        let scaleFactor = fabs(sin(Double(updateNumber) * 0.1)) + 0.5;
        yAxis.visibleRange = SCIDoubleRange(min: rangeMin * scaleFactor, max: rangeMax * scaleFactor)

        updateNumber += 1
    }
}
