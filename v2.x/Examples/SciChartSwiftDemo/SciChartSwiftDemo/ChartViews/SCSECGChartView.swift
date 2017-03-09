//
//  SCSECGChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSECGChartView: SCSBaseChartView {
    
    let dataSeries: SCIXyDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .fifo)
    let sourceData: SCIXyDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
    
    var timer: Timer!
    var currentIndex: Int32 = 0
    var totalCount = 0.0
    
    var isBeat: Bool = false, lastBeat: Bool = false
    var heartRate: Int = 0
    var lastBeatTime: Date = Date()
    
    // MARK: Overrided Functions
    
    override func completeConfiguration() {
        super.completeConfiguration()
        addAxis()
        addDefaultModifiers()
        addDataSeries()
        dataSeries.fifoCapacity = 1500
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 0.04,
                                                           target: self,
                                                           selector: #selector(SCSECGChartView.updateECGData),
                                                           userInfo: nil,
                                                           repeats: true)
        }
    }
    
    override func removeFromSuperview() {
        super.removeFromSuperview()
        if timer != nil {
            timer.invalidate()
        }
    }
    
    // MARK: Internal Function
    
    func updateECGData() {
        var i = 0
        while i < 10 {
            appendPoint(400)
            i += 1
        }
        
        isBeat = SCIGenericDouble(dataSeries.yValues().value(at: dataSeries.count()-3)) > 0.5 ||
            SCIGenericDouble(dataSeries.yValues().value(at: dataSeries.count()-5)) > 0.5 ||
            SCIGenericDouble(dataSeries.yValues().value(at: dataSeries.count()-8)) > 0.5
        
        if isBeat && !lastBeat {
            heartRate = Int(60.0/lastBeatTime.timeIntervalSinceNow)
            lastBeatTime = Date()
        }
        chartSurface.viewportManager .zoomExtents()
        
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        
        let updateTime = 1.0 / 30.0
        let axisStyle = generateDefaultAxisStyle()
        
        let xAxis = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        xAxis.autoRange = .always
        xAxis.animatedChangeDuration = updateTime*2
        xAxis.animateVisibleRangeChanges = true
        chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        yAxis.autoRange = .always
        yAxis.animatedChangeDuration = updateTime*2
        yAxis.animateVisibleRangeChanges = true
        
        chartSurface.yAxes.add(yAxis)

    }
    
    fileprivate func addDataSeries() {
        SCSDataManager.loadData(into: sourceData, from: "WaveformData")
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        let renderableSeries = SCIFastLineRenderableSeries()
        renderableSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFFb3e8f6, withThickness: 0.5)
        renderableSeries.dataSeries = dataSeries
        chartSurface.renderableSeries.add(renderableSeries)
        chartSurface.invalidateElement()
    }
    
    fileprivate func appendPoint(_ point: Double) {
        if currentIndex >= sourceData.count() {
            currentIndex = 0
        }
        
        let voltage = SCIGenericFloat(sourceData.yValues().value(at: currentIndex))*1000
        let time = totalCount / point
        dataSeries.appendX(SCIGeneric(time), y: SCIGeneric(voltage))
        chartSurface.invalidateElement()
        currentIndex += 1
        totalCount += 1
        lastBeat = isBeat
    }
    
}
