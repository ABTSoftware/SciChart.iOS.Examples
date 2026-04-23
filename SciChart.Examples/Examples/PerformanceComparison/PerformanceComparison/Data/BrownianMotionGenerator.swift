// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// BrownianMotionGenerator.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit

let ARC4RANDOM_MAX = 0x100000000

class BrownianMotionGenerator {

    static func getRandomData(min: Double, max: Double, count: Int) -> [DataPoint] {
        var result = [DataPoint]()
        
        for i in 0..<count {
            result.append(DataPoint(x: Double(i), y:Double.random(in: min...max)))
        }
        
        return result
    }
    
    static func getRandomPoint(min: Double, max: Double) -> Double {
        return min + (max - min) * nextDouble()
    }
    
    static func nextDouble() -> Double {
        return Double(arc4random()) / Double(ARC4RANDOM_MAX)
    }
}
