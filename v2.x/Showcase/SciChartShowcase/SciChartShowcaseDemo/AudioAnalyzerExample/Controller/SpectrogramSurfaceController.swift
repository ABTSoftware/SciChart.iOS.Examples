//
//  SpectrogramSurfaceController.swift
//  SciChartShowcaseDemo
//
//  Created by Yaroslav Pelyukh on 2/27/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart
import Accelerate

class SpectogramSurfaceController: BaseChartSurfaceController {
    
    let audioWaveformRenderableSeries: SCIFastUniformHeatmapRenderableSeries = SCIFastUniformHeatmapRenderableSeries()
    
    var audioDataArrayController: SCIArrayController2D!
    var audioDataSeries: SCIUniformHeatmapDataSeries = SCIUniformHeatmapDataSeries(typeX: .float, y: .float, z: .float, sizeX: 60, y: 26, startX: SCIGeneric(0.0), stepX: SCIGeneric(1.0), startY: SCIGeneric(0.0), stepY: SCIGeneric(1.0))
    var updateDataSeries: samplesToEngine!
    var dataCounter = 0
    var dataArrays = Array(repeating: Array<Float>(repeating: 0.0, count: 26), count: 60)
    
    override init(_ view: SCIChartSurfaceView) {
        super.init(view)
        
        for i in 0..<60 {
            for j in 0..<26{
                dataArrays[i][j] = 0.0
            }
        }
        
        self.updateDataSeries = { dataSeries in
            let fftSamples = Array(UnsafeBufferPointer(start:UnsafeMutablePointer<Float>.init(dataSeries), count: 80))
            
            self.dataArrays.remove(at: 0)
            self.dataArrays.append(Array(fftSamples[0..<fftSamples.count/3]))
            
            self.audioDataArrayController = SCIArrayController2D(type: .float, sizeX: 60, y: (Int32)(fftSamples.count/3))
            for i in 0..<60 {
                for j in 0..<fftSamples.count/3{
                    self.audioDataArrayController.setValue(SCIGeneric(self.dataArrays[i][j]), atX: Int32(i), y: Int32(j))
                }
            }
            
            self.audioDataSeries.updateZValues(self.audioDataArrayController)
            
            DispatchQueue.main.async {
                self.chartSurface.invalidateElement()
            }
        }
        
        audioWaveformRenderableSeries.dataSeries = audioDataSeries
        audioWaveformRenderableSeries.style.min = SCIGeneric(0.001)
        audioWaveformRenderableSeries.style.max = SCIGeneric(0.01)
        
        var grad: Array<Float> = [0.0, 0.3, 0.5, 0.7, 0.9, 1.0]
        var colors: Array<UInt32> = [0xFF000000, 0xFF520306, 0xFF8F2325, 0xFF68E615, 0xFF6FB9CC, 0xFF1128E6]
        audioWaveformRenderableSeries.style.palette = SCITextureOpenGL.init(gradientCoords: &grad, colors: &colors, count: 6)
        
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
        
        chartSurface.yAxes.add(yAxis)
        chartSurface.xAxes.add(xAxis)
        
        chartSurface.invalidateElement()
    }    
}
