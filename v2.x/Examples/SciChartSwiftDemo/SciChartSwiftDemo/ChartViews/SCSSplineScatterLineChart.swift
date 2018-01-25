//
//  SCSSplineScatterLineChart.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 03/05/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSSplineScatterLineChart: UIView {
    
    let surface = SCIChartSurface()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.tooltipSize = CGSize(width: 200, height: CGFloat.nan)
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, rolloverModifier])
        
        surface.chartModifiers = groupModifier
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
        
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min:SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.2), max: SCIGeneric(0.2))
        
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        
        surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
        
        let originalData = SCIXyDataSeries(xType: .float, yType: .float)
        
        let doubleSeries = SCSDataManager.getSinewave(1.0, phase: 0.0, pointCount: 28, freq: 7)
        originalData.appendRangeX(doubleSeries.xValues, y: doubleSeries.yValues, count: doubleSeries.size)

        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.width = 7;
        ellipsePointMarker.height = 7;
        ellipsePointMarker.strokeStyle = SCISolidPenStyle.init(colorCode: 0xFF006400, withThickness: 1.0)
        ellipsePointMarker.fillStyle = SCISolidBrushStyle.init(colorCode: 0xFFFFFFFF)
        
        let splineRenderSeries = SplineLineRenderableSeries()
        splineRenderSeries.upSampleFactor = 10
        splineRenderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4282B4, withThickness: 1.0)
        splineRenderSeries.dataSeries = originalData
        splineRenderSeries.pointMarker = ellipsePointMarker
        surface.renderableSeries.add(splineRenderSeries)
        
        let lineRenderSeries = SCIFastLineRenderableSeries()
        lineRenderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4282B4, withThickness: 1.0)
        lineRenderSeries.dataSeries = originalData
        lineRenderSeries.pointMarker = ellipsePointMarker
        lineRenderSeries.addAnimation(SCIScaleRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        surface.renderableSeries.add(lineRenderSeries)
        
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
        
        surface.annotations = SCIAnnotationCollection.init(childAnnotations: [textAnnotation]);
    }
}

