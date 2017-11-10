//
//  FifoScrollingChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 5/1/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import SciChart
import UIKit

class SCSFifoScrollingChartView: UIView{
    private var chartSurface = SCIChartSurface()
//    private var chartSurfaceView: SCIChartSurfaceView?
    private var controlPanel: FifoScrollingChartPanel?
    
    private var timer: Timer?
    
    private var FIFO_CAPACITY:Double!
    private var TIME_INTERVAL:Double!
    private var ONE_OVER_TIME_INTERVAL:Double!
    private var VISIBLE_RANGE_MAX:Double!
    private var GROW_BY:Double!
    
    private var t:Double = 0.0
    
    private var ds1: SCIXyDataSeries!
    private var ds2: SCIXyDataSeries!
    private var ds3: SCIXyDataSeries!
    
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
        FIFO_CAPACITY = 50
        TIME_INTERVAL = 30
        ONE_OVER_TIME_INTERVAL = 1.0/TIME_INTERVAL
        VISIBLE_RANGE_MAX = FIFO_CAPACITY * ONE_OVER_TIME_INTERVAL
        GROW_BY = VISIBLE_RANGE_MAX * 0.1
        
        configureChartSurface()
        addAxes()
    }
    
    fileprivate func addPanel() {
        controlPanel = Bundle.main.loadNibNamed("FifoScrollingChartPanel",
                                                owner: self,
                                                options: nil)!.first as? FifoScrollingChartPanel
        
        controlPanel?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(controlPanel!)
        
        weak var wSelf = self
        controlPanel?.playCallback = { () -> Void in wSelf!.playPressed() }
        controlPanel?.pauseCallback = { () -> Void in wSelf!.pausePressed() }
        controlPanel?.stopCallback = { () -> Void in wSelf!.stopPressed() }
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: TIME_INTERVAL/1000,
                                         target: self,
                                         selector: #selector(SCSFifoScrollingChartView.updateData),
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
        ds1 = SCIXyDataSeries.init(xType: .float, yType: .float)
        ds1.fifoCapacity = Int32(FIFO_CAPACITY)
        ds2 = SCIXyDataSeries.init(xType: .float, yType: .float)
        ds2.fifoCapacity = Int32(FIFO_CAPACITY)
        ds3 = SCIXyDataSeries.init(xType: .float, yType: .float)
        ds3.fifoCapacity = Int32(FIFO_CAPACITY)
        
        addRenderSeries(0xFF4083B7, thickness: 2.0, dataSeries:ds1)
        addRenderSeries(0xFFFFA500, thickness: 2.0, dataSeries:ds2)
        addRenderSeries(0xFFE13219, thickness: 2.0, dataSeries:ds3)
    }
    
    private func addRenderSeries(_ color:UInt32, thickness:Float, dataSeries:SCIXyDataSeriesProtocol){
        let lineRenderSeries = SCIFastLineRenderableSeries()
        lineRenderSeries.strokeStyle = SCISolidPenStyle.init(colorCode: color, withThickness: thickness)
        lineRenderSeries.dataSeries = dataSeries
        
        chartSurface.renderableSeries.add(lineRenderSeries)
    }
    
    // MARK: Private Functions
    
    fileprivate func addAxes() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .never
        xAxis.visibleRange = SCIDoubleRange.init(min: SCIGeneric(-GROW_BY), max: SCIGeneric(VISIBLE_RANGE_MAX+GROW_BY))
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        yAxis.growBy = SCIDoubleRange.init(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        chartSurface.yAxes.add(yAxis)
    }
    
    private func playPressed(){
        if timer == nil {
        timer = Timer.scheduledTimer(timeInterval: TIME_INTERVAL/1000,
                                     target: self,
                                     selector: #selector(SCSFifoScrollingChartView.updateData),
                                     userInfo: nil,
                                     repeats: true)
        }
    }
    
    private func pausePressed(){
        timer?.invalidate()
        timer = nil
    }
    
    private func stopPressed(){
        timer?.invalidate()
        timer = nil
        
        ds1.clear()
        ds2.clear()
        ds3.clear()

    }
    
    @objc func updateData(_ timer:Timer){
        let y1:Double = 3.0 * sin(((2 * Double.pi) * 1.4) * t) + RandomUtil.nextDouble() * 0.5
        let y2:Double = 2.0 * cos(((2 * Double.pi) * 0.8) * t) + RandomUtil.nextDouble() * 0.5
        let y3:Double = 1.0 * sin(((2 * Double.pi) * 2.2) * t) + RandomUtil.nextDouble() * 0.5
        
        ds1.appendX(SCIGeneric(t), y: SCIGeneric(y1))
        ds2.appendX(SCIGeneric(t), y: SCIGeneric(y2))
        ds3.appendX(SCIGeneric(t), y: SCIGeneric(y3))
        
        t += ONE_OVER_TIME_INTERVAL;
        
        let xaxis = chartSurface.xAxes.item(at: 0)

        if (t > VISIBLE_RANGE_MAX) {
            xaxis?.visibleRange.min = SCIGeneric(SCIGenericDouble(xaxis!.visibleRange.min)+ONE_OVER_TIME_INTERVAL)
            xaxis?.visibleRange.max = SCIGeneric(SCIGenericDouble(xaxis!.visibleRange.max)+ONE_OVER_TIME_INTERVAL)
        }
        
        chartSurface.invalidateElement()
    }
}
