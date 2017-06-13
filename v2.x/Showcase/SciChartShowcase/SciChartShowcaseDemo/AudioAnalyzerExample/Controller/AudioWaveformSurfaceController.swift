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
    let audioDataSeries: SCIXyDataSeries = SCIXyDataSeries(xType: .int32, yType: .int32)
    var updateDataSeries: samplesToEngine!
    var seriesCounter : Int32 = 0
    var lastTimestamp : Double = 0.0
    var newBuffer : UnsafeMutablePointer<Int32>?
    var sizeOfBuffer = 0
    let fifoSize = 500000
    
    public func updateData(displayLink: CADisplayLink) {
        
        var diffTimeStamp = displayLink.timestamp - lastTimestamp
        
        if lastTimestamp == 0 {
            diffTimeStamp = displayLink.duration
        }
        
        var sizeOfBlock = Int(diffTimeStamp * 44100)

        sizeOfBlock = sizeOfBlock >= sizeOfBuffer ? sizeOfBuffer : sizeOfBlock

        let xValues = UnsafeMutablePointer<Int32>.allocate(capacity: sizeOfBlock)
        xValues.initialize(to: 0)
        var i = 0
        while i < sizeOfBlock {
            xValues[i] = seriesCounter
            seriesCounter += 1
            i += 1
        }
        
        if let buffer = newBuffer {
            audioDataSeries.appendRangeX(SCIGeneric(xValues), y: SCIGeneric(buffer), count: Int32(sizeOfBlock))
            let newSizeBuffer = sizeOfBuffer - sizeOfBlock
            let delocBuffer = UnsafeMutablePointer<Int32>.allocate(capacity: newSizeBuffer)
            delocBuffer.initialize(to: 0)
            delocBuffer.moveAssign(from: buffer.advanced(by: sizeOfBlock), count: newSizeBuffer)
            newBuffer = delocBuffer
            buffer.deallocate(capacity: sizeOfBuffer)
            sizeOfBuffer = newSizeBuffer
        }
        
        xValues.deinitialize()
        xValues.deallocate(capacity: sizeOfBlock)
     
        lastTimestamp = displayLink.timestamp
        chartSurface.zoomExtentsX()
        chartSurface.invalidateElement()
      
    }
    
    override init(_ view: SCIChartSurface) {
        super.init(view)
        
        chartSurface.bottomAxisAreaSize = 0.0
        chartSurface.topAxisAreaSize = 0.0
        chartSurface.leftAxisAreaSize = 0.0
        chartSurface.rightAxisAreaSize = 0.0
        
        self.updateDataSeries = { [unowned self] dataSeries in
            let capacity = 2048 + self.sizeOfBuffer
            let newBuffer : UnsafeMutablePointer<Int32>
            
            if let bf = self.newBuffer {
                newBuffer = UnsafeMutablePointer<Int32>.allocate(capacity: capacity)
                newBuffer.initialize(to: 0)
                newBuffer.moveAssign(from: bf, count: self.sizeOfBuffer)
                newBuffer.advanced(by: self.sizeOfBuffer).moveAssign(from: dataSeries!, count: 2048)
                self.newBuffer = newBuffer
                bf.deallocate(capacity: self.sizeOfBuffer)
                self.sizeOfBuffer = capacity
            }
            else if let data = dataSeries {
                newBuffer = UnsafeMutablePointer<Int32>.allocate(capacity: capacity)
                newBuffer.initialize(to: 0)
                newBuffer.moveAssign(from: data, count: capacity)
                self.newBuffer = newBuffer
                self.sizeOfBuffer = capacity
            }
        }

        audioDataSeries.fifoCapacity = Int32(fifoSize)
        audioWaveformRenderableSeries.dataSeries = audioDataSeries
//        fillFifoToMax()
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
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(Int32.min), max: SCIGeneric(Int32.max))
        yAxis.autoRange = .never
        
        chartSurface.yAxes.add(yAxis)
        chartSurface.xAxes.add(xAxis)
        
    }
    
//    func fillFifoToMax() {
//        let xValues = UnsafeMutablePointer<Int32>.allocate(capacity: fifoSize)
//        xValues.initialize(to: 0)
//        
//        for i in 0..<fifoSize {
//            xValues[i] = seriesCounter
//            seriesCounter += 1
//        }
//        
//        let yValues = UnsafeMutablePointer<Int32>.allocate(capacity: fifoSize)
//        yValues.initialize(to: 0)
//        
//        audioDataSeries.appendRangeX(SCIGeneric(xValues),
//                                     y: SCIGeneric(yValues),
//                                     count: Int32(fifoSize))
//        xValues.deinitialize()
//        xValues.deallocate(capacity: fifoSize)
//        yValues.deinitialize()
//        yValues.deallocate(capacity: fifoSize)
//        
//    }
    
}
