//
//  SCSThemeCustomChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 12/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSThemeCustomChartView: UIView {
    
    var dataSource : [SCSMultiPaneItem]!
    let surface = SCIChartSurface()
    let SCIChart_BerryBlueStyleKey = "SciChart_BerryBlue"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }

    // MARK: initialize surface
    fileprivate func addSurface() {
        surface.translatesAutoresizingMaskIntoConstraints = true
        surface.frame = bounds
        surface.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(surface)
    }
    
    // MARK: Overrided Functions
    
    func completeConfiguration() {
        addSurface()

        let axisStyle = SCIAxisStyle()
        axisStyle.drawMajorTicks = false
        axisStyle.drawMinorTicks = false

        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(150), max: SCIGeneric(180))

        let yRightAxis = SCINumericAxis()
        yRightAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yRightAxis.axisAlignment = .right
        yRightAxis.autoRange = .always
        yRightAxis.axisId = "PrimaryAxisId"
        yRightAxis.style = axisStyle
        yRightAxis.labelProvider = ThousandsLabelProvider()

        let yLeftAxis = SCINumericAxis()
        yLeftAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(3))
        yLeftAxis.axisAlignment = .left;
        yLeftAxis.autoRange = .always;
        yLeftAxis.axisId = "SecondaryAxisId";
        yLeftAxis.style = axisStyle;
        yLeftAxis.labelProvider = BillionsLabelProvider()

        let mountainDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        mountainDataSeries.seriesName = "Mountain Series"
        let lineDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        lineDataSeries.seriesName = "Line Series"
        let columnDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        columnDataSeries.seriesName = "Column Series"
        let candlestickDataSeries = SCIOhlcDataSeries(xType: .float, yType: .float)
        candlestickDataSeries.seriesName = "Candlestick Series"

        let averageHigh = SCSMovingAverage(length: 50)

        let dataSource = SCSDataManager.loadThemeData()
        for i in 0..<dataSource.count {
            let item = dataSource[i]

            let xValue = SCIGeneric(i)
            let open = SCIGeneric(item.open)
            let high = SCIGeneric(item.high)
            let low = SCIGeneric(item.low)
            let close = SCIGeneric(item.close)

            mountainDataSeries.appendX(xValue, y: SCIGeneric(item.close - 1000))
            lineDataSeries.appendX(xValue, y: SCIGeneric(averageHigh.push(item.close).current))
            columnDataSeries.appendX(xValue, y: SCIGeneric(item.volume))
            candlestickDataSeries.appendX(xValue, open: open, high: high, low: low, close: close)
        }

        let mountainRenderableSeries = SCIFastMountainRenderableSeries()
        mountainRenderableSeries.dataSeries = mountainDataSeries
        mountainRenderableSeries.yAxisId = "PrimaryAxisId";
        
        var animation = SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic)
        animation.start(afterDelay: 0.3)
        mountainRenderableSeries.addAnimation(animation)

        let lineRenderableSeries = SCIFastLineRenderableSeries()
        lineRenderableSeries.dataSeries = lineDataSeries
        lineRenderableSeries.yAxisId = "PrimaryAxisId";
        
        animation = SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic)
        animation.start(afterDelay: 0.3)
        lineRenderableSeries.addAnimation(animation)
        
        let columnRenderableSeries = SCIFastColumnRenderableSeries()
        columnRenderableSeries.dataSeries = columnDataSeries
        columnRenderableSeries.yAxisId = "SecondaryAxisId";
        
        animation = SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic)
        animation.start(afterDelay: 0.3)
        columnRenderableSeries.addAnimation(animation)
        
        let candlestickRenderableSeries = SCIFastCandlestickRenderableSeries()
        candlestickRenderableSeries.dataSeries = candlestickDataSeries
        candlestickRenderableSeries.yAxisId = "PrimaryAxisId";
        
        animation = SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOutElastic)
        animation.start(afterDelay: 0.3)
        candlestickRenderableSeries.addAnimation(animation)

        surface.xAxes.add(xAxis)
        surface.yAxes.add(yRightAxis)
        surface.yAxes.add(yLeftAxis)
        surface.renderableSeries.add(mountainRenderableSeries)
        surface.renderableSeries.add(lineRenderableSeries)
        surface.renderableSeries.add(columnRenderableSeries)
        surface.renderableSeries.add(candlestickRenderableSeries)

        let legendModifier = SCILegendModifier(position: [.left, .top], andOrientation: .vertical)
        legendModifier?.showCheckBoxes = false

        surface.chartModifiers = SCIChartModifierCollection.init(childModifiers: [legendModifier!, SCICursorModifier(), SCIZoomExtentsModifier()])

        SCIThemeManager.applyTheme(toThemeable: surface, withThemeKey: SCIChart_BerryBlueStyleKey)
    }
}
