// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TestParameters.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import Foundation
import SciChart

struct TestParameters {
    let type: TestType
    let pointCount: Int
    let seriesNumber: Int
    let strokeThikness: Float
    let appendPoints: Int
    let duration: Double
    
    init(type: TestType, strokeThikness: Float, seriesNumber: Int, pointCount: Int, appendPoints: Int = 0, duration: Double = 6.0) {
        self.type = type
        self.seriesNumber = seriesNumber
        self.pointCount = pointCount
        self.appendPoints = appendPoints
        self.strokeThikness = strokeThikness
        self.duration = duration
    }
    
    func createTestCase(chartProvider: ChartProviderType, chartProviderParams: IChartProviderParameters) -> TestCase {
        return TestCase(testParameters: self, chartProvider: chartProvider, chartProviderParams: chartProviderParams)
    }
    
    var description: String {
        return type.toString(seriesNumber: seriesNumber, pointCount: pointCount, appendPoints: appendPoints, strokeThikness: strokeThikness)
    }
}
