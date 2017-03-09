//
//  FFTFormSurfaceController.swift
//  SciChartShowcaseDemo
//
//  Created by Yaroslav Pelyukh on 2/27/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart
import Accelerate

class FFTFormSurfaceController: BaseChartSurfaceController {
    
    let audioWaveformRenderableSeries: SCIFastColumnRenderableSeries = SCIFastColumnRenderableSeries()
    let audioDataSeries: SCIXyDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
    var updateDataSeries: samplesToEngine!
    
    override init(_ view: SCIChartSurfaceView) {
        super.init(view)
        
        self.updateDataSeries = { dataSeries in
            let fftSamples = Array(UnsafeBufferPointer(start:UnsafeMutablePointer<Float>.init(dataSeries), count: 40))
            
            if fftSamples[0].isNaN || fftSamples[0].isInfinite || fftSamples[0]>1.0{
                return;
            }
            if self.audioDataSeries.count() == 0 {
                for i in 0..<fftSamples.count {
                    self.audioDataSeries.appendX( SCIGeneric(i), y: SCIGeneric(fftSamples[i]))
                }
            }
            else{
                for i in 0..<fftSamples.count {
                    self.audioDataSeries.update(at: Int32(i), x: SCIGeneric(i), y: SCIGeneric(fftSamples[i]))
                }
            }
            
            DispatchQueue.main.async {
                self.chartSurface.invalidateElement()
            }
        }
        
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
        
        let yAxis = SCILogarithmicNumericAxis()
        yAxis.logarithmicBase = 10
        yAxis.style = axisStyle
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(0.00001), max: SCIGeneric(0.1))
        yAxis.autoRange = .never
        
        chartSurface.yAxes.add(yAxis)
        chartSurface.xAxes.add(xAxis)
        
        chartSurface.invalidateElement()
    }
}
