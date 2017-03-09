//
//  SCSBaseChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/1/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSBaseChartView: SCIChartSurfaceView, SCSChartViewProtocol {
    var chartSurface: SCIChartSurface!
    
    var axisXId = "xAxis"
    var axisYId = "yAxis"
    let extendZoomModifierName = "ZoomExtentsModifier"
    let pinchZoomModifierName = "PinchZoomModifier"
    let rolloverModifierName = "RolloverModifier"
    let xAxisDragModifierName = "xAxisDragModifierName"
    let yAxisDragModifierName = "yAxisDragModifierName"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Overrided Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        completeConfiguration()
    }
    
    // MARK: Private Functions
    
    fileprivate func configureChartSuraface() {
        chartSurface = SCIChartSurface.init(view: self)
        chartSurface.style.backgroundBrush = SCIBrushSolid(colorCode: SCSColorsHEX.backgroundBrush)
        chartSurface.style.seriesBackgroundBrush = SCIBrushSolid(colorCode: SCSColorsHEX.seriesBackgroundBrush)
        chartSurface.chartTitle = "Chart Title"
    }
    
    // MARK: Internal Functions
    
    func completeConfiguration() {
        configureChartSuraface()
    }
    
    func generateDefaultAxisStyle() -> SCIAxisStyle {
        let axisStyle = SCIAxisStyle()
        
        let majorPen = SCIPenSolid(colorCode: SCSColorsHEX.majorPen, width: 0.5)
        let minorPen = SCIPenSolid(colorCode: SCSColorsHEX.minorPen, width: 0.5)
        
        let textFormat = SCITextFormattingStyle()
        textFormat.fontName = SCSFontsName.defaultFontName
        textFormat.fontSize = SCSFontSizes.defaultFontSize
        
        axisStyle.majorTickBrush = majorPen
        axisStyle.majorGridLineBrush = majorPen
        axisStyle.gridBandBrush = SCIBrushSolid.init(colorCode: SCSColorsHEX.gridBandPen)
        axisStyle.minorTickBrush = minorPen
        axisStyle.minorGridLineBrush = minorPen
        axisStyle.labelStyle = textFormat
        
        return axisStyle
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.modifierName = xAxisDragModifierName
        xAxisDragmodifier.axisId = axisXId
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.modifierName = yAxisDragModifierName
        yAxisDragmodifier.axisId = axisYId
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        extendZoomModifier.modifierName = extendZoomModifierName
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        pinchZoomModifier.modifierName = pinchZoomModifierName
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.modifierName = rolloverModifierName
        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        
        let groupModifier = SCIModifierGroup(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        chartSurface.chartModifier = groupModifier
    }
    
}
