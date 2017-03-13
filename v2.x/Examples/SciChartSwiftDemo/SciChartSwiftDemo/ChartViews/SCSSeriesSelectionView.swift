//
//  SCSLineChartView.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 01/25/17.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSSeriesSelectionView: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxes()
        addDefaultModifiers()
        addSeries()
    }
    
    override func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let zoomPanModifier = SCIZoomPanModifier()
        zoomPanModifier.clipModeX = .none;
        
        let selectionModifier = SCISelectionModifier();
        selectionModifier.selectionMode = .multiSelectDeselectOnMiss;

        let groupModifier = SCIModifierGroup(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, zoomPanModifier, selectionModifier])
        
        chartSurface.chartModifier = groupModifier
    }
    
    // MARK: Private Functions

    fileprivate func addAxes() {
        chartSurface.xAxes.add(SCINumericAxis())
        chartSurface.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addSeries() {
        
        
        let lineDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.putDataInto(lineDataSeries)
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.drawBorder = true
        ellipsePointMarker.fillBrush = SCISolidBrushStyle(colorCode: 0xFFd7ffd6)
        ellipsePointMarker.height = 5
        ellipsePointMarker.width = 5
        
        let lineSeries = SCIFastLineRenderableSeries()
        lineSeries.dataSeries = lineDataSeries
        lineSeries.style.drawPointMarkers = false
        lineSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 1)
        lineSeries.selectedStyle = lineSeries.style;
        lineSeries.selectedStyle.linePen = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 1.5)
        lineSeries.selectedStyle.pointMarker = ellipsePointMarker
        lineSeries.selectedStyle.drawPointMarkers = true
        chartSurface.renderableSeries.add(lineSeries)
        lineSeries.hitTestProvider().hitTestMode = .interpolate
        
        let scatterDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.putDataInto(scatterDataSeries)
        
        let scatterRenderSeries = SCIXyScatterRenderableSeries()
        scatterRenderSeries.dataSeries = scatterDataSeries
        
        scatterRenderSeries.selectedStyle = scatterRenderSeries.style;
        let pointMarker = SCIEllipsePointMarker();
        pointMarker.fillBrush = SCISolidBrushStyle(colorCode: 0xFF00D0A0);
        pointMarker.drawBorder = false
        pointMarker.height = 5
        pointMarker.width = 5
        scatterRenderSeries.style.pointMarker = pointMarker
        
        let selectedPointMarker = SCIEllipsePointMarker();
        selectedPointMarker.fillBrush = SCISolidBrushStyle(colorCode: 0xFF00D0A0);
        selectedPointMarker.drawBorder = true
        selectedPointMarker.borderPen = SCISolidPenStyle(colorCode: 0xFF404040, withThickness: 0.7)
        selectedPointMarker.height = 7
        selectedPointMarker.width = 7
        scatterRenderSeries.selectedStyle.pointMarker = selectedPointMarker
        
        chartSurface.renderableSeries.add(scatterRenderSeries)
        
        chartSurface.invalidateElement()
        
    }
    
}
