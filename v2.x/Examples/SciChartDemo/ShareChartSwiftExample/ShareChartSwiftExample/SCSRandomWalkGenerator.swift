//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSRandomWalkGenerator.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

class SCSRandomWalkGenerator {
    var seed: Int = 0
    private var last: Double = 0.0
    private var index: Int = 0
    private let bias: Double = 0.0
    
    func getRandomWalkSeries(_ count: Int, min: Double, max: Double, includePrior: Bool) -> [[Double]] {
        var doubleSeries = [[Double]]() /* capacity: count */
        let xData = [Double]() /* capacity: count */
        let yData = [Double]() /* capacity: count */
        doubleSeries.append(xData)
        doubleSeries.append(yData)
        index = 0
        last = 0
        seed = 0
        // Generate a slightly positive biased random walk
        // y[i] = y[i-1] + random,
        // where random is in the range min, max
        for _ in 0..<count {
            index += 1
            doubleSeries[0].append(Double(index))
            doubleSeries[1].append((next(min, max: max, includePrior: includePrior)))
        }
        return doubleSeries
    }
    
    func next(_ min: Double, max: Double, includePrior: Bool) -> Double {
        var next: Double = 0.0
        if includePrior {
            next = last + (SCSDataManager.randomize(min, max: max) + bias)
        }
        else {
            next = (SCSDataManager.randomize(min, max: max) + bias)
        }
        last = next
        return next
    }
    
}
