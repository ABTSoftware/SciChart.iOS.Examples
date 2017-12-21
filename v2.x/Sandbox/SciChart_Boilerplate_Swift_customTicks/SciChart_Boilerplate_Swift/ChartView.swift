//
//  SCSLineChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 5/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class CustomTicks : SCINumericTickProvider {
    override func calculateMajorTicks(withRange tickRange: SCIRangeProtocol!, delta tickDelta: SCIAxisDeltaProtocol!) -> SCIArrayController! {
        // array of ticks. Values are related to cahrt data and not coorinates on screen
        // axis labels and major grid lines are formed by this array
        let ticks = SCIArrayController(type: .double)
        ticks?.append(tickRange.min)
        ticks?.append(tickRange.max)
        return ticks!
    }
    
    override func calculateMinorTicks(withRange tickRange: SCIRangeProtocol!, delta tickDelta: SCIAxisDeltaProtocol!) -> SCIArrayController! {
        // array of ticks. Values are related to cahrt data and not coorinates on screen
        // minor grid lines are formed by this array
        let ticks : SCIArrayController = SCIArrayController(type: .double)
        var tickValue : Double = 0;
        while tickValue < 160 {
            ticks.append(SCIGeneric(tickValue))
            tickValue += 4;
        }
        return ticks
    }
}

class ChartView: SCIChartSurface {
    
    var data1 : SCIXyDataSeries! = nil
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        let xAxis = SCINumericAxis()
        xAxis.axisId = "XAxis"
        let yAxis = SCINumericAxis()
        yAxis.axisId = "YAxis"
        yAxis.style.minorTickBrush = SCISolidPenStyle(color: UIColor.white, withThickness: 1)
        yAxis.tickProvider = CustomTicks()
        self.xAxes .add(xAxis)
        self.yAxes .add(yAxis)
        
        addSeries()
    }
    
    private func addSeries() {
        data1 = SCIXyDataSeries(xType: .float, yType: .float)
        
        for i in 0...10 {
            data1.appendX(SCIGeneric(i), y: SCIGeneric((i % 3) * 20))
        }
        
        let renderSeries1 = SCIFastLineRenderableSeries()
        renderSeries1.dataSeries = data1
        renderSeries1.xAxisId = "XAxis"
        renderSeries1.yAxisId = "YAxis"
        renderSeries1.style.strokeStyle = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 2)
        self.renderableSeries.add(renderSeries1)
        
        self.invalidateElement()
    }
    
}
