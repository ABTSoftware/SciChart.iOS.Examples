// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TestType.swift is part of the SCICHART® PerformanceComparison.
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

let suffixes = ["", "k", "M"]

enum TestType: String, CaseIterable {
    
    case append = "Append"
    case fifo = "Fifo"
    case NxMSeries = "NxMSeries"
    case scatter = "Scatter"
    
    static func typesToTest() -> [TestType] {
        return [.append, .fifo, .NxMSeries, .scatter]
    }
    
    func getParameters() -> [TestParameters] {
        var results = [TestParameters]()
        
        switch self {
        case .append:
            results.append(TestParameters(type: .append, strokeThikness: 1, seriesNumber: 1, pointCount: 1000, appendPoints: 100))
            results.append(TestParameters(type: .append, strokeThikness: 3, seriesNumber: 1, pointCount: 1000, appendPoints: 100))
            results.append(TestParameters(type: .append, strokeThikness: 10, seriesNumber: 1, pointCount: 1000, appendPoints: 100))
            results.append(TestParameters(type: .append, strokeThikness: 1, seriesNumber: 1, pointCount: 10000, appendPoints: 1000))
            results.append(TestParameters(type: .append, strokeThikness: 3, seriesNumber: 1, pointCount: 10000, appendPoints: 1000))
            results.append(TestParameters(type: .append, strokeThikness: 10, seriesNumber: 1, pointCount: 10000, appendPoints: 1000))
            results.append(TestParameters(type: .append, strokeThikness: 1, seriesNumber: 1, pointCount: 100000, appendPoints: 1000))
            results.append(TestParameters(type: .append, strokeThikness: 3, seriesNumber: 1, pointCount: 100000, appendPoints: 1000))
            results.append(TestParameters(type: .append, strokeThikness: 10, seriesNumber: 1, pointCount: 100000, appendPoints: 1000))
            results.append(TestParameters(type: .append, strokeThikness: 1, seriesNumber: 1, pointCount: 100000, appendPoints: 10000))
            results.append(TestParameters(type: .append, strokeThikness: 3, seriesNumber: 1, pointCount: 100000, appendPoints: 10000))
            results.append(TestParameters(type: .append, strokeThikness: 10, seriesNumber: 1, pointCount: 100000, appendPoints: 10000))
            results.append(TestParameters(type: .append, strokeThikness: 1, seriesNumber: 1, pointCount: 1000000, appendPoints: 10000))
            results.append(TestParameters(type: .append, strokeThikness: 3, seriesNumber: 1, pointCount: 1000000, appendPoints: 10000))
            results.append(TestParameters(type: .append, strokeThikness: 10, seriesNumber: 1, pointCount: 1000000, appendPoints: 10000))
        case .fifo:
            results.append(TestParameters(type: .fifo, strokeThikness: 1, seriesNumber: 1, pointCount: 1000))
            results.append(TestParameters(type: .fifo, strokeThikness: 3, seriesNumber: 1, pointCount: 1000))
            results.append(TestParameters(type: .fifo, strokeThikness: 10, seriesNumber: 1, pointCount: 1000))
            results.append(TestParameters(type: .fifo, strokeThikness: 1, seriesNumber: 1, pointCount: 5000))
            results.append(TestParameters(type: .fifo, strokeThikness: 3, seriesNumber: 1, pointCount: 5000))
            results.append(TestParameters(type: .fifo, strokeThikness: 10, seriesNumber: 1, pointCount: 5000))
            results.append(TestParameters(type: .fifo, strokeThikness: 1, seriesNumber: 1, pointCount: 10000))
            results.append(TestParameters(type: .fifo, strokeThikness: 3, seriesNumber: 1, pointCount: 10000))
            results.append(TestParameters(type: .fifo, strokeThikness: 10, seriesNumber: 1, pointCount: 10000))
            results.append(TestParameters(type: .fifo, strokeThikness: 1, seriesNumber: 1, pointCount: 25000))
            results.append(TestParameters(type: .fifo, strokeThikness: 3, seriesNumber: 1, pointCount: 25000))
            results.append(TestParameters(type: .fifo, strokeThikness: 10, seriesNumber: 1, pointCount: 25000))
            results.append(TestParameters(type: .fifo, strokeThikness: 1, seriesNumber: 1, pointCount: 100000))
            results.append(TestParameters(type: .fifo, strokeThikness: 3, seriesNumber: 1, pointCount: 100000))
            results.append(TestParameters(type: .fifo, strokeThikness: 10, seriesNumber: 1, pointCount: 100000))
            results.append(TestParameters(type: .fifo, strokeThikness: 1, seriesNumber: 1, pointCount: 500000))
            results.append(TestParameters(type: .fifo, strokeThikness: 3, seriesNumber: 1, pointCount: 500000))
            results.append(TestParameters(type: .fifo, strokeThikness: 10, seriesNumber: 1, pointCount: 500000))
            results.append(TestParameters(type: .fifo, strokeThikness: 1, seriesNumber: 1, pointCount: 1000000))
            results.append(TestParameters(type: .fifo, strokeThikness: 3, seriesNumber: 1, pointCount: 1000000))
            results.append(TestParameters(type: .fifo, strokeThikness: 10, seriesNumber: 1, pointCount: 1000000))
        case .NxMSeries:
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 1, seriesNumber: 10, pointCount: 10))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 3, seriesNumber: 10, pointCount: 10))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 10, seriesNumber: 10, pointCount: 10))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 1, seriesNumber: 25, pointCount: 25))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 3, seriesNumber: 25, pointCount: 25))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 10, seriesNumber: 25, pointCount: 25))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 1, seriesNumber: 50, pointCount: 50))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 3, seriesNumber: 50, pointCount: 50))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 10, seriesNumber: 50, pointCount: 50))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 1, seriesNumber: 100, pointCount: 100))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 3, seriesNumber: 100, pointCount: 100))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 10, seriesNumber: 100, pointCount: 100))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 1, seriesNumber: 200, pointCount: 200))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 3, seriesNumber: 200, pointCount: 200))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 10, seriesNumber: 200, pointCount: 200))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 1, seriesNumber: 500, pointCount: 500))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 3, seriesNumber: 500, pointCount: 500))
            results.append(TestParameters(type: .NxMSeries, strokeThikness: 10, seriesNumber: 500, pointCount: 500))
        case .scatter:
            results.append(TestParameters(type: .scatter, strokeThikness: 1, seriesNumber: 1, pointCount: 100))
            results.append(TestParameters(type: .scatter, strokeThikness: 1, seriesNumber: 1, pointCount: 250))
            results.append(TestParameters(type: .scatter, strokeThikness: 1, seriesNumber: 1, pointCount: 500))
            results.append(TestParameters(type: .scatter, strokeThikness: 1, seriesNumber: 1, pointCount: 1000))
            results.append(TestParameters(type: .scatter, strokeThikness: 1, seriesNumber: 1, pointCount: 5000))
            results.append(TestParameters(type: .scatter, strokeThikness: 1, seriesNumber: 1, pointCount: 10000))
            results.append(TestParameters(type: .scatter, strokeThikness: 1, seriesNumber: 1, pointCount: 25000))
            results.append(TestParameters(type: .scatter, strokeThikness: 1, seriesNumber: 1, pointCount: 50000))
            results.append(TestParameters(type: .scatter, strokeThikness: 1, seriesNumber: 1, pointCount: 100000))
        }
        
        return results
    }

    func toString(seriesNumber: Int, pointCount: Int, appendPoints: Int, strokeThikness: Float) -> String {
        switch self {
        case .append:
            return "\(self.rawValue) \(withSuffix(value: pointCount))+\(withSuffix(value: appendPoints)) strokeThickness=\(strokeThikness.clean)"
        case .fifo:
            return "\(self.rawValue.uppercased()) \(withSuffix(value: pointCount)) strokeThickness=\(strokeThikness.clean)"
        case .NxMSeries:
            return "\(withSuffix(value: seriesNumber))x\(withSuffix(value: pointCount)) strokeThickness=\(strokeThikness.clean)"
        case .scatter:
            return "\(self.rawValue) \(pointCount)"
        }
    }
    
    private func withSuffix(value: Int) -> String {
        var suffixIndex = 0
        
        var val = Double(value)
        while val >= 1000 {
            // Truncating might be implemented to have 1.5k instead of 1.515k if value = 1515
            val /= 1000
            suffixIndex += 1
        }
        
        return "\(val.clean)\(suffixes[suffixIndex])"
    }
}
