//
//  FFTPaletteProvider.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 4/25/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

class FFTPaletteProvider: SCIPaletteProvider {
    var styleArray : [SCIColumnSeriesStyle]! = []
    var coordinateCalculator: SCICoordinateCalculatorProtocol
    
    init(with calculator: SCICoordinateCalculatorProtocol) {
        coordinateCalculator = calculator
        super.init()
        createGradientArray()
    }
    
    func createGradientArray() {
        let fadeOutStyle : SCIColumnSeriesStyle! = SCIColumnSeriesStyle()
        fadeOutStyle.dataPointWidth = 0.0
        for i in 0..<256 {
            let color = UIColor.init(red: (CGFloat(i)/1.5)/255.0, green: CGFloat(i)/255.0, blue: 1.0 - CGFloat(i)/255.0, alpha: 1.0)
            fadeOutStyle.fillBrushStyle = SCISolidBrushStyle(color: color)
            fadeOutStyle.strokeStyle = SCISolidPenStyle(color: color, withThickness: 1.0)
            styleArray.append(fadeOutStyle.copy() as! SCIColumnSeriesStyle)
        }
  
    }
    
    override func updateData(_ data: SCIRenderPassDataProtocol!) {
        coordinateCalculator = data.yCoordinateCalculator()
    }
    
    override func styleFor(x: Double, y: Double, index: Int32) -> SCIStyleProtocol! {
        if y.isInfinite || y.isNaN {
            return nil;
        }
        
        var brushIndex = Int(coordinateCalculator.getDataValue(from: y) * 3.64)
        if (brushIndex > 255) {
            brushIndex = 255
        } else if (brushIndex < 0) {
            brushIndex = 0
        }
        return styleArray[brushIndex]
    }
    
    
}
