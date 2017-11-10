//
//  RealTimeGhostedTracesChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 5/1/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SCSRealTimeGhostedTracesChartView: UIView{
    
    private var chartSurface = SCIChartSurface()
    private var controlPanel: RealTimeGhostedTracesPanel?
    
    private var timer: Timer?
    private var timeInterval = 20.0 / 1000
    private var lastAmplitude = 1.0
    private var phase = 0.0
    
    private var circularArray:NSMutableArray = NSMutableArray()
    
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
        controlPanel = Bundle.main.loadNibNamed("RealTimeGhostedTracesPanel",
                                                owner: self,
                                                options: nil)!.first as? RealTimeGhostedTracesPanel
        
        controlPanel?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(controlPanel!)
        
        weak var wSelf = self
        controlPanel?.callBack = { (sender:UISlider) -> Void in wSelf!.speedChanged(sender) }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                         target: self,
                                         selector: #selector(SCSRealTimeGhostedTracesChartView.updateData),
                                         userInfo: nil,
                                         repeats: true)
        } else {
            timer?.invalidate()
            timer = nil
        }
    }
    
    fileprivate func configureChartSurface() {

        chartSurface.translatesAutoresizingMaskIntoConstraints = false
        addSubview(chartSurface)
        
        addPanel()
        
        let layoutDictionary = ["SciChart" : chartSurface, "Panel" : controlPanel!] as [String : Any]
        
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
        
        addSeries()
    }
    
    private func addSeries(){
        let limeGreen:UInt32 = 0xFF32CD32;
        
        addRenderSeries(limeGreen, thickness: 1.0)
        addRenderSeries(limeGreen, thickness: 0.9)
        addRenderSeries(limeGreen, thickness: 0.8)
        addRenderSeries(limeGreen, thickness: 0.7)
        addRenderSeries(limeGreen, thickness: 0.62)
        addRenderSeries(limeGreen, thickness: 0.55)
        addRenderSeries(limeGreen, thickness: 0.45)
        addRenderSeries(limeGreen, thickness: 0.35)
        addRenderSeries(limeGreen, thickness: 0.25)
        addRenderSeries(limeGreen, thickness: 0.15)
    }
    
    private func addRenderSeries(_ color:UInt32, thickness:Float){
        let lineRenderSeries = SCIFastLineRenderableSeries()
        lineRenderSeries.strokeStyle = SCISolidPenStyle.init(colorCode: color, withThickness: thickness)
        
        chartSurface.renderableSeries.add(lineRenderSeries)
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .never
        yAxis.visibleRange = SCIDoubleRange.init(min: SCIGeneric(-2), max: SCIGeneric(2))
        yAxis.growBy = SCIDoubleRange.init(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.yAxes.add(yAxis)
    }
    
    private func speedChanged(_ sender:UISlider){
        timer?.invalidate()
        timeInterval = Double(sender.value)/1000.0
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                     target: self,
                                     selector: #selector(SCSRealTimeGhostedTracesChartView.updateData),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc func updateData(_ timer:Timer){
        let dataSeries = SCIXyDataSeries.init(xType: .double, yType: .double)

        var randomAmplitude:Double = lastAmplitude + (RandomUtil.nextDouble() - 0.5);
        
        if (randomAmplitude < -2.0) {
            randomAmplitude = -2.0;
        }else if (randomAmplitude > 2.0){
            randomAmplitude = 2.0;
        }
        
        let doubleSeries = SCSDataManager.getNoisySinewave(randomAmplitude, phase: phase, pointCount: 1000, noiseAmplitude: 0.25)
        lastAmplitude = randomAmplitude;
        
        dataSeries.appendRangeX(doubleSeries.xValues, y: doubleSeries.yValues, count: doubleSeries.size)
        circularArray.add(dataSeries)
        
        if circularArray.count > 11 {
            circularArray.removeObject(at: 0)
        }
        
        reassignRenderSeries()
    }
    
    private func reassignRenderSeries(){
        let size = circularArray.count
        
        // Always the latest dataseries
        if (size > 0){
            chartSurface.renderableSeries.item(at: 0).dataSeries = circularArray[size-1] as! SCIDataSeriesProtocol
        }
        if (size > 1){
            chartSurface.renderableSeries.item(at: 1).dataSeries = circularArray[size-2] as! SCIDataSeriesProtocol
        }
        if (size > 2){
            chartSurface.renderableSeries.item(at: 2).dataSeries = circularArray[size-3] as! SCIDataSeriesProtocol
        }
        if (size > 3){
            chartSurface.renderableSeries.item(at: 3).dataSeries = circularArray[size-4] as! SCIDataSeriesProtocol
        }
        if (size > 4){
            chartSurface.renderableSeries.item(at: 4).dataSeries = circularArray[size-5] as! SCIDataSeriesProtocol
        }
        if (size > 5){
            chartSurface.renderableSeries.item(at: 5).dataSeries = circularArray[size-6] as! SCIDataSeriesProtocol
        }
        if (size > 6){
            chartSurface.renderableSeries.item(at: 6).dataSeries = circularArray[size-7] as! SCIDataSeriesProtocol
        }
        if (size > 7){
            chartSurface.renderableSeries.item(at: 7).dataSeries = circularArray[size-8] as! SCIDataSeriesProtocol
        }
        if (size > 8){
            chartSurface.renderableSeries.item(at: 8).dataSeries = circularArray[size-9] as! SCIDataSeriesProtocol
        }
        
        // Always the oldest dataseries
        if (size > 9){
            chartSurface.renderableSeries.item(at: 9).dataSeries = circularArray[size-10] as! SCIDataSeriesProtocol
        }
    }
}
