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

struct HeatmapSettings {
    static let xSize: Int32 = 250
    static let ySize: Int32 = 1024
}

class SpectogramSurfaceController: BaseChartSurfaceController {
    
    let audioWaveformRenderableSeries: SCIFastUniformHeatmapRenderableSeries = SCIFastUniformHeatmapRenderableSeries()
    var audioDataSeries: SCIUniformHeatmapDataSeries = SCIUniformHeatmapDataSeries(typeX: .int32,
                                                                                   y: .int32,
                                                                                   z: .float,
                                                                                   sizeX: 1024,
                                                                                   y: 250,
                                                                                   startX: SCIGeneric(0), stepX: SCIGeneric(1),
                                                                                   startY: SCIGeneric(0), stepY: SCIGeneric(1))
    var updateDataSeries: samplesToEngineFloat!
    var dataArrays = UnsafeMutablePointer<Float>.allocate(capacity: Int(HeatmapSettings.xSize*HeatmapSettings.ySize))
    var isNewData = false
    
    
    public func updateData(displayLink: CADisplayLink) {
        if isNewData {
            isNewData = false;
            audioDataSeries.updateZValues(SCIGeneric(dataArrays), size: HeatmapSettings.xSize*HeatmapSettings.ySize)
            chartSurface.invalidateElement()
        }

    }
    
    override init(_ view: SCIChartSurfaceView) {
        super.init(view)
        
        chartSurface.style.bottomAxisAreaSize = 0.0
        chartSurface.style.topAxisAreaSize = 0.0
        chartSurface.style.leftAxisAreaSize = 0.0
        chartSurface.style.rightAxisAreaSize = 0.0
        
        dataArrays.initialize(to: Float(0), count: Int(HeatmapSettings.ySize*HeatmapSettings.xSize))
        updateDataSeries = {[unowned self] dataSeries in
            if let pointerInt32 = dataSeries {
       
                memmove(self.dataArrays,
                       self.dataArrays.advanced(by: Int(HeatmapSettings.ySize)),
                       Int((HeatmapSettings.xSize-1)*HeatmapSettings.ySize)*MemoryLayout<Float>.size)
                
                memcpy(self.dataArrays.advanced(by: Int(HeatmapSettings.ySize*(HeatmapSettings.xSize-1))),
                       pointerInt32, Int(HeatmapSettings.ySize)*MemoryLayout<Float>.size)
                self.isNewData = true
                
            }
        }
        
        audioWaveformRenderableSeries.dataSeries = audioDataSeries
        audioWaveformRenderableSeries.style.minimum = SCIGeneric(Float(0.0))
        audioWaveformRenderableSeries.style.maximum = SCIGeneric(Float(60.0))
        
        var grad: Array<Float> = [0.0, 0.3, 0.5, 0.7, 0.9, 1.0]
        var colors: Array<UInt32> = [0xFF000000, 0xFF520306, 0xFF8F2325, 0xFF68E615, 0xFF6FB9CC, 0xFF1128e6]
        audioWaveformRenderableSeries.style.colorMap = SCITextureOpenGL.init(gradientCoords: &grad, colors: &colors, count: 6)
        
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
        xAxis.axisAlignment = .right
        xAxis.autoRange = .always
        
        let yAxis = SCINumericAxis()
        yAxis.style = axisStyle
        yAxis.autoRange = .always
        yAxis.flipCoordinates = true
        yAxis.axisAlignment = .bottom
        
        chartSurface.yAxes.add(yAxis)
        chartSurface.xAxes.add(xAxis)
        
        chartSurface.invalidateElement()
    }    
}
