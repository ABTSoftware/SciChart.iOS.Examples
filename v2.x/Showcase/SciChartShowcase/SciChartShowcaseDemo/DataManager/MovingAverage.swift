//
//  MovingAverage.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 7/28/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

class MovingAverage {
    
    var current: Double = 0.0
    private var length: Int = 0
    private var circIndex: Int = -1
    private var filled: Bool = false
    private var oneOverLength = Double.nan
    private var circularBuffer: [Double]!
    private var total: Double = 0.0
    
    init(length: Int) {
        self.length = length
        oneOverLength = 1.0 / Double(length)
        circularBuffer = [Double].init(repeating: 0.0, count: length)
    }
    
    func push(_ value: Double) -> MovingAverage {
        
        circIndex += 1
        if circIndex == length {
            circIndex = 0
        }
        
        let lostValue: Double = circIndex < circularBuffer.count ? Double(circularBuffer[circIndex]) : 0.0
        circularBuffer[circIndex] = value
        total += value
        total -= lostValue
        
        if !filled && circIndex != length - 1 {
            current = Double.nan
            return self
        } else {
            filled = true
        }
        
        current = total * oneOverLength
        
        return self
    }
    
    func update(_ value: Double) {
        
        let lostValue: Double = Double(circularBuffer[circIndex])
        
        circularBuffer[circIndex] = (value)
        
        // Maintain totals for Push function
        total += value
        total -= lostValue
        
        // If not yet filled, just return. Current value should be double.NaN
        if !filled {
            current = Double.nan
            return
        }
        
        // Compute the average
        var average: Double = 0.0
        for i in 0..<circularBuffer.count {
            average += Double(circularBuffer[i])
        }
        
        current = average * oneOverLength
        
    }
}
