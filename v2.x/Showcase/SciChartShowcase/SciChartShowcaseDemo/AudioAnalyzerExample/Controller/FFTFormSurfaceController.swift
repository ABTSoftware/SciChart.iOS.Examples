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
    let audioDataSeries: SCIXyDataSeries = SCIXyDataSeries(xType: .int32, yType: .float)
    var updateDataSeries: samplesToEngineFloat!
    let dataXIndeces = UnsafeMutablePointer<Int32>.allocate(capacity: 1024)
    let dataYInt = UnsafeMutablePointer<Float>.allocate(capacity: 1024)
    let fftSize: Int = 1024
    var isNewData = false
    let textHzAnnotation = SCITextAnnotation()
    
    public func updateData(displayLink: CADisplayLink) {
        if isNewData {
            isNewData = false
            audioDataSeries.updateRange(0,
                                        xValues: SCIGeneric(dataXIndeces),
                                        yValues: SCIGeneric(dataYInt),
                                        count: Int32(fftSize))
            chartSurface.invalidateElement()
        }
    }
    
    override init(_ view: SCIChartSurface) {
        super.init(view)

        chartSurface.topAxisAreaSize = 0.0
        chartSurface.rightAxisAreaSize = 0.0
        chartSurface.bottomAxisAreaSize = 0.0
        
        for i in 0..<fftSize {
            dataXIndeces[i] = Int32(i*44100/(fftSize*2));
        }
        
        dataYInt.initialize(to: 50.0, count: fftSize)
        audioDataSeries.appendRangeX(SCIGeneric(dataXIndeces), y: SCIGeneric(dataYInt), count: Int32(fftSize))
        
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
        axisStyle.drawLabels = false;
        
        let xAxis = SCINumericAxis()
        xAxis.style = axisStyle
        xAxis.visibleRange = SCIIntegerRange(min: SCIGeneric(0), max: SCIGeneric(Int32(1023*44100/(fftSize*2))))
//        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.005), max: SCIGeneric(0.005))
        xAxis.autoRange = .never
        
        axisStyle = SCIAxisStyle()
        axisStyle.drawMajorBands = false
        axisStyle.drawMinorTicks = false
        axisStyle.drawMinorGridLines = false
        axisStyle.axisTitleLabelStyle = SCITextFormattingStyle()
        
        let yAxis = SCINumericAxis()
        yAxis.style = axisStyle
        yAxis.visibleRange = SCIFloatRange(min: SCIGeneric(Float(-20.0)), max: SCIGeneric(Float(67.0)))
        yAxis.autoRange = .never
        yAxis.axisAlignment = .left
        yAxis.maxAutoTicks = 9
        yAxis.autoTicks = false
        yAxis.style.labelStyle.fontSize = 12.0
        yAxis.majorDelta = SCIGeneric(10.0)
        yAxis.minorDelta = SCIGeneric(1.0)

        chartSurface.yAxes.add(yAxis)
        chartSurface.xAxes.add(xAxis)
        audioWaveformRenderableSeries.paletteProvider = FFTPaletteProvider(with: yAxis.getCurrentCoordinateCalculator())
        
        
        let textAnnotationStyle = SCITextFormattingStyle()
        textAnnotationStyle.fontSize = 12
        
        let textAnnotation = SCITextAnnotation()
        textAnnotation.text = "dB"
        textAnnotation.style.backgroundColor = UIColor.clear
        textAnnotation.style.textColor = UIColor.white
        textAnnotation.style.textStyle = textAnnotationStyle
        textAnnotation.x1 = SCIGeneric(0)
        textAnnotation.y1 = SCIGeneric(Float(70.0))

        textHzAnnotation.text = "22 kHz"
        textHzAnnotation.horizontalAnchorPoint = .right
        textHzAnnotation.style.backgroundColor = UIColor.clear
        textHzAnnotation.style.textColor = UIColor.white
        textHzAnnotation.style.textStyle = textAnnotationStyle
        textHzAnnotation.coordinateMode = .relative
        textHzAnnotation.x1 = SCIGeneric(1)
        textHzAnnotation.y1 = SCIGeneric(0)
        
        
        let annotations = SCIAnnotationCollection()
        annotations.add(textAnnotation)
        annotations.add(textHzAnnotation)
        chartSurface.annotations = annotations
        
        chartSurface.invalidateElement()
    }
    
    func setMaxHz(maxValue: Int) {
        let xAxis = chartSurface.xAxes.defaultAxis()
        if let axis = xAxis {
            textHzAnnotation.text = String(maxValue/1000)+" kHz"
            axis.visibleRange = SCIIntegerRange(min: SCIGeneric(1), max: SCIGeneric(Int32(1023*maxValue*2/(fftSize*2))))
        }
    }
}
