//
//  SCSMultipleSurfaceChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSSyncMultiChartView: UIView {
    
    let axisY1Id = "Y1"
    let axisX1Id = "X1"
    
    let axisY2Id = "Y2"
    let axisX2Id = "X2"
    
    let sciChartView1 = SCIChartSurface()
    let sciChartView2 = SCIChartSurface()
    
    let rangeSync = SCIAxisRangeSynchronization()
    let sizeAxisAreaSync = SCIAxisAreaSizeSynchronization()
    let rolloverModifierSync = SCIMultiSurfaceModifier(modifierType: SCIRolloverModifier.self)
    let pinchZoomModifierSync = SCIMultiSurfaceModifier(modifierType: SCIPinchZoomModifier.self)
    let yDragModifierSync = SCIMultiSurfaceModifier(modifierType: SCIYAxisDragModifier.self)
    let xDragModifierSync = SCIMultiSurfaceModifier(modifierType: SCIXAxisDragModifier.self)
    let zoomExtendsSync = SCIMultiSurfaceModifier(modifierType: SCIZoomExtentsModifier.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    // MARK: Overrided Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        completeConfiguration()
    }
    
    // MARK: Internal Functions
    
    func completeConfiguration() {
        configureChartSuraface()
        addAxis()
        addModifiers()
        
        addDataSeries(surface: sciChartView1, xID: axisX1Id, yID: axisY1Id)
        addDataSeries(surface: sciChartView2, xID: axisX2Id, yID: axisY2Id)
        
    }
    
    // MARK: Private Functions
    
    fileprivate func configureChartSuraface() {
        
        sciChartView1.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView1)
        
        sciChartView2.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView2)
        
        let layoutDictionary = ["SciChart1" : sciChartView1, "SciChart2" : sciChartView2]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart1]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart2]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[SciChart1(SciChart2)]-(0)-[SciChart2(SciChart1)]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
    }
    
    
    fileprivate func addAxis() {
        
        let axisX1 = SCINumericAxis()
        axisX1.axisId = axisX1Id
        rangeSync.attachAxis(axisX1)
        sciChartView1.xAxes.add(axisX1)
        
        let axisY1 = SCINumericAxis()
        axisY1.axisId = axisY1Id
        sciChartView1.yAxes.add(axisY1)
        
        let axisX2 = SCINumericAxis()
        axisX2.axisId = axisX2Id
        rangeSync.attachAxis(axisX2)
        sciChartView2.xAxes.add(axisX2)
        
        let axisY2 = SCINumericAxis()
        axisY2.axisId = axisY2Id
        sciChartView2.yAxes.add(axisY2)
    }
    
    fileprivate func addModifiers() {
        
        sizeAxisAreaSync.syncMode = .right
        sizeAxisAreaSync.attachSurface(sciChartView1)
        sizeAxisAreaSync.attachSurface(sciChartView2)
        
        var yDragModifier = yDragModifierSync.modifier(forSurface: sciChartView1) as? SCIYAxisDragModifier
            yDragModifier?.axisId = axisY1Id
            yDragModifier?.dragMode = .pan;
        
        var xDragModifier = xDragModifierSync.modifier(forSurface: sciChartView1) as? SCIXAxisDragModifier
        xDragModifier?.axisId = axisX1Id
        xDragModifier?.dragMode = .pan;
        
        var modifierGroup = SCIChartModifierCollection(childModifiers: [rolloverModifierSync, yDragModifierSync, pinchZoomModifierSync, zoomExtendsSync, xDragModifierSync])
        sciChartView1.chartModifiers = modifierGroup
        
        yDragModifier = yDragModifierSync.modifier(forSurface: sciChartView2) as? SCIYAxisDragModifier
        yDragModifier?.axisId = axisY2Id
        yDragModifier?.dragMode = .pan;
        
        xDragModifier = xDragModifierSync.modifier(forSurface: sciChartView2) as? SCIXAxisDragModifier
        xDragModifier?.axisId = axisX2Id
        xDragModifier?.dragMode = .pan;
        
        modifierGroup = SCIChartModifierCollection(childModifiers: [rolloverModifierSync, yDragModifierSync, pinchZoomModifierSync, zoomExtendsSync, xDragModifierSync])
        sciChartView2.chartModifiers = modifierGroup
    }
    
    fileprivate func addDataSeries(surface:SCIChartSurface, xID:String, yID:String) {
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        
        for i in 0..<500{
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric( 500.0 * sin(Double(i)*Double.pi*0.1)/Double(i)))
        }
        
        let renderableDataSeries = SCIFastLineRenderableSeries()
        renderableDataSeries.strokeStyle = SCISolidPenStyle(color: UIColor.green, withThickness: 1.0)
        renderableDataSeries.xAxisId = xID
        renderableDataSeries.yAxisId = yID
        renderableDataSeries.dataSeries = dataSeries
        
        let animation = SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        renderableDataSeries.addAnimation(animation)
        
        surface.renderableSeries.add(renderableDataSeries)
    }
    
}
