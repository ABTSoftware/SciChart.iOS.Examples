//
//  SCSDashedLineChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 5/22/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSDashedLineChartView: UIView {
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

        func completeConfiguration() {
        addSurface()
        addDefaultModifiers()
        addAxes()
        addRendrableSeries()
    }
    
    fileprivate func addAxes() {
        surface.xAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: SCIAxisStyle()))
        surface.yAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: SCIAxisStyle()))
    }
    
    fileprivate func addRendrableSeries() {
        
        var dataCount = 20
        let priceDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        //Getting Fourier dataSeries
        for i in 0 ..< dataCount {
            let time = 10.0 * Double(i) / Double(dataCount)
            let x = time
            let y = arc4random_uniform(20)
            priceDataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
        }
        
        dataCount = 1000;
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        
        //Getting Fourier dataSeries
        for  i in 0 ..< dataCount {
            let time = 10.0 * Double(i) / Double(dataCount)
            let x = time
            let y = 2.0 * sin(x)+10
            fourierDataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
        };
        
        let ellipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFFd6ffd7)
        ellipsePointMarker.height = 5.0
        ellipsePointMarker.width = 5.0
        
        let priceRenderableSeries = SCIFastLineRenderableSeries()
        priceRenderableSeries.pointMarker = ellipsePointMarker
        priceRenderableSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 1.0, andStrokeDash:[2.0, 3.0, 2.0])
        priceRenderableSeries.dataSeries = priceDataSeries

        priceRenderableSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeInOut))
        
        surface.renderableSeries.add(priceRenderableSeries)
        
        let fourierRenderableSeries = SCIFastLineRenderableSeries()
        fourierRenderableSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4c8aff, withThickness: 1.0, andStrokeDash: [50.0, 14.0, 50.0, 14.0, 50.0, 14.0, 50.0, 14.0])
        fourierRenderableSeries.dataSeries = fourierDataSeries
        
        fourierRenderableSeries.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeInOut))
        
        surface.renderableSeries.add(fourierRenderableSeries)
        
    }

}
