//
//  SCSLineChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 5/30/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class CustomSeriesDataView : SCIXySeriesDataView {
    
    static override func createInstance() -> SCITooltipDataView! {
        let view : CustomSeriesDataView = (Bundle.main.loadNibNamed("CustomSeriesDataView", owner: nil, options: nil)![0] as? CustomSeriesDataView)!
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }
    
    override func setData(_ data: SCISeriesInfo!) {
        let series : SCIRenderableSeriesProtocol = data.renderableSeries()
        
        let xAxis = series.xAxis
        let yAxis = series.yAxis
        
        self.nameLabel.text = data.seriesName()
        
        var xFormattedValue : String? = data.fortmatterdValue(fromSeriesInfo: data.xValue(), for: series.dataSeries.xType())
        if (xFormattedValue == nil) {
            xFormattedValue = xAxis?.formatCursorText(data.xValue())
        }
        
        var yFormattedValue : String? = data.fortmatterdValue(fromSeriesInfo: data.yValue(), for: series.dataSeries.yType())
        if (yFormattedValue == nil) {
            yFormattedValue = yAxis?.formatCursorText(data.yValue())
        }
        
        self.dataLabel.text = String(format: "Custom-X: %@ Custom-Y %@", xFormattedValue!, yFormattedValue!)
        
        self.invalidateIntrinsicContentSize()
    }
}

class CustomSeriesInfo : SCIXySeriesInfo {
    override func createDataSeriesView() -> SCITooltipDataView! {
        let view : CustomSeriesDataView = CustomSeriesDataView.createInstance() as! CustomSeriesDataView
        view.setData(self)
        return view;
    }
}

class CustomLineSeries : SCIFastLineRenderableSeries {
    override func toSeriesInfo(withHitTest info: SCIHitTestInfo) -> SCISeriesInfo! {
        return CustomSeriesInfo(series: self, hitTest: info)
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
        self.xAxes.add(xAxis)
        self.yAxes.add(yAxis)
        
        self.chartModifiers.add(SCIRolloverModifier())
        
        addSeries()
    }
    
    private func addSeries() {
        data1 = SCIXyDataSeries(xType: .float, yType: .float)
        
        for i in 0...10 {
            data1.appendX(SCIGeneric(i), y: SCIGeneric((i % 3) * 2))
        }
        
        let renderSeries1 = CustomLineSeries()
        renderSeries1.dataSeries = data1
        renderSeries1.xAxisId = "XAxis"
        renderSeries1.yAxisId = "YAxis"
        self.renderableSeries.add(renderSeries1)
        
        self.invalidateElement()
    }
    
}
