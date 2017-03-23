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
    let audioDataSeries: SCIXyDataSeries = SCIXyDataSeries(xType: .int32, yType: .int32, seriesType: .fifo)
    var updateDataSeries: samplesToEngine!
    var seriesCounter : Int32 = 0
//    var bufferOfAudioData = [Int32]()
    var displaylink : CADisplayLink!
    var lastTimestamp : Double = 0.0
    
    var newBuffer : UnsafeMutablePointer<Int32>?
    var sizeOfBuffer = 0
    
    @objc func updateData(displayLink: CADisplayLink) {
        
//        var currentSizeBlock = 0
        
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
            audioDataSeries.appendRangeX(SCIGenericSwift(xValues), y: SCIGenericSwift(buffer), count: Int32(sizeOfBlock))
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
     
//        print("In the begining Size of buffer = " + String(bufferOfAudioData.count) + " SizeBlock = " + String(sizeOfBlock))
//        for value in bufferOfAudioData {
//            audioDataSeries.appendX(SCIGenericSwift(seriesCounter), y: SCIGenericSwift(value))
//            seriesCounter += 1
//            currentSizeBlock += 1
//            if currentSizeBlock >= sizeOfBlock {
//                break
//            }
//        }
//        bufferOfAudioData.removeSubrange(Range(uncheckedBounds: (lower: 0, upper: currentSizeBlock)))
//        bufferOfAudioData = [Float]()
//        print("After Delete Size of buffer = " + String(bufferOfAudioData.count))
        
        lastTimestamp = displayLink.timestamp
        chartSurface.zoomExtentsX()
        chartSurface.renderSurface.invalidateElement()
    }
    
    override init(_ view: SCIChartSurfaceView) {
        super.init(view)
        
        displaylink = CADisplayLink(target: self, selector: #selector(updateData))
        displaylink.add(to: .current, forMode: .defaultRunLoopMode)
//        if #available(iOS 10.0, *) {
//            displaylink.preferredFramesPerSecond = 30
//        } else {
//            // Fallback on earlier versions
//        }
        
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
            
//            let Newarray = Array(UnsafeBufferPointer(start:UnsafeMutablePointer<Int32>.init(self.newBuffer), count: capacity))
//            
//            print("New = "+String(describing: Newarray.last))
//            
//            let array = Array(UnsafeBufferPointer(start:UnsafeMutablePointer<Int32>.init(dataSeries), count: 2048))
//            print("Old = "+String(describing: array.last))
//            self.bufferOfAudioData.append(contentsOf: array)
            
//            for counter in 0..<array.count {
//                self.audioDataSeries.appendX( SCIGeneric(self.seriesCounter), y: SCIGeneric(array[counter]))
//                self.seriesCounter += 1
//                
//            }
//            self.chartSurface.zoomExtentsX()
//            self.chartSurface.invalidateElement()
//            print("time stamp = " + String(Date().timeIntervalSince1970))
        }

        audioDataSeries.fifoCapacity = 500000
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
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(Int32.min), max: SCIGeneric(Int32.max))
        yAxis.autoRange = .never
        
        chartSurface.yAxes.add(yAxis)
        chartSurface.xAxes.add(xAxis)

    }
    
    func stopAnimating() {
        displaylink.invalidate()
        displaylink = nil
    }
    
}
