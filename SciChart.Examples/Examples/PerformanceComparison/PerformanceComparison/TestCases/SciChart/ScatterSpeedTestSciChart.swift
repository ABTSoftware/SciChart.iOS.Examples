// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ScatterSpeedTestSciChart.swift is part of the SCICHART® PerformanceComparison.
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

class ScatterSpeedTestSciChart: SciChartSpeedTestBase {
    let xBuffer = SCIDoubleValues()
    let yBuffer = SCIDoubleValues()
    
    override func setUpChart(parent: UIView, testParameters: TestParameters, chartProviderParameters: IChartProviderParameters) {
        super.setUpChart(parent: parent, testParameters: testParameters, chartProviderParameters: chartProviderParameters)
        
        let marker = SCIEllipsePointMarker()
        marker.size = CGSize(width: 6, height: 6)
        
        let rSeries = SCIXyScatterRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.pointMarker = marker
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(SCINumericAxis())
            self.surface.yAxes.add(SCINumericAxis())
            self.surface.renderableSeries.add(rSeries)
        }
    }
    
    override func initChart(testParameters: TestParameters) {
        let brownianMotionData = BrownianMotionGenerator.getRandomData(min: -50, max: 50, count: testParameters.pointCount)
        dataSeries.acceptsUnsortedData = true
        
        xBuffer.count = testParameters.pointCount
        yBuffer.count = testParameters.pointCount
        
        for i in 0 ..< brownianMotionData.count {
            xBuffer.set(brownianMotionData[i].x, at: i)
            yBuffer.set(brownianMotionData[i].y, at: i)
        }
        
        SCIUpdateSuspender.usingWith(self.surface) {
            self.dataSeries.append(x: self.xBuffer, y: self.yBuffer)
        }
    }
    
    override func updateChart(testParameters: TestParameters) {
        for i in 0..<testParameters.pointCount {
            let xValue = xBuffer.getValueAt(i) + BrownianMotionGenerator.getRandomPoint(min: -1.0, max: 1.0)
            let yValue = yBuffer.getValueAt(i) + BrownianMotionGenerator.getRandomPoint(min: -0.5, max: 0.5)
            
            xBuffer.set(xValue, at: i)
            yBuffer.set(yValue, at: i)
        }

        SCIUpdateSuspender.usingWith(self.surface) {
            self.dataSeries.update(x: self.xBuffer, y: self.yBuffer, at: 0)
        }
    }
}
