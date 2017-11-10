//
//  SCSUsingRolloverModifierChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 7/23/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSUsingRolloverModifierChartView: UIView {
    
    let sciChartView = SCIChartSurface()
    var controlPanel : SCSInterpolationTurnOnOff!
    
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
        addAxes()
        addSeries()
        addDefaultModifiers()
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
        let panel = Bundle.main.loadNibNamed("SCSInterpolationTurnOnOff",
                                                       owner: self,
                                                       options: nil)!.first
        
        if let panelValid = panel as? SCSInterpolationTurnOnOff {
            
            controlPanel = panelValid
            
            controlPanel.translatesAutoresizingMaskIntoConstraints = false
            
            controlPanel.useInterpolationClicked.addTarget(self,
                                               action: #selector(SCSUsingRolloverModifierChartView.turnOnOffInterpolation),
                                               for: .touchUpInside)
            
            addSubview(controlPanel)
            
        }
    }
    
    
    @objc func turnOnOffInterpolation(){
        let seriesCollection : SCIRenderableSeriesCollection! = sciChartView.renderableSeries;
        for i in 0..<seriesCollection.count() {
            let series = seriesCollection.item(at: UInt32(i));
            (series as AnyObject).hitTestProvider().hitTestMode = (series as AnyObject).hitTestProvider().hitTestMode == .vertical ? .verticalInterpolate : .vertical
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
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        sciChartView.xAxes.add(SCINumericAxis())
        sciChartView.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func addSeries() {
        let ellipsePointMarker: SCIEllipsePointMarker = SCIEllipsePointMarker()
        ellipsePointMarker.fillStyle = SCISolidBrushStyle(colorCode: 0xFFd7ffd6)
        ellipsePointMarker.height = 5
        ellipsePointMarker.width = 5

        
        sciChartView.renderableSeries.add(self.getFastLineRenderableSeries(ellipsePointMarker, amplitude:1.0 , colorCode:0xFFa1b9d7))
        sciChartView.renderableSeries.add(self.getFastLineRenderableSeries(ellipsePointMarker, amplitude:0.5 , colorCode:0xFF0b5400))
        sciChartView.renderableSeries.add(self.getFastLineRenderableSeries(nil, amplitude: 0, colorCode: 0xFF386ea6))
   
    }
    
    fileprivate func getFastLineRenderableSeries(_ pointMarker: SCIEllipsePointMarker?, amplitude: Double, colorCode: uint) -> SCIFastLineRenderableSeries {
        let fourierDataSeries: SCIXyDataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        let count: Double = 100.0
        let k: Double = 2 * Double.pi / 30.0
        
        for i in 0..<Int(count) {
            let phi: Double = k * Double(i)
            fourierDataSeries.appendX(SCIGeneric(i), y: SCIGeneric((amplitude + Double(i) / count) * sin(phi)))
        }
        fourierDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let fourierRenderableSeries: SCIFastLineRenderableSeries = SCIFastLineRenderableSeries()
        fourierRenderableSeries.strokeStyle = SCISolidPenStyle(colorCode: colorCode, withThickness: 1.0)
        fourierRenderableSeries.dataSeries = fourierDataSeries
        
        fourierRenderableSeries.hitTestProvider().hitTestMode = .verticalInterpolate;
        
        if pointMarker != nil {
            fourierRenderableSeries.style.pointMarker = pointMarker
        }
        return fourierRenderableSeries
    }
    
}
