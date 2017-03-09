//
//  AudioWaveformSurfaceController.swift
//  SciChartShowcaseDemo
//
//  Created by Yaroslav Pelyukh on 2/26/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class AudioWaveformSurfaceController: BaseChartSurfaceController {
    
    let audioWaveformRenderableSeries: SCIFastLineRenderableSeries = SCIFastLineRenderableSeries()
    let audioDataSeries: SCIXyDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .fifo)
    var updateDataSeries: samplesToEngine!
    var seriesCounter = 0
    
    override init(_ view: SCIChartSurfaceView) {
        super.init(view)
        
        self.updateDataSeries = { dataSeries in
            let array = Array(UnsafeBufferPointer(start:UnsafeMutablePointer<Float>.init(dataSeries), count: 80))
            
            for counter in 0..<array.count {
                self.audioDataSeries.appendX( SCIGeneric(self.seriesCounter), y: SCIGeneric(array[counter]))
                self.seriesCounter += 1
                
            }
            
            self.chartSurface.zoomExtentsX()
            self.chartSurface.invalidateElement()
        }
        
        audioDataSeries.fifoCapacity = 10000
        audioWaveformRenderableSeries.dataSeries = audioDataSeries
        
        chartSurface.renderableSeries.add(audioWaveformRenderableSeries)
        
        let axisStyle = SCIAxisStyle()
        axisStyle.drawLabels = false
        axisStyle.drawMajorBands = false
        axisStyle.drawMinorTicks = false
        axisStyle.drawMajorTicks = false
        axisStyle.drawMajorGridLines = false
        axisStyle.drawMinorGridLines = false
        
        let xAxis = SCINumericAxis()
        xAxis.style = axisStyle
        
        let yAxis = SCINumericAxis()
        yAxis.style = axisStyle
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(-0.5), max: SCIGeneric(0.5))
        yAxis.autoRange = .never
        
        chartSurface.yAxes.add(yAxis)
        chartSurface.xAxes.add(xAxis)
        
        chartSurface.invalidateElement()
    }
}
