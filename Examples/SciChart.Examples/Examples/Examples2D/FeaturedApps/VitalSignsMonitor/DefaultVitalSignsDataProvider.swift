//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DefaultVitalSignsDataProvider.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

class DefaultVitalSignsDataProvider: DataProviderBase<VitalSignsData> {
    // 1. Heart rate or pulse rate (ECG HR)
    // 2. Blood Pressure (NI BP)
    // 3. Blood Volume (SV ml)
    // 4. Blood Oxygenation (SPo2)
    
    let SAMPLE_RATE: Double = 800
    let ECG_TRACES = "EcgTraces.csv"
    
    private var currentIndex = 0
    private var totalIndex = 0
    private var isATrace = false
    
    let xValues = SCIDoubleValues()
    let ecgHeartRate = SCIDoubleValues()
    let bloodPressure = SCIDoubleValues()
    let bloodVolume = SCIDoubleValues()
    let bloodOxygenation = SCIDoubleValues()
    
    init() {
        super.init(dispatchTimeInterval: .microseconds(1000))
        
        do {
            let rawData = try String.init(contentsOfFile: SCDDataManager.getBundleFilePath(from: ECG_TRACES), encoding: .utf8)
            let lines = rawData.components(separatedBy: "\n")
            for i in 0 ..< lines.count - 1 {
                let split = lines[i].components(separatedBy: ",") as [NSString]
                
                xValues.add(split[0].doubleValue)
                ecgHeartRate.add(split[1].doubleValue)
                bloodPressure.add(split[2].doubleValue)
                bloodVolume.add(split[3].doubleValue)
                bloodOxygenation.add(split[4].doubleValue)
            }
        } catch {
            print("Load ECG Error: Failed to load ECG. \(error.localizedDescription)")
        }
    }
    
    override func onNext() -> VitalSignsData {
        if currentIndex >= xValues.count {
            currentIndex = 0;
        }

        let time = (Double(totalIndex) / SAMPLE_RATE).truncatingRemainder(dividingBy: 10)
        let ecgHeartRate = self.ecgHeartRate.getValueAt(currentIndex)
        let bloodPressure = self.bloodPressure.getValueAt(currentIndex)
        let bloodVolume = self.bloodVolume.getValueAt(currentIndex)
        let bloodOxygenation = self.bloodOxygenation.getValueAt(currentIndex)
        
        let data = VitalSignsData(xValue: time,
                                  ecgHeartRate: ecgHeartRate,
                                  bloodPressure: bloodPressure,
                                  bloodVolume: bloodVolume,
                                  bloodOxygenation: bloodOxygenation,
                                  isATrace: isATrace)

        currentIndex += 1
        totalIndex += 1

        if totalIndex % 8000 == 0 {
            isATrace = !isATrace
        }
        
        return data;
    }    
}

struct VitalSignsData {
    let xValue: Double
    let ecgHeartRate: Double
    let bloodPressure: Double
    let bloodVolume: Double
    let bloodOxygenation: Double
    let isATrace: Bool
}
