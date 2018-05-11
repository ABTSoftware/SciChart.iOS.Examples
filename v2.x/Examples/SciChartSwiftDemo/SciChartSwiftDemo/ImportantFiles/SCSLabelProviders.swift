//
//  SCSLabelProviders.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 7/5/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class ThousandsLabelProvider: SCINumericLabelProvider {
    override func formatLabel(_ dataValue: SCIGenericType) -> NSAttributedString! {
        let formattedValue = String(format: "%.1fk", SCIGenericDouble(dataValue)/1000)
        return NSMutableAttributedString(string: formattedValue)
    }
}

class BillionsLabelProvider: SCINumericLabelProvider {
    override func formatLabel(_ dataValue: SCIGenericType) -> NSAttributedString! {
        let formattedValue = String(format: "%@B", super.formatLabel(SCIGeneric(SCIGenericDouble(dataValue) / pow(10, 9))).string)
        return NSMutableAttributedString(string: formattedValue)
    }
}
