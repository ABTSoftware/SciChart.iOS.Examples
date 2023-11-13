//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDDateAxisLabelProvider.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************
import SciChart.Protected.SCILabelProviderBase

class CustomDateAxisProvider: SCILabelProviderBase<SCIDateAxis> {
    
    init() {
        super.init(axisType: ISCIDateAxis.self)
    }
    
    func formatDate(itemDate: Date,isCommon: Bool) -> String? {
        let dateFormatter = DateFormatter()
        if isCommon {
            dateFormatter.dateFormat = "HH:mm\t"
            let itemString = dateFormatter.string(from: itemDate)
            if let commonDate = dateFormatter.date(from: itemString) {
                return dateFormatter.string(from: commonDate)
            }
        } else {
            dateFormatter.dateFormat = "MMM dd\nHH:mm"
            let itemString = dateFormatter.string(from: itemDate)
            if let zeroLastdate = dateFormatter.date(from: itemString) {
                return dateFormatter.string(from: zeroLastdate)
            }
        }
        return nil
    }
    
    override func updateTickLabels(_ formattedTickLabels: NSMutableArray, majorTicks: SCIDoubleValues)   {
        let majorTricksArray = majorTicks.itemsArray
        var formattedValue = String()
        for item in majorTricksArray {
            let itemDate =  Date(timeIntervalSince1970: item)
            if item == majorTricksArray.first  || item == majorTricksArray.last {
                formattedValue = formatDate(itemDate: itemDate, isCommon: false) ?? ""
            } else {
                formattedValue = formatDate(itemDate: itemDate, isCommon: true) ?? ""
            }
            formattedTickLabels.add(formattedValue)
        }
    }
    
}
   
