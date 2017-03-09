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
    
    let sciChartView = SCSBaseChartView()
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
        addAxis()
        sciChartView.addDefaultModifiers()
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
        let style = sciChartView.generateDefaultAxisStyle()
        sciChartView.chartSurface.xAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: style))
        sciChartView.chartSurface.yAxes.add(SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: style))
    }
    
    fileprivate func addSeriesWith(_ count: Int32, colorCode: UInt32) {
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .double, seriesType: .defaultType)
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let y = Double(arc4random_uniform(100))
        
        var i: Int32 = 0
        while i < count {
            let x = SCIGeneric(i)
            let yValue = y + randomize(-5.0, max: 5.0)
            dataSeries.appendX(x, y: SCIGeneric(yValue))
            i += 1
        }
        
        let renderableSeries = SCIFastLineRenderableSeries()
        renderableSeries.style.linePen = SCISolidPenStyle(colorCode: colorCode, withThickness: 0.5)
        renderableSeries.dataSeries = dataSeries
        
        sciChartView.chartSurface.renderableSeries.add(renderableSeries)
        sciChartView.chartSurface.invalidateElement()
//        sciChartView.chartSurface.zoomExtents()
    }
    
    fileprivate func randomize(_ min: Double, max: Double) -> Double {
        return Double(arc4random() / 10000000) * (max - min) + min
    }
    

    // MARK: Button Actions
    
    func clearAction() {
        let series : SCIRenderableSeriesCollection! = sciChartView.chartSurface.renderableSeries
        for i in 0..<series.count() {
            let item = series.item(at: i)
            sciChartView.chartSurface.renderableSeries.remove(item)
        }
  
    }
    
    func add100k() {
        addSeriesWith(100000+1, colorCode: 0xFFa9d34f)
    }
    
    func add1m() {
        addSeriesWith(1000000+1, colorCode: 0xFFfc9930)
    }
    
}
