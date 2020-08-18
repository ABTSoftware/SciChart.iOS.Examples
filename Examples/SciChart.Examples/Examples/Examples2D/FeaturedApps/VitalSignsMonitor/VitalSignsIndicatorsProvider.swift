//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// VitalSignsIndicatorsProvider.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

class VitalSignsIndicatorsProvider {
    private let timeFormat = "HH:mm"
    
    private let BPM_VALUES = ["67", "69", "72", "74"]
    private let BP_VALUES = ["120/70", "115/70", "115/75", "120/75"]
    private let BPB_VALUES = [5, 6, 7]
    private let BV_VALUES = ["13.1", "13.2", "13.3", "13.0"]
    private let BVB_VALUES = [9, 10, 11]
    private let BO_VALUES = ["93", "95", "96", "97"]
    
    var bpmValue = ""
    var bpValue = ""
    var bpbValue = 0
    var bvValue = ""
    var bvBar1Value = 0
    var bvBar2Value = 0
    var spoValue = ""
    var spoClockValue = ""
    
    func update() {
        bpmValue = randomString(BPM_VALUES)
        bpValue = randomString(BP_VALUES)
        bpbValue = randomInt(BPB_VALUES)
        bvValue = randomString(BV_VALUES)
        bvBar1Value = randomInt(BVB_VALUES)
        bvBar2Value = randomInt(BVB_VALUES)
        spoValue = randomString(BO_VALUES)
        spoClockValue = getTimeString()
    }
    
    private func randomString(_ values: [String]) -> String {
        return randomElement(values) ?? ""
    }
    
    private func randomInt(_ values: [Int]) -> Int {
        return randomElement(values) ?? 0
    }
    
    private func randomElement<T>(_ values: [T]) -> T? {
        return values.randomElement()
    }
    
    private func getTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = timeFormat
        return dateFormatter.string(from: Date())
    }
}
