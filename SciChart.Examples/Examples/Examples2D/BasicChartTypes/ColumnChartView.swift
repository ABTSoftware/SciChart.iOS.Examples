//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ColumnChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class ColumnsTripleColorPalette : SCIPaletteProviderBase<SCIFastColumnRenderableSeries>, ISCIFillPaletteProvider {
    
    let colors = SCIUnsignedIntegerValues()
    let desiredColors:[UInt32] = [0xFF882B91, 0xFFEC0F6C, 0xFFF48420, 0xFF50C7E0, 0xFFC52E60, 0xFF67BDAF]
    
    init() {
        super.init(renderableSeriesType: SCIFastColumnRenderableSeries.self)
    }
    
    override func update() {
        let count = renderableSeries!.currentRenderPassData.pointsCount
        colors.count = count
        
        for i in 0 ..< count {
            colors.set(desiredColors[i % 6], at: i)
        }
    }
    
    var fillColors: SCIUnsignedIntegerValues { return colors }
}

class ColumnChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let yValues = [50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60];
        for i in 0 ..< yValues.count {
            dataSeries.append(x: i, y: yValues[i])
        }
        
        let rSeries = SCIFastColumnRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.paletteProvider = ColumnsTripleColorPalette()

        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            
            SCIAnimations.wave(rSeries, duration: 2.0, andEasingFunction: SCICubicEase())
        }
    }
}
