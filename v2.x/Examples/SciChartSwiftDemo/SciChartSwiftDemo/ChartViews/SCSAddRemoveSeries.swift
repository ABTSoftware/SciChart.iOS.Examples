//
//  SCSAddRemoveSeries.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 26/04/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSAddRemoveSeries: UIView {
    
    private var _chartSurface = SCIChartSurface()
    private var _controlPanel: SCSAddRemoveSeriesPanel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    // MARK: Overrided Functions
    func completeConfiguration() {
        configureChartSurface()
        addAxes()
    }
    
    fileprivate func addPanel() {
        _controlPanel = Bundle.main.loadNibNamed("AddRemoveSeriesPanel",
                                                 owner: self,
                                                 options: nil)!.first as? SCSAddRemoveSeriesPanel
        
        _controlPanel?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(_controlPanel!)
        
        weak var wSelf = self
        _controlPanel?.onAddClicked = { () -> Void in wSelf!.add() }
        _controlPanel?.onRemoveClicked = { () -> Void in wSelf!.remove() }
        _controlPanel?.onClearClicked = { () -> Void in wSelf!.clear() }
    }
    
    fileprivate func configureChartSurface() {
        _chartSurface = SCIChartSurface()
        _chartSurface.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(_chartSurface)
        
        addPanel()
        
        let layoutDictionary = ["SciChart" : _chartSurface, "Panel" : _controlPanel!] as [String : Any]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[Panel(43)]-(0)-[SciChart]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[Panel]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let xAxis = SCINumericAxis()
        xAxis.visibleRange = SCIDoubleRange(min:SCIGeneric(0.0), max: SCIGeneric(150.0))
        xAxis.axisTitle = "X Axis"
        xAxis.autoRange = .always
        _chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.axisTitle = "Y Axis"
        yAxis.autoRange = .always
        _chartSurface.yAxes.add(yAxis)
    }
    
    func add(){
        let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)
        SCSDataManager.getRandomDoubleSeries(data: dataSeries, count: 150)
        
        let mountainRenderSeries = SCIFastMountainRenderableSeries()
        mountainRenderSeries.dataSeries = dataSeries
        mountainRenderSeries.areaStyle = SCISolidBrushStyle.init(color: UIColor.init(red: CGFloat(arc4random_uniform(255)), green: CGFloat(arc4random_uniform(255)), blue: CGFloat(arc4random_uniform(255)), alpha: 1.0))
        mountainRenderSeries.style.strokeStyle = SCISolidPenStyle.init(color: UIColor.init(red: CGFloat(arc4random_uniform(255)), green: CGFloat(arc4random_uniform(255)), blue: CGFloat(arc4random_uniform(255)), alpha: 1.0), withThickness: 1.0)
        _chartSurface.renderableSeries.add(mountainRenderSeries)
    }
    
    func remove(){
        if _chartSurface.renderableSeries.count()>0{
            _chartSurface.renderableSeries.remove(at: 0)
        }
    }
    
    func clear(){
        _chartSurface.renderableSeries.clear()
    }
}

