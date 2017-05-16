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
    var initialColor:UIColor = UIColor.blue
    
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
        
        let selectionModifier = SCISeriesSelectionModifier();
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, zoomPanModifier, selectionModifier])
        
        chartSurface.chartModifiers = groupModifier
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let xAxis = SCINumericAxis()
        xAxis.axisId = "xAxis"
        xAxis.autoRange = .always
        chartSurface.xAxes.add(xAxis)
        
        let yAxisLeft = SCINumericAxis()
        yAxisLeft.axisId = "yLeftAxis"
        yAxisLeft.axisAlignment = .left
        chartSurface.yAxes.add(yAxisLeft)
        
        let yAxisRight = SCINumericAxis()
        yAxisRight.axisId = "yRightAxis"
        yAxisRight.axisAlignment = .right
        chartSurface.yAxes.add(yAxisRight)
    }
    
    func addSeries(){
        for i in 0..<80 {
            let axisAlign:SCIAxisAlignment = i%2 == 0 ? .left: .right;
            generateDataSeries(axisAlignment: axisAlign, index: i)
            
            var red:CGFloat = 0
            var green:CGFloat = 0
            var blue:CGFloat = 0
            var alpha:CGFloat = 0
            
            initialColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            let newR:CGFloat = red == 1.0 ? 1.0 : red + 0.0125;
            let newB:CGFloat = blue == 0.0 ? 0.0 : blue - 0.0125;
            
            initialColor = UIColor.init(red: newR, green: green, blue: newB, alpha: alpha)
        }

    }
    
    func generateDataSeries(axisAlignment:SCIAxisAlignment, index:(Int)){
        let lineDataSeries = SCIXyDataSeries.init(xType: .double, yType: .double, seriesType: .defaultType)
        lineDataSeries.seriesName = String(format: "Series %i", index)
        
        let gradient:Double = Double(axisAlignment == .right ? index: -index);
        let start:Double = axisAlignment == .right ? 0.0 : 14000;
        SCSDataManager.getStraightLine(series: lineDataSeries, gradient: gradient, yIntercept: start, pointCount: 50)
        
        let lineRenderableSeries = SCIFastLineRenderableSeries()
        lineRenderableSeries.dataSeries = lineDataSeries
        lineRenderableSeries.yAxisId = axisAlignment == .left ? "yLeftAxis" : "yRightAxis"
        lineRenderableSeries.xAxisId = "xAxis"
        lineRenderableSeries.strokeStyle = SCISolidPenStyle.init(color: initialColor, withThickness: 1.0)
        
        let pointMarker = SCIEllipsePointMarker();
        pointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFFFF00DC);
        pointMarker.strokeStyle = SCISolidPenStyle.init(color: UIColor.white, withThickness: 1.5)
        pointMarker.height = 10
        pointMarker.width = 10

        lineRenderableSeries.selectedStyle = lineRenderableSeries.style;
        lineRenderableSeries.selectedStyle.strokeStyle = SCISolidPenStyle(colorCode: 0xFFFF00DC, withThickness: 1.0)
        lineRenderableSeries.selectedStyle.pointMarker = pointMarker
        
        chartSurface.renderableSeries.add(lineRenderableSeries)
    }
}
