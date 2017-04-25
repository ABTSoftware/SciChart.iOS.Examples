//
//  ECGSurfaceController.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybenuik Mykola on 2/23/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class ECGChartController: BaseChartSurfaceController {
    
    let wave1 : SCIFastLineRenderableSeries! = SCIFastLineRenderableSeries()
    let wave2 : SCIFastLineRenderableSeries! = SCIFastLineRenderableSeries()
    
    let data1 : SCIXyDataSeries! = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .fifo)
    let data2 : SCIXyDataSeries! = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .fifo)
    
    var newWave : SCIRenderableSeriesProtocol! = nil
    var oldWave : SCIRenderableSeriesProtocol! = nil
    
    var ecgData : SCIDataSeriesProtocol! = nil
    
    var _currentDataIndex : Int32 = 0
    var _totalDataIndex : Int32 = 0
    
    let seriesColor : UIColor! = UIColor.green
    let stroke : Float = 1.0
    var fadeOutPalette : SwipingChartFadeOutPalette! = nil
    var objcFadeOutPalette : MedicalFadeOutPaletteProvider! = nil
    
    let fifoSize : Int32 = 4600
    let dataSize : Int32 = 5000
    
    override init(_ view: SCIChartSurfaceView) {
        super.init(view)
        objcFadeOutPalette = MedicalFadeOutPaletteProvider(seriesColor: seriesColor, stroke: stroke)
        
        chartSurface.style.bottomAxisAreaSize = 0.0
        chartSurface.style.topAxisAreaSize = 0.0
        chartSurface.style.leftAxisAreaSize = 0.0
        chartSurface.style.rightAxisAreaSize = 0.0
//        fadeOutPalette = SwipingChartFadeOutPalette(seriesColor: seriesColor, stroke: stroke)
        let lineStyle : SCILineSeriesStyle = SCILineSeriesStyle()
        let linePen : SCIPenStyle = SCISolidPenStyle(color: seriesColor, withThickness: stroke)
        lineStyle.linePen = linePen
        
        wave1.style = lineStyle
        wave2.style = lineStyle
        
        data1.fifoCapacity = fifoSize
        data2.fifoCapacity = fifoSize
        
        wave1.dataSeries = data1
        wave2.dataSeries = data2
        
        wave1.paletteProvider = objcFadeOutPalette
        wave2.paletteProvider = objcFadeOutPalette
        
        var axisStyle = SCIAxisStyle()
        axisStyle.drawLabels = false
        axisStyle.drawMajorBands = false
        axisStyle.drawMinorGridLines = false
        axisStyle.drawMinorTicks = false
        
        let xAxis : SCINumericAxis = SCINumericAxis()
        xAxis.style = axisStyle
        xAxis.autoRange = .never
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(10))
//        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.05), max: SCIGeneric(0.05))
        
        axisStyle = SCIAxisStyle()
        axisStyle.drawLabels = false
        axisStyle.drawMajorBands = false
        axisStyle.drawMinorGridLines = false
        axisStyle.drawMinorTicks = false
        axisStyle.drawMajorTicks = false
        axisStyle.drawMajorGridLines = false
        let yAxis : SCINumericAxis = SCINumericAxis()
        yAxis.style = axisStyle
        yAxis.autoRange = .never
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(0.78), max: SCIGeneric(0.95))
//        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.05), max: SCIGeneric(0.05))
        
        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(yAxis)
        chartSurface.renderableSeries.add(wave1)
        chartSurface.renderableSeries.add(wave2)
        
        newWave = wave1
        oldWave = wave2
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            DataManager.getHeartRateData { (dataSeries: SCIDataSeriesProtocol) in
                self.ecgData = dataSeries
            }
        })
    }
    
    @objc func onTimerElapsed(timeInterval: Double) {
        if (ecgData == nil) { return }
        let sampleRate : Double = 400;
        
        let countOfPoints = Int(400*timeInterval);
        
        for _ in 0...countOfPoints {
            appendPoint(sampleRate)
        }
    }
    
    func appendPoint(_ sampleRate : Double) {
        if (_currentDataIndex >= dataSize) {
            _currentDataIndex = 0;
        }
        
        let value : Double = SCIGenericDouble( ecgData.yValues().value(at: _currentDataIndex) )
        let time : Double = 10 * (Double(_currentDataIndex) / Double(dataSize))
        
        newWave.dataSeries.appendX(SCIGenericSwift(time), y: SCIGenericSwift(value))
        oldWave.dataSeries.appendX(SCIGenericSwift(time), y: SCIGenericSwift(Double.nan))
        
        _currentDataIndex += 1
        _totalDataIndex += 1
        
        if (_totalDataIndex % dataSize == 0) {
            let swap = oldWave
            oldWave = newWave
            newWave = swap
        }
        
        chartSurface.invalidateElement()
    }
    
}
