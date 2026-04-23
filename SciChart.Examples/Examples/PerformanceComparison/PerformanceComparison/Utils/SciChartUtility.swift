// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SciChartUtility.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import Foundation
import SciChart

struct SciChartUtility {
    private struct K {
        static let customer = "SciChart LTD"
        static let orderId = "ABTSOFT-Dev-4"
        static let licenseCount = 1
        static let isTrialLicense = false
        static let supportExpires = "04/12/2030 00:00:00"
        static let productCode = "SC-IOS-ANDROID-2D-ENTERPRISE-SRC"
        static let keyCode = """
            0cc874966f56c9fbf96b2cdd9e69ffd2f3af6ea5ac69259f174569ed16389f90a74d\
            42d090c1fc04e26969f9b8215055e090b057a8cf70737a382c38a56d0ed6e34e7978\
            4e13d67acba76ec999e6180928dc32aa4b2f8160b008e81b9b3b76cee037a80af542\
            54950026c7e852864eb52ecc0878ef0114cf05ee23ad0853306093be467bb83bac56\
            fedf48e0d44f12deb224a3ed8054fc16122c59d2d902753db127716d6dd990e862fc\
            b4f38e43948059
            """
    }
    
    static func setupLicenseKey() {
        let licencingContract = """
            <LicenseContract>
                <Customer>\(K.customer)</Customer>
                <OrderId>\(K.orderId)</OrderId>
                <LicenseCount>\(K.licenseCount)</LicenseCount>
                <IsTrialLicense>\(K.isTrialLicense)</IsTrialLicense>
                <SupportExpires>\(K.supportExpires)</SupportExpires>
                <ProductCode>\(K.productCode)</ProductCode>
                <KeyCode>\(K.keyCode)</KeyCode>
            </LicenseContract>
        """
        SCIChartSurface.setRuntimeLicenseKey("")
        
        #if DEBUG
        checkForExpiration()
        #endif
    }
    
    private static func checkForExpiration() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        
        let expireDate = dateFormatter.date(from: K.supportExpires) ?? Date()
        let firstDate = Calendar.current.startOfDay(for: expireDate)
        let secondDate = Calendar.current.startOfDay(for: Date())
        
        let calendarComponents = Calendar.current.dateComponents([.day], from: secondDate, to: firstDate)
        
        if calendarComponents.day ?? 0 < 30 {
            print("⚠️⚠️⚠️ SciChart License Key is going to expire in \(calendarComponents.day ?? 0) days ⚠️⚠️⚠️")
        } else if calendarComponents.day ?? 0 < -1 {
            print("😡😡😡 SciChart Support has ended ‼️‼️‼️")
        }
    }
}
