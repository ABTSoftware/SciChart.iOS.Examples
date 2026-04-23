// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SpeedTestResult.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit

struct SpeedTestResult: CustomStringConvertible {
    let testName: String
    let chartProvider: ChartProviderType
    let chartProviderParameters: IChartProviderParameters
    let fps: Double
    let cpuUsage: Double
    let memoryUsed: UInt64
    let startUpTime: TimeInterval
    
    var description: String {
        let provider = "[\(chartProvider.rawValue)]".formatR(f: 20)
        let providerParams = chartProviderParameters.description.formatL(f: 10, char: "-")
        let test = "\"\(testName)\" ".formatL(f: 38, char: "-")
        let fps = self.fps.format(f: 2)
        let cpu = cpuUsage.format(f: 1)
        let memory = memoryUsed.format()
        let startUp = startUpTime.format()
        
        return "\(provider) \(providerParams) : \(test)- [FPS = \(fps)] [CPU = \(cpu)] [RAM = \(memory)] [startUp = \(startUp)]"
    }
}
