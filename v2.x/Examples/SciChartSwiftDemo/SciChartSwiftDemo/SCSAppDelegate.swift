//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSAppDelegate.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit
import SciChart

@UIApplicationMain

class SCSAppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        //@BEGINDELETE
        let licensing = String.init(format: "<LicenseContract>%@%@%@%@%@%@%@</LicenseContract>",
                                            "<Customer>SciChart</Customer>",
                                            "<OrderId>ABTSOFT-Dev-1</OrderId>",
                                            "<LicenseCount>1</LicenseCount>",
                                            "<IsTrialLicense>false</IsTrialLicense>",
                                            "<SupportExpires>06/01/2018 00:00:00</SupportExpires>",
                                            "<ProductCode>SC-IOS-2D-ENTERPRISE-SRC</ProductCode>",
                                        "<KeyCode>651ac248797aad5dcb2c9e159d4665801c3d8421cbfe005e782261be491904bf0e83f013f4a631e7d81eca4c31bb54f4f864fddbcdc53251ba394a6a4ac7d9627744f889d4ead24ccf34766285bcbf3fce45342e118433ebcf308173456212e8fd0ed68853a3876d4228cccf65e80fc1c874661837d1b793cf80630efa5567db50e4d6ad13b0fa23d11f6345c60f65a0fb6caa6c750445e0077f3951aa3c5bc081497e3145</KeyCode>")
        SCIChartSurface.setRuntimeLicenseKey(licensing)
        //@ENDDELETE
        
        SCIChartSurface.setDisplayLinkRunLoopMode(.commonModes)
        
        return true
    }

}

