//
//  SCSRandomWalkGenerator.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 12/29/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

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
