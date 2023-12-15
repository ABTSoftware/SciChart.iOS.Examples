//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ChangeColumnColorChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

//MARK: - Color Palette Provider
class ColumnsPaletteProvider : SCIPaletteProviderBase<SCIFastColumnRenderableSeries>, ISCIFillPaletteProvider {
    
    let colors = SCIUnsignedIntegerValues()
    let desiredColors:[UInt32] = [0xFF21a0d8, 0xFFc43360]
    var touchedIndex: Int = -1
    
    init() {
        super.init(renderableSeriesType: SCIFastColumnRenderableSeries.self)
    }
    
    override func update() {
        let count = renderableSeries!.currentRenderPassData.pointsCount
        colors.count = count
        
        for i in 0 ..< count {
            if i == touchedIndex {
                colors.set(desiredColors[1], at: i)
            }
            else {
                colors.set(desiredColors[0], at: i)
            }
        }
    }
    
    var fillColors: SCIUnsignedIntegerValues { return colors }
}

//MARK: - Chart Initialisation
class ChangeColumnColorChartView: SCDSingleChartViewController<SCIChartSurface> {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    private let hitTestInfo = SCIHitTestInfo()
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        let yAxis = SCINumericAxis()
        yAxis.axisAlignment = .left
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let yValues = [50, 35, 61, 58, 50, 50, 40, 53, 55, 23, 45, 12, 59, 60];
        for i in 0 ..< yValues.count {
            dataSeries.append(x: i, y: yValues[i])
        }
        
        let rSeries = SCIFastColumnRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.dataPointWidth = 0.7
        rSeries.paletteProvider = ColumnsPaletteProvider()
        let customSeriesInfoProvider = CustomSeriesInfoProvider()
        customSeriesInfoProvider.delegate = self
        rSeries.seriesInfoProvider = customSeriesInfoProvider

        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            self.surface.chartModifiers.add(items: SCITooltipModifier())
        }
    }
}

extension ChangeColumnColorChartView: CustomSeriesInfoProviderDelegate {
    func getTouchDataSeriesIndex(dataSeriesIndex: Int) {
        print("Did touch => \(dataSeriesIndex)")
        let seriesCollection = surface.renderableSeries
        let rSeries = seriesCollection.firstObject
        
            if let paletteProvider = rSeries.paletteProvider as? ColumnsPaletteProvider {
                paletteProvider.touchedIndex =  dataSeriesIndex
            }
        surface.invalidateElement()
    }
}
