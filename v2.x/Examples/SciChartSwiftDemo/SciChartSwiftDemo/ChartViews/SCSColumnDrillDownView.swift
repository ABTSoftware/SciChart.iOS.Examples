//
//  SCSCollumnDrillDownView.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 9/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

// MARK: Custom modifier

class ColumnHitTest: SCIGestureModifier {
    var tapedAtIndex : SCIActionBlock_Pint! = nil
    var doubleTaped : SCIActionBlock! = nil
    
    var location = CGPoint.zero  // position of tap gesture
    var index : Int32 = 0
    
    override init() {
        super.init()
    }
    
    override func onTapGesture (_ gesture: UITapGestureRecognizer!, at view: UIView!) -> Bool {
        let location : CGPoint = gesture.location(in: view)
        let rs : SCIRenderSurfaceProtocol = self.parentSurface.renderSurface!
        if (!rs.isPoint(withinBounds: location)) { return false }
        if (gesture.state == .ended) {
            // save location of touch
            self.location = location
            let parent : SCIChartSurfaceProtocol = self.parentSurface
            let series : SCIRenderableSeriesCollection = parent.renderableSeries as SCIRenderableSeriesCollection
            let surface : SCIRenderSurfaceProtocol = parent.renderSurface!
            let actualLocation : CGPoint = surface.point(inChartFrame: location)
            let count : Int32 = series.count()
            // check every renderable series for hit
            for i in 0..<count {
                let rSeries : SCIRenderableSeriesProtocol = series.item(at:UInt32(i))!
                let data : SCIRenderPassDataProtocol = rSeries.currentRenderPassData
                let hitTest : SCIHitTestProviderProtocol = rSeries.hitTestProvider() // get hit test tools
                // hit test verticaly: check if vertical projection through touch location crosses chart
                let hitTestResult : SCIHitTestInfo = hitTest.hitTestVerticalAt(x: Double(actualLocation.x), y: Double(actualLocation.y), radius: 5, onData: data)
                if (hitTestResult.match).boolValue {
                    // if hit is registered on series
                    // get values at closest point to hit test position
                    self.index = hitTestResult.index
                    if tapedAtIndex != nil {
                        tapedAtIndex(index)
                    }
                }
            }
        }
        return true
    }
    
    override func onDoubleTapGesture (_ gesture: UITapGestureRecognizer!, at view: UIView!) -> Bool {
        let location : CGPoint = gesture.location(in: view)
        let rs : SCIRenderSurfaceProtocol = self.parentSurface.renderSurface!
        if (!rs.isPoint(withinBounds: location)) { return false }
        if doubleTaped != nil {
            doubleTaped()
        }
        return true
    }
}

// MARK: Palette provider

class ColumnDrillDownPalette: SCIPaletteProvider {
    var styles = [SCIStyleProtocol!]()
    
    override init() {
        super.init()
        self.styles = [SCIStyleProtocol!]()
    }
    
    func addStyle(_ style: SCIStyleProtocol) {
        styles.append(style)
    }
    
    override func styleFor(x: Double, y: Double, index: Int32) -> SCIStyleProtocol! {
        if (index > Int32(styles.count)) {
            return nil
        }
        return styles[Int(index)]
    }
}

// MARK: Chart surface

class SCSColumnDrillDownView: UIView {
    
    var firstData: SCIXyDataSeries! = nil
    var secondData: SCIXyDataSeries! = nil
    var thirdData: SCIXyDataSeries! = nil
    var totalData: SCIXyDataSeries! = nil
    var firstColumn: SCIFastColumnRenderableSeries! = nil
    var secondColumn: SCIFastColumnRenderableSeries! = nil
    var thirdColumn: SCIFastColumnRenderableSeries! = nil
    var totalColumn: SCIFastColumnRenderableSeries! = nil
    var _isShowingTotal = false
    
    let surface = SCIChartSurface()
    
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
    
    // MARK: Private Functions
    
        func completeConfiguration() {
        addSurface()
        addAxes()
        addDefaultModifiers()
        createData()
        initializeSurfaceRenderableSeries()
        showTotal()
    }
    
    fileprivate func addAxes() {
        let axis = SCICategoryNumericAxis()
        axis.growBy = SCIFloatRange(min: SCIGeneric(0.5), max: SCIGeneric(0.5))
        surface.xAxes.add(axis)
        surface.yAxes.add(SCINumericAxis())
    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let drillDownModifier = ColumnHitTest()
        drillDownModifier.doubleTaped = {[unowned self] () -> Void in
            self.showTotal()
        }
        drillDownModifier.tapedAtIndex = {[unowned self] (index: Int32) -> Void in
            self.showDetailedChart(index)
        }
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, drillDownModifier])
        
        surface.chartModifiers = groupModifier
    }
 
    func createData() {
        self.totalData = SCIXyDataSeries(xType: .int32, yType: .int32)
        do {
            self.firstData = SCIXyDataSeries(xType: .int32, yType: .int32)
            var total : Int32 = 0
            let count = arc4random_uniform(5) + 3
            for i in 0..<count {
                let value : Int32 = Int32(arc4random_uniform(5 + i) + 1)
                total += value
                firstData.appendX(SCIGeneric(i), y: SCIGeneric(value))
            }
            totalData.appendX(SCIGeneric(1), y: SCIGeneric(total))
        }
        do {
            self.secondData = SCIXyDataSeries(xType: .int32, yType: .int32)
            var total : Int32 = 0
            let count = arc4random_uniform(5) + 3
            for i in 0..<count {
                let value : Int32 = Int32(arc4random_uniform(5 + i) + 1)
                total += value
                secondData.appendX(SCIGeneric(i), y: SCIGeneric(value))
            }
            totalData.appendX(SCIGeneric(2), y: SCIGeneric(total))
        }
        do {
            self.thirdData = SCIXyDataSeries(xType: .int32, yType: .int32)
            var total : Int32 = 0
            let count = arc4random_uniform(5) + 3
            for i in 0..<count {
                let value : Int32 = Int32(arc4random_uniform(5 + i) + 1)
                total += value
                thirdData.appendX(SCIGeneric(i), y: SCIGeneric(value))
            }
            totalData.appendX(SCIGeneric(3), y: SCIGeneric(total))
        }
    }
    
    func initializeSurfaceRenderableSeries() {
        self.firstColumn = SCIFastColumnRenderableSeries()
        self.firstColumn.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFF00FFFF, finish: 0xA000FFFF, direction: .vertical)
        self.firstColumn.dataSeries = firstData
        self.firstColumn.strokeStyle = nil
        
        var animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.repeatable = true
        self.firstColumn.addAnimation(animation)
        
        self.secondColumn = SCIFastColumnRenderableSeries()
        self.secondColumn.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFF00FF00, finish: 0xA000FF00, direction: .vertical)
        self.secondColumn.dataSeries = secondData
        self.secondColumn.strokeStyle = nil
        
        animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.repeatable = true
        self.secondColumn.addAnimation(animation)
        
        self.thirdColumn = SCIFastColumnRenderableSeries()
        self.thirdColumn.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFFFF0000, finish: 0xA0FF0000, direction: .vertical)
        self.thirdColumn.dataSeries = thirdData
        self.thirdColumn.strokeStyle = nil
        
        animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.repeatable = true
        self.thirdColumn.addAnimation(animation)
        
        self.totalColumn = SCIFastColumnRenderableSeries()
        self.totalColumn.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFF505050, finish: 0xA550005, direction: .vertical)
        self.totalColumn.dataSeries = totalData
        self.totalColumn.strokeStyle = nil
        
        animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
        animation.start(afterDelay: 0.3)
        animation.repeatable = true
        self.totalColumn.addAnimation(animation)
        
        let palette = ColumnDrillDownPalette()
        palette.addStyle(firstColumn.style)
        palette.addStyle(secondColumn.style)
        palette.addStyle(thirdColumn.style)
        self.totalColumn.paletteProvider = palette
    }
    
    func showTotal() {
        _isShowingTotal = true
        surface.renderableSeries.clear()
        surface.renderableSeries.add(totalColumn)
        surface.viewportManager.zoomExtents()
        
    }
    
    func showDetailedChart(_ index: Int32) {
        if (!_isShowingTotal) {
            return
        }
        if index == 0 {
            self.showFirst()
        }
        else if index == 1 {
            self.showSecond()
        }
        else if index == 2 {
            self.showThird()
        }
        
    }
    
    func showFirst() {
        _isShowingTotal = false
        surface.renderableSeries.clear()
        surface.renderableSeries.add(firstColumn)
        surface.viewportManager.zoomExtents()
        
    }
    
    func showSecond() {
        _isShowingTotal = false
        surface.renderableSeries.clear()
        surface.renderableSeries.add(secondColumn)
        surface.viewportManager.zoomExtents()
        
    }
    
    func showThird() {
        _isShowingTotal = false
        surface.renderableSeries.clear()
        surface.renderableSeries.add(thirdColumn)
        surface.viewportManager.zoomExtents()
        
    }
}
