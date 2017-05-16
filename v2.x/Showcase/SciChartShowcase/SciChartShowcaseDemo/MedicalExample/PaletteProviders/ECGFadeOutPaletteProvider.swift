//
//  ECGFadeOutPaletteProvider.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 26/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SwipingChartFadeOutPalette : SCIPaletteProvider {
    
    let fadeOutStyle : SCILineSeriesStyle! = SCILineSeriesStyle()
//    var gradientArray : [SCISolidPenStyle]! = [SCISolidPenStyle]()
    var styleArray : [SCILineSeriesStyle]! = []
    
    var seriesColor : UIColor! = nil
    var stroke : Float = 0.5
    
    init(seriesColor : UIColor!, stroke: Float) {
        super.init()
        self.seriesColor = seriesColor
        self.stroke = stroke
        createGradientArray()
    }
    
    func createGradientArray() {
        let penColor : UIColor! = seriesColor
        let colorCode : UInt32 = penColor.colorABGRCode()
        let red : UInt32 = UInt32(colorCode & 0xFF)
        let green : UInt32 = UInt32((colorCode >> 8) & 0xFF)
        let blue : UInt32 = UInt32((colorCode >> 16) & 0xFF)
        for alpha : UInt32 in 0x00...0xFF {
            let colorCode : UInt32 = UInt32( (alpha << 24) | (blue << 16) | (green << 8) | red )
            let color : UIColor! = UIColor.fromABGRColorCode(colorCode)
//            gradientArray.append( SCISolidPenStyle(color: color, withThickness: stroke) )
            fadeOutStyle.strokeStyle = SCISolidPenStyle(color: color, withThickness: stroke)
            styleArray.append(fadeOutStyle.copy() as! SCILineSeriesStyle)
        }
    }
    
    override func styleFor(x: Double, y: Double, index: Int32) -> SCIStyleProtocol! {
        var brushIndex = Int(Double(index) * 0.1)
        if (brushIndex > 255) {
            return nil
        } else if (brushIndex < 0) {
            brushIndex = 0
        }
        return styleArray[brushIndex]
//        fadeOutStyle.linePen = penStyle
//        return fadeOutStyle
    }
}
