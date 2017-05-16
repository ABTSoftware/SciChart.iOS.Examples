//
//  SCSSplineScatterLineChart.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 03/05/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSSplineScatterLineChart: SCSBaseChartView {
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min:SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.2), max: SCIGeneric(0.2))
        
        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(yAxis)
        
        chartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
        
        let originalData = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        
        let doubleSeries = SCSDataManager.getSinewave(1.0, phase: 0.0, pointCount: 28, freq: 7)
        originalData.appendRangeX(doubleSeries.xValues, y: doubleSeries.yValues, count: doubleSeries.size)

        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.width = 7;
        ellipsePointMarker.height = 7;
        ellipsePointMarker.strokeStyle = SCISolidPenStyle.init(colorCode: 0xFF006400, withThickness: 1.0)
        ellipsePointMarker.fillStyle = SCISolidBrushStyle.init(colorCode: 0xFFFFFFFF)
        
        let lineRenderSeries = SplineLineRenderableSeries()
        lineRenderSeries.upSampleFactor = 10
        lineRenderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4282B4, withThickness: 1.0)
        lineRenderSeries.dataSeries = originalData
        lineRenderSeries.pointMarker = ellipsePointMarker
        chartSurface.renderableSeries.add(lineRenderSeries)
        
        let textStyle = SCITextFormattingStyle()
        textStyle.fontSize = 24
        let textAnnotation = SCITextAnnotation()
        textAnnotation.coordinateMode = .relative;
        textAnnotation.x1 = SCIGeneric(0.5);
        textAnnotation.y1 = SCIGeneric(0.01);
        textAnnotation.horizontalAnchorPoint = .center;
        textAnnotation.verticalAnchorPoint = .top;
        textAnnotation.style.textStyle = textStyle;
        textAnnotation.text = "Custom Spline Chart";
        textAnnotation.style.textColor = UIColor.white
        textAnnotation.style.backgroundColor = UIColor.clear
        
        chartSurface.annotationCollection = SCIAnnotationCollection.init(childAnnotations: [textAnnotation]);
    }
}

