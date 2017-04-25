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

        chartSurface.style.topAxisAreaSize = 0.0
        chartSurface.style.rightAxisAreaSize = 0.0
        for i in 0..<fftSize {
            dataXIndeces[i] = Int32(i*44100/(fftSize*2));
        }
        
        dataYInt.initialize(to: 50.0, count: fftSize)
        audioDataSeries.appendRangeX(SCIGenericSwift(dataXIndeces), y: SCIGenericSwift(dataYInt), count: Int32(fftSize))
        
        updateDataSeries = { [unowned self] dataSeries in
            if let data = dataSeries {
                self.dataYInt.moveAssign(from: data, count: self.fftSize)
                self.isNewData = true
            }
        }
        
        audioWaveformRenderableSeries.dataSeries = audioDataSeries
        audioWaveformRenderableSeries.zeroLineY = -30.0;
        chartSurface.renderableSeries.add(audioWaveformRenderableSeries)
        
        var axisStyle = SCIAxisStyle()
        axisStyle.drawMajorBands = false
        axisStyle.drawMinorTicks = false
        axisStyle.drawMajorGridLines = false
        axisStyle.drawMinorGridLines = false
        
        
        let xAxis = SCINumericAxis()
        xAxis.style = axisStyle
        xAxis.visibleRange = SCIIntegerRange(min: SCIGenericSwift(1), max: SCIGenericSwift(Int32(1023*44100/(fftSize*2))))
        xAxis.autoRange = .never
//        xAxis.axisTitle = "Hz"
//        xAxis.style.axisTitleLabelStyle = SCITextFormattingStyle()
//        xAxis.style.axisTitleLabelStyle.alignmentVertical = .center
//        xAxis.style.axisTitleLabelStyle.alignmentHorizontal = .right
        
        axisStyle = SCIAxisStyle()
        axisStyle.drawMajorBands = false
        axisStyle.drawMinorTicks = false
        axisStyle.drawMinorGridLines = false
        axisStyle.axisTitleLabelStyle = SCITextFormattingStyle()
        
        let yAxis = SCINumericAxis()
        yAxis.style = axisStyle
        yAxis.visibleRange = SCIFloatRange(min: SCIGenericSwift(Float(-20.0)), max: SCIGenericSwift(Float(70.0)))
        yAxis.autoRange = .never
        yAxis.axisAlignment = .left
//        yAxis.axisTitle = "dB"

//        yAxis.style.axisTitleLabelStyle.alignmentVertical = .top
//        yAxis.style.axisTitleLabelStyle.alignmentHorizontal = .center
//        yAxis.style.axisTitleLabelStyle.transform = CGAffineTransform(rotationAngle: .pi*2.0)
        
        
        chartSurface.yAxes.add(yAxis)
        chartSurface.xAxes.add(xAxis)
        
        chartSurface.invalidateElement()
    }
}
