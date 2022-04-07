//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SparkLineItemModel.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

struct SparkLineItemModel {
    let dataSeries: ISCIXyDataSeries
    let itemName: String
    var itemValue: Double = 0
    
    init(dataSeries: ISCIXyDataSeries, itemName: String) {
        self.dataSeries = dataSeries
        self.itemName = itemName
        
        if let yValues = dataSeries.yValues as? ISCIListDouble,
           let lastValue = yValues.value(at: yValues.count - 1)?.toDouble(),
           let firstValue = yValues.value(at: 0)?.toDouble() {
            
            self.itemValue = lastValue - firstValue
        }
    }
}
