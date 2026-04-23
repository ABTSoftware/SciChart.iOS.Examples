// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RandomWalkGenerator.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit

class RandomWalkGenerator: NSObject {
    private let bias: Double = 0.01
    private var last: Double = 0.0
    private var seed: UInt = 0
    
    func getRandomWalkSeries(count: Int, min: Double, max: Double, includePrior: Bool = false) -> [DataPoint] {
        var result = [DataPoint]()
        
        // Generate a slightly positive biased random walk
        // y[i] = y[i-1] + random, where random is in the range min, max
        for i in 0..<count {
            result.append(DataPoint(x: Double(i), y: next(min: min, max: max, includePrior: includePrior)))
        }
        
        return result
    }
    
    func next(min: Double, max: Double, includePrior: Bool = false) -> Double {
        var next = Double.random(in: min..<max) + self.bias
        if (includePrior) {
            next += last
        }
        self.last = next
        
        return next
    }
    
    func reset() {
        last = 0.0
        seed = 0
    }
}
