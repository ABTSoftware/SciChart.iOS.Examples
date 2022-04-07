//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// OhlcCustomPaletteProvider.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class OhlcCustomPaletteProvider: SCIPaletteProviderBase<SCIOhlcRenderableSeriesBase>, ISCIFillPaletteProvider, ISCIStrokePaletteProvider, ISCIPointMarkerPaletteProvider {
    
    let colors = SCIUnsignedIntegerValues()
    let color: UInt32
    let annotation: SCIBoxAnnotation
    
    init(color: SCIColor, annotation: SCIBoxAnnotation) {
        self.color = color.colorARGBCode()
        self.annotation = annotation
        
        super.init(renderableSeriesType: SCIOhlcRenderableSeriesBase.self)
    }
    
    override func update() {
        let rSeries = renderableSeries
        let rpd = rSeries?.currentRenderPassData as! SCIOhlcRenderPassData
        let xValues = rpd.xValues
        
        let count = rpd.pointsCount
        colors.count = count
        
        let x1: Double = annotation.getX1()
        let x2: Double = annotation.getX2()
        
        let minimum = min(x1, x2)
        let maximum = max(x1, x2)
        
        for i in 0 ..< count {
            let value = xValues.getValueAt(i)
            if (value > minimum && value < maximum) {
                colors.set(color, at: i)
            } else {
                colors.set(SCIPaletteProviderBase<SCIOhlcRenderableSeriesBase>.defaultColor, at: i)
            }
        }
    }
    
    var fillColors: SCIUnsignedIntegerValues { return colors }
    var pointMarkerColors: SCIUnsignedIntegerValues { return colors }
    var strokeColors: SCIUnsignedIntegerValues { return colors }
}
