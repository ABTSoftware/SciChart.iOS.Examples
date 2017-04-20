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
    let audioDataSeries: SCIXyDataSeries = SCIXyDataSeries(xType: .int32, yType: .float, seriesType: .defaultType)
    var updateDataSeries: samplesToEngineFloat!
    let dataXIndeces = UnsafeMutablePointer<Int32>.allocate(capacity: 1024)
    let dataYInt = UnsafeMutablePointer<Float>.allocate(capacity: 1024)
    let fftSize: Int = 1024
    var isNewData = false
    
    public func updateData(displayLink: CADisplayLink) {
        if isNewData {
            isNewData = false
            audioDataSeries.updateRange(0,
                                        xValues: SCIGenericSwift(dataXIndeces),
                                        yValues: SCIGenericSwift(dataYInt),
                                        count: Int32(fftSize))
            chartSurface.invalidateElement()
        }
    }
    
    override init(_ view: SCIChartSurfaceView) {
        super.init(view)
        
        for i in 0..<fftSize {
            dataXIndeces[i] = Int32(i)
        }
        
        dataYInt.initialize(to: 12000000, count: fftSize)
        audioDataSeries.appendRangeX(SCIGenericSwift(dataXIndeces), y: SCIGenericSwift(dataYInt), count: Int32(fftSize))
        
        updateDataSeries = { [unowned self] dataSeries in
            if let data = dataSeries {
                self.dataYInt.moveAssign(from: data, count: self.fftSize)
                self.isNewData = true
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
        xAxis.visibleRange = SCIIntegerRange(min: SCIGenericSwift(1), max: SCIGenericSwift(fftSize))
        xAxis.autoRange = .never
        
        let yAxis = SCINumericAxis()
        yAxis.style = axisStyle
        yAxis.visibleRange = SCIFloatRange(min: SCIGenericSwift(Float(0.0)), max: SCIGenericSwift(Float(10.0)))
        yAxis.autoRange = .never
        
        chartSurface.yAxes.add(yAxis)
        chartSurface.xAxes.add(xAxis)
        
        chartSurface.invalidateElement()
    }
}
