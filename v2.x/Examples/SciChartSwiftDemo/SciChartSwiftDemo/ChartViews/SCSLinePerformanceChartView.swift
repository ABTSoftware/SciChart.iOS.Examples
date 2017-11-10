//
//  SCSLinePerformanceChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSLinePerformanceChartView: UIView {
    
    let sciChartView = SCIChartSurface()
    var controlPanel : SCSLinePerformanceControlPanelView!
    
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

    // MARK: Private Functions
    
    func completeConfiguration() {
        configureChartSuraface()
        SCIUpdateSuspender.usingWithSuspendable(sciChartView) { [unowned self] in
            self.addAxis()
            self.addDefaultModifiers()
        }
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
        
        sciChartView.chartModifiers = groupModifier
    }
    
    fileprivate func addPanel() {
        let panel = Bundle.main.loadNibNamed("SCSLinePerformanceControlPanelView",
                                                       owner: self,
                                                       options: nil)!.first
        
        if let panelValid = panel as? SCSLinePerformanceControlPanelView {
            
            controlPanel = panelValid
            
            controlPanel.translatesAutoresizingMaskIntoConstraints = false
            
            controlPanel.clearButton.addTarget(self,
                                             action: #selector(SCSLinePerformanceChartView.clearAction),
                                             for: .touchUpInside)
            
            controlPanel.add100kButton.addTarget(self,
                                               action: #selector(SCSLinePerformanceChartView.add100k),
                                               for: .touchUpInside)
            
            controlPanel.add1mButton.addTarget(self,
                                             action: #selector(SCSLinePerformanceChartView.add1m),
                                             for: .touchUpInside)
            addSubview(controlPanel)
            
        }
    }
    
    fileprivate func configureChartSuraface() {
        
        sciChartView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView)
        
        addPanel()
        
        let layoutDictionary: [String : UIView] = ["SciChart" : sciChartView, "Panel" : controlPanel]
        
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
    
    fileprivate func addAxis() {
        sciChartView.xAxes.add(SCINumericAxis())
        sciChartView.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addSeriesWith(_ count: Int32, colorCode: UInt32) {
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .double)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        var y = Double(arc4random_uniform(100))
        
        var i: Int32 = 0
        while i < count {
            let x = SCIGeneric(i)
            let yValue = y + randomize(-5.0, max: 5.0)
            dataSeries.appendX(x, y: SCIGeneric(yValue))
            i += 1
            y = yValue;
        }
        
        let renderableSeries = SCIFastLineRenderableSeries()
        renderableSeries.strokeStyle = SCISolidPenStyle(colorCode: colorCode, withThickness: 0.5)
        renderableSeries.dataSeries = dataSeries
        
        sciChartView.renderableSeries.add(renderableSeries)

    }
    
    fileprivate func randomize(_ min: Double, max: Double) -> Double {
        return RandomUtil.nextDouble() * (max - min) + min
    }
    

    // MARK: Button Actions
    
    @objc func clearAction() {
        let series : SCIRenderableSeriesCollection! = sciChartView.renderableSeries
        for _ in 0..<series.count() {
            let item = series.item(at: 0)
            sciChartView.renderableSeries.remove(item)
        }
  
    }
    
    func randomColorCode() -> UInt32 {
        var colorCode : UInt32 = arc4random_uniform(0xFFFFFFFF);
        colorCode |= 0xFF000000;
        return colorCode
    }
    
    @objc func add100k() {
        addSeriesWith(100000+1, colorCode: randomColorCode())
        sciChartView.zoomExtents()
    }
    
    @objc func add1m() {
        addSeriesWith(1000000+1, colorCode: randomColorCode())
        sciChartView.zoomExtents()
    }
    
}
