//
//  SCSLineChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 5/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class CustomRenderableSeries : SCICustomRenderableSeries {
    
    var columnWidth : Float = 20;
    var stripeSize  : Float = 5;
    var stripeSpace : Float = 2;
    var fillBrush : SCIBrush2DProtocol! = nil;
    var highlightBrush : SCIBrush2DProtocol! = nil;
    
    override init() {
        super.init();
        self.zeroLineY = 0.0;
    }
    
    override func internalDraw(withContext renderContext: SCIRenderContext2DProtocol!, withData renderPassData: SCIRenderPassDataProtocol!) {
        let points = renderPassData.pointSeries();
        let xData = points!.xValues();
        let yData = points!.yValues();
        let indexData = points!.indices();
        let zeroLine = Float(self.getYZeroCoord());
        for i in 0..<points!.count() {
            let x = renderPassData.xCoordinateCalculator().getCoordinateFrom(SCIGenericDouble(xData!.value(at:i)))
            let y = renderPassData.yCoordinateCalculator().getCoordinateFrom(SCIGenericDouble(yData!.value(at:i)))
            let brush = (SCIGenericInt(indexData!.value(at:i))) == renderPassData.dataSeries().count()-1 ? highlightBrush : fillBrush ;
            fillColumn(renderContext: renderContext, fillBrush: brush!, x: Float(x), y: Float(y), width: columnWidth, height: abs(Float(y)-zeroLine));
        }
    }
    
    func fillColumn(renderContext: SCIRenderContext2DProtocol!, fillBrush : SCIBrush2DProtocol, x : Float, y : Float, width : Float, height : Float) {
        fillBrush .setDrawingAreaX(Double(x), y: Double(y), width: Double(width), height: Double(height));
        var currentY = y + height;
        let stripeStep = stripeSize + stripeSpace;
        let halfWidth = width / 2;
        while (currentY - stripeStep > y) {
            renderContext.drawRect(withBrush: fillBrush, fromX: x - halfWidth, y: currentY, toX: x + halfWidth, y: currentY - stripeSize);
            currentY -= stripeStep;
        }
    }
}

class SCSCustomChartView: UIView {
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
        addAxes()
        addDefaultModifiers()
        addSeries()
    }
    
    // MARK: Private Functions

    private func addAxes() {
        surface.xAxes.add(SCINumericAxis())
        surface.yAxes.add(SCINumericAxis())
    }
    
    private func addSeries() {
        
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        SCSDataManager.putDataInto(dataSeries)
        
        let fourierDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        SCSDataManager.putFourierDataInto(fourierDataSeries)
        
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        fourierDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let columns = CustomRenderableSeries()
        columns.dataSeries = dataSeries
        
        columns.fillBrush = SCIBrushSolid(color: UIColor.cyan);
        columns.highlightBrush = SCIBrushLinearGradient(colorStart: UIColor.white, finish: UIColor.blue, direction: .vertical);
        surface.renderableSeries.add(columns)
        
        
        
    }
    
}
