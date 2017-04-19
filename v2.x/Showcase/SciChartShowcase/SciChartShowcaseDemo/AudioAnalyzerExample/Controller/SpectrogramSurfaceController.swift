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
    var dataArrays = UnsafeMutablePointer<UnsafeMutablePointer<Float>>.allocate(capacity: Int(HeatmapSettings.xSize))
    
    
    public func updateData(displayLink: CADisplayLink) {
       
        let zValues = UnsafeMutablePointer<Float>.allocate(capacity: Int(HeatmapSettings.xSize)*Int(HeatmapSettings.ySize))
        for i in 0..<Int(HeatmapSettings.xSize) {
            zValues.advanced(by: Int(HeatmapSettings.ySize)*i).moveInitialize(from: dataArrays[i], count: Int(HeatmapSettings.ySize))
        }
        audioDataSeries.updateZValues(SCIGenericSwift(zValues), size: HeatmapSettings.xSize*HeatmapSettings.ySize)
        chartSurface.invalidateElement()
        
        zValues.deinitialize()
        zValues.deallocate(capacity: Int(HeatmapSettings.xSize)*Int(HeatmapSettings.ySize))
    }
    
    override init(_ view: SCIChartSurfaceView) {
        super.init(view)
        
        for i in 0..<Int(HeatmapSettings.xSize) {
            let zColumnValues = UnsafeMutablePointer<Float>.allocate(capacity: Int(HeatmapSettings.ySize))
            zColumnValues.initialize(to: Float(0), count: Int(HeatmapSettings.ySize))
            dataArrays[i] = zColumnValues
        }
        
//        let zColumnValues = UnsafeMutablePointer<Float>.allocate(capacity: Int(HeatmapSettings.ySize))
//        zColumnValues.initialize(to: Float(0), count: Int(HeatmapSettings.ySize))
//        dataArrays.initialize(to: zColumnValues, count: Int(HeatmapSettings.xSize))
        
        updateDataSeries = {[unowned self] dataSeries in
            if let pointerInt32 = dataSeries {
                let newStartsZValues = UnsafeMutablePointer<UnsafeMutablePointer<Float>>.allocate(capacity: Int(HeatmapSettings.xSize))
                newStartsZValues.moveInitialize(from: self.dataArrays.advanced(by: 1), count: Int(HeatmapSettings.xSize)-1)
                
                self.dataArrays[0].deinitialize()
                self.dataArrays[0].deallocate(capacity: Int(HeatmapSettings.ySize))
                
                self.dataArrays = newStartsZValues
                
                self.dataArrays.advanced(by: Int(HeatmapSettings.xSize)-1).initialize(to: pointerInt32)
                
            }
        }
        
        audioWaveformRenderableSeries.dataSeries = audioDataSeries
        audioWaveformRenderableSeries.style.minimum = SCIGenericSwift(Float(0.0))
        audioWaveformRenderableSeries.style.maximum = SCIGenericSwift(Float(5.0))
        
        var grad: Array<Float> = [0.0, 0.3, 0.5, 0.7, 0.9, 1.0]
        var colors: Array<UInt32> = [0xFF000000, 0xFF520306, 0xFF8F2325, 0xFF68E615, 0xFF6FB9CC, 0xFF1128e6]
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
