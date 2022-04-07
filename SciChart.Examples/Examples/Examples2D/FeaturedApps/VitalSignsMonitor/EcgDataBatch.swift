//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// EcgDataBatch.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

class EcgDataBatch {
    let xValues = SCIDoubleValues()
    
    let ecgHeartRateValuesA = SCIDoubleValues()
    let bloodPressureValuesA = SCIDoubleValues()
    let bloodVolumeValuesA = SCIDoubleValues()
    let bloodOxygenationA = SCIDoubleValues()
    
    let ecgHeartRateValuesB = SCIDoubleValues()
    let bloodPressureValuesB = SCIDoubleValues()
    let bloodVolumeValuesB = SCIDoubleValues()
    let bloodOxygenationB = SCIDoubleValues()
    
    var lastVitalSignsData: VitalSignsData!
    
    func updateData(_ vitalSignsDataList: [VitalSignsData]) {
        xValues.clear()
        ecgHeartRateValuesA.clear()
        ecgHeartRateValuesB.clear()
        bloodPressureValuesA.clear()
        bloodPressureValuesB.clear()
        bloodVolumeValuesA.clear()
        bloodVolumeValuesB.clear()
        bloodOxygenationA.clear()
        bloodOxygenationB.clear()
        
        let count = vitalSignsDataList.count
        for i in 0 ..< count {
            let vitalSignsData = vitalSignsDataList[i]
            xValues.add(vitalSignsData.xValue)
            
            if vitalSignsData.isATrace {
                ecgHeartRateValuesA.add(vitalSignsData.ecgHeartRate)
                bloodPressureValuesA.add(vitalSignsData.bloodPressure)
                bloodVolumeValuesA.add(vitalSignsData.bloodVolume)
                bloodOxygenationA.add(vitalSignsData.bloodOxygenation)

                ecgHeartRateValuesB.add(Double.nan)
                bloodPressureValuesB.add(Double.nan)
                bloodVolumeValuesB.add(Double.nan)
                bloodOxygenationB.add(Double.nan)
            } else {
                ecgHeartRateValuesB.add(vitalSignsData.ecgHeartRate)
                bloodPressureValuesB.add(vitalSignsData.bloodPressure)
                bloodVolumeValuesB.add(vitalSignsData.bloodVolume)
                bloodOxygenationB.add(vitalSignsData.bloodOxygenation)

                ecgHeartRateValuesA.add(Double.nan)
                bloodPressureValuesA.add(Double.nan)
                bloodVolumeValuesA.add(Double.nan)
                bloodOxygenationA.add(Double.nan)
            }
        }
        lastVitalSignsData = vitalSignsDataList[count - 1]
    }
}
