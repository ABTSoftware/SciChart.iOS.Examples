// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FormatExtensions.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit

extension UInt64 {
    func format() -> String {
        let formatter = ByteCountFormatter()
        formatter.countStyle = .binary
        
        return formatter.string(fromByteCount: Int64(self))
    }
}

extension TimeInterval {
    func format(f: String = "s.SSS") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = f
        
        return formatter.string(from: Date.init(timeIntervalSinceReferenceDate: self))
    }
}

extension Double {
    func format(f: Int, d: Int = 5) -> String {
        return String(format: "%\(d).\(f)f", self)
    }
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Float {
    func format(f: Int, d: Int = 5) -> String {
        return String(format: "%\(d).\(f)f", self)
    }
    
    var clean: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension String {
    func formatL(f: Int, char: String = " ") -> String {
        return self.padding(toLength: f, withPad: char, startingAt: 0)
    }
    
    func formatR(f: Int) -> String {
        return "".padding(toLength: f - self.count, withPad: " ", startingAt: 0) + self
    }
}
