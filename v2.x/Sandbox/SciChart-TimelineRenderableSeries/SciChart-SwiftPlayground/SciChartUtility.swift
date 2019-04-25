import Foundation
import SciChart

struct SciChartUtility {
    private struct K {
        static let customer = ""
        static let orderId = ""
        static let licenseCount = 0
        static let isTrialLicense = true
        static let supportExpires = ""
        static let productCode = ""
        static let keyCode = ""
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
        
        SCIChartSurface.setRuntimeLicenseKey(licencingContract)
        
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
