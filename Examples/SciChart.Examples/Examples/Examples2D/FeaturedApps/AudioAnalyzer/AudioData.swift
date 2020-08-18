//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AudioData.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

struct AudioData {
    let pointsCount: Int
    let xData: SCILongValues
    let yData: SCIIntegerValues
    let fftData: SCIFloatValues
    
    init(pointsCount: Int) {
        self.pointsCount = pointsCount
        self.xData = SCILongValues(capacity: pointsCount)
        self.yData = SCIIntegerValues(capacity: pointsCount)
        self.fftData = SCIFloatValues(capacity: pointsCount)
    }
}
