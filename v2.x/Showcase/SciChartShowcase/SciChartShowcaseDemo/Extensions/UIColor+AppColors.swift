//
//  UIColor+AppColors.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 7/28/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

extension UIColor{
    
    class func strokeAverageLowColor() -> UIColor{
        return UIColor.fromARGBColorCode(0xFFFF3333)
    }
    
    class func strokeAverageHighColor() -> UIColor{
        return UIColor.fromARGBColorCode(0xFF33DD33)
    }
    
    static func strokeUpOhlcColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xff52cc54)
    }
    
    static func strokeDownOhlcColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xffe26565)
    }
    
    static func fillUpBrushOhlcColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xa052cc54)
    }
    
    static func fillDownBrushOhlcColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xd0e26565)
    }
    
    static func strokeRSIColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xFFC6E6FF)
    }
    
    static func strokeMcadColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xffe26565)
    }
    
    static func strokeY1McadColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xff52cc54)
    }
    
    static func filterTraderDarkColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xff1a1a1c)
    }
    
    static func filterTraderLightColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xffeeeeee)
    }
    
    static func filterTraderLightTextColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xffeeeeee)
    }
    
    static func filterTraderDarkTextColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xFF333333)
    }
    
    static func traderLightRootViewColor() -> UIColor {
        return UIColor.lightGray
    }
    
    static func traderDarkRootViewColor() -> UIColor {
        return UIColor.fromARGBColorCode(0xff34373c)
    }
    
    static func traderColumnColor() -> UIColor {
        return UIColor.fromARGBColorCode(0x999cc3ff)
    }
}
