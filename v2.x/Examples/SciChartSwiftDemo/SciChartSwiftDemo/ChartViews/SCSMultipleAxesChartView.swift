//
//  SCSMultipleAxesChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSMultipleAxesChartView: SCSBaseChartView {
    
    let axisX2Id = "axisX2Id"
    let axisY2Id = "axisY2Id"
    
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addSeries()
        addDefaultModifiers()
    }
    
    override func addDefaultModifiers() {
        super.addDefaultModifiers()
        addAditionalModifiers()
    }
    
    // MARK: Private Functions
    
    fileprivate func addAditionalModifiers() {
        
        let x2Pinch = SCIAxisPinchZoomModifier()
        x2Pinch.axisId = axisX2Id
        
        let x2Drag = SCIXAxisDragModifier()
        x2Drag.axisId = axisX2Id
        x2Drag.dragMode = .scale
        x2Drag.clipModeX = .none
        
        let y2Pinch = SCIAxisPinchZoomModifier()
        y2Pinch.axisId = axisY2Id
        
        let y2Drag = SCIYAxisDragModifier()
        y2Drag.axisId = axisY2Id
        y2Drag.dragMode = .pan
        
        let panZoom = SCIZoomPanModifier()
        
//        if let gm = chartSurface.chartModifier as? SCIModifierGroup  {
//            
//            gm.removeItem(gm.item(byName: rolloverModifierName))
//            gm.addItem(x2Drag)
//            gm.addItem(x2Pinch)
//            gm.addItem(y2Drag)
//            gm.addItem(y2Pinch)
//            gm.addItem(panZoom)
//        }
        
        
    }
    
    fileprivate func addAxes() {
        chartSurface.xAxes.add(SCINumericAxis())
        chartSurface.yAxes.add(SCINumericAxis())
        addDefaultModifiers()
        
        let xAxis2 = SCINumericAxis()
        xAxis2.axisId = axisX2Id
        chartSurface.xAxes.add(xAxis2)
        let yAxis2 = SCINumericAxis()
        yAxis2.axisId = axisY2Id
        chartSurface.yAxes.add(yAxis2)
        addDefaultModifiers()
        
    }
    
    fileprivate func addSeries() {
        
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.putDataInto(dataSeries)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.putDataInto(fourierDataSeries)
        fourierDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFFd7ffd6)
        ellipsePointMarker.height = 5
        ellipsePointMarker.width = 5
        
        let priceRenderableSeries = SCIFastLineRenderableSeries()
        priceRenderableSeries.style.pointMarker = ellipsePointMarker
        priceRenderableSeries.style.drawPointMarkers = true
        priceRenderableSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 0.7)
        priceRenderableSeries.dataSeries = dataSeries
        chartSurface.renderableSeries.add(priceRenderableSeries)
        
        let fourierRenderableSeries = SCIFastLineRenderableSeries()
        fourierRenderableSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFFff8a4c, withThickness: 0.7)
        fourierRenderableSeries.xAxisId = axisX2Id
        fourierRenderableSeries.yAxisId = axisY2Id
        fourierRenderableSeries.dataSeries = fourierDataSeries
        chartSurface.renderableSeries.add(fourierRenderableSeries)
        
        chartSurface.invalidateElement()
        
    }
    
}
