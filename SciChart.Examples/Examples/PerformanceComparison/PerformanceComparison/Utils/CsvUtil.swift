// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CsvUtil.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit

enum MeasuredMetrics: String, CaseIterable {
    case fps = "FPS"
    case cpuUsage = "CPU"
    case memoryUsed = "RAM"
    case startUpTime = "StartUp"
    
    func getMetricValue(speedTestResult: SpeedTestResult) -> String {
        switch self {
        case .fps:
            return speedTestResult.fps.format(f: 2)
        case .cpuUsage:
            return speedTestResult.cpuUsage.format(f: 2)
        case .memoryUsed:
            return speedTestResult.memoryUsed.format()
        case .startUpTime:
            return speedTestResult.startUpTime.format()
        }
    }
}

class CsvUtil: NSObject {
    
    static func exportToCsv(testResults: [SpeedTestResult], metricsToExport: [MeasuredMetrics]) -> String {
        var resultCsv = [String]()
        
        // Headers preparation
        var headers = ["TestCase Name"]
        for metric in metricsToExport {
            for chartProvider in ChartProviderType.allCases {
                for chartProviderParams in chartProvider.getParameters().sorted(by: { $0.description < $1.description }) {
                    headers.append("\(chartProvider.rawValue) [\(metric.rawValue)] \(chartProviderParams)")
                }
            }
        }
        resultCsv.append(headers.joined(separator: ","))
        
        // Actual tests results preparation
        let resultNames = testResults.map({ result -> String in return result.testName })
        for testName in resultNames.distinct() {
            var rawData = [testName]

            for metric in metricsToExport {
                // Get collection of `testName` results for every Provider and it's parameters
                let providerTests = testResults.filter({ result -> Bool in return result.testName == testName })
                let sortedTests = providerTests.sorted(by: { $0.chartProviderParameters.description < $1.chartProviderParameters.description })
                for test in sortedTests {
                    rawData.append(metric.getMetricValue(speedTestResult: test))
                }
            }
            
            resultCsv.append(rawData.joined(separator: ","))
        }
        
        return resultCsv.joined(separator: "\n")
    }
}
