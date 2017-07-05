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
    override func formatLabel(_ dataValue: SCIGenericType) -> Swift.String! {
        return super.formatLabel(SCIGeneric(SCIGenericDouble(dataValue) / 1000)) + "k"
    }
}

class BillionsLabelProvider: SCINumericLabelProvider {
    override func formatLabel(_ dataValue: SCIGenericType) -> Swift.String! {
        return super.formatLabel(SCIGeneric(SCIGenericDouble(dataValue) / pow(10, 9))) + "B"
    }
}
