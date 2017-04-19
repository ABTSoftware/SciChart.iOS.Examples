//
//  RandomUtil.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 19/04/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class RandomUtil: NSObject {
    static let ARC4RANDOM_MAX:Double = 0x100000000

    static func nextDouble() -> Double {
        return (Double(arc4random()) / ARC4RANDOM_MAX)
    }
    
}
