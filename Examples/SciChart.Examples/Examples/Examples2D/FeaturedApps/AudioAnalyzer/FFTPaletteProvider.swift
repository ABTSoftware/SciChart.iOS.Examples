//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FFTPaletteProvider.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

class FFTPaletteProvider: SCIPaletteProviderBase<SCIFastColumnRenderableSeries>, ISCIFillPaletteProvider, ISCIStrokePaletteProvider {
    
    private struct Colors {
        static let minColor: UInt32 = 0xFF008000
        static let maxColor: UInt32 = 0xFFFF0000
        
        // RGB chanel values for min color
        static let minColorRed = SCIColor.red(minColor)
        static let minColorGreen = SCIColor.green(minColor)
        static let minColorBlue = SCIColor.blue(minColor)
        
        // RGB chanel values for max color
        static let maxColorRed = SCIColor.red(maxColor)
        static let maxColorGreen = SCIColor.green(maxColor)
        static let maxColorBlue = SCIColor.blue(maxColor)

        static let diffRed = Int(maxColorRed) - Int(minColorRed)
        static let diffGreen = Int(maxColorGreen) - Int(minColorGreen)
        static let diffBlue = Int(maxColorBlue) - Int(minColorBlue)
    }
    
    private let colors = SCIUnsignedIntegerValues()
    var fillColors: SCIUnsignedIntegerValues { return colors }
    var strokeColors: SCIUnsignedIntegerValues { return colors }
    
    init() {
        super.init(renderableSeriesType: SCIFastColumnRenderableSeries.self)
    }
    
    override func update() {
        let xyRenderPassData = renderableSeries!.currentRenderPassData as! SCIXyRenderPassData
        let yCalc = xyRenderPassData.yCoordinateCalculator!
        let min: Double = 0
        let max: Double = yCalc.maxAsDouble
        let diff = max - min
        
        let yValues = xyRenderPassData.yValues
        let size = xyRenderPassData.pointsCount
        colors.count = size
        
        for i in 0 ..< size {
            let yValue = yValues.getValueAt(i)
            let fraction = (yValue - min) / diff
            
            let red = lerp(Colors.minColorRed, Colors.diffRed, fraction)
            let green = lerp(Colors.minColorGreen, Colors.diffGreen, fraction)
            let blue = lerp(Colors.minColorBlue, Colors.diffBlue, fraction)
            
            let color = SCIColor(red: red, green: green, blue: blue, alpha: 1)
            colors.set(color.colorARGBCode(), at: i)
        }
    }
    
    private func lerp(_ minColor: UInt8, _ diffColor: Int, _ fraction: Double) -> CGFloat {
        let interpolatedValue = Double(minColor) + fraction * Double(diffColor)
        return interpolatedValue < 0 ? 0 : interpolatedValue > 255 ? 1 : CGFloat(interpolatedValue / 255)
    }
}
