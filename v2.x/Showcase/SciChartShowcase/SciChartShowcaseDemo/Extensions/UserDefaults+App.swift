//
//  UserDefaults+App.swift
//  SciChartShowcaseDemo
//
//  Created by Gkol on 8/22/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

fileprivate struct UserDefaultsKeys {
    static let instructedTradedExample = "isInstructedTradedExample"
}

extension UserDefaults {
    
    static func isInstructedTraderExample() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.instructedTradedExample)
    }
    
    static func setInstructedTraderExample(_ isInstructed: Bool = true) {
        UserDefaults.standard.set(isInstructed, forKey: UserDefaultsKeys.instructedTradedExample)
        UserDefaults.standard.synchronize()
    }
    
    
}
