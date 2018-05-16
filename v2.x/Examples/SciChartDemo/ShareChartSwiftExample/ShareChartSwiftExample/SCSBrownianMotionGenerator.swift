//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSBrownianMotionGenerator.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

class SCSBrownianMotionGenerator: NSObject {
    
    private var xmax: Double = 0.0
    private var xmin: Double = 0.0
    private var xyData: [[Double]]!
    
    func getXyData(_ count: Int, min: Double, max: Double) -> [[Double]] {
        xmin = min
        xmax = max
        initXyData(count, min: min, max: max)
        return xyData
    }
    
    func initXyData(_ count: Int, min: Double, max: Double) {
        xyData =  [[Double]]()
        let xValues = [Double]() /* capacity: count */
        let yValues = [Double]() /* capacity: count */
        xyData.append(xValues)
        xyData.append(yValues)
        // Generate a slightly positive biased random walk
        // y[i] = y[i-1] + random,
        // where random is in the range min, max
        for i in 0..<count {
            xyData[0].append(Double(i))
            xyData[1].append(SCSDataManager.randomize(min, max: max))
        }

    }
    
    func mapX(_ v1: Double, _ v2: Double) -> Double {
        return xmin + (xmax - xmin) * v1
    }
    
    func getRandomPoints() -> Double {
        let v1: Double = SCSDataManager.randomize(0.0, max: 1.0)
        let v2: Double = SCSDataManager.randomize(0.0, max: 1.0)
        return mapX(v1, v2)
    }
    
}
