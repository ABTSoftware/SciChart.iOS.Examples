//
//  SPO2ChartController.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 26/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class SPO2ChartController: BaseChartSurfaceController {
    
    let wave1 : SCIFastLineRenderableSeries! = SCIFastLineRenderableSeries()
    let wave2 : SCIFastLineRenderableSeries! = SCIFastLineRenderableSeries()
    
    let data1 : SCIXyDataSeries! = SCIXyDataSeries(xType: .double, yType: .double)
    let data2 : SCIXyDataSeries! = SCIXyDataSeries(xType: .double, yType: .double)
    
    var newWave : SCIRenderableSeriesProtocol! = nil
    var oldWave : SCIRenderableSeriesProtocol! = nil
    
    var spo2Data : SCIDataSeriesProtocol! = nil
    
    var _currentDataIndex : Int32 = 0
    var _totalDataIndex : Int32 = 0
    
    let seriesColor : UIColor! = UIColor.fromARGBColorCode(0xff66CCFF)
    let stroke : Float = 1.0
    var fadeOutPalette : SwipingChartFadeOutPalette! = nil
    var objcFadeOutPalette : MedicalFadeOutPaletteProvider! = nil
    
    let fifoSize : Int32 = 4600
    let dataSize : Int32 = 5000
    
    var spo2Panel : SPO2PanelController

    init(view: SCIChartSurface, panel : SPO2PanelController) {
        
        spo2Panel = panel
        
        super.init(view)
        
        objcFadeOutPalette = MedicalFadeOutPaletteProvider(seriesColor: seriesColor, stroke: stroke)
//        fadeOutPalette = SwipingChartFadeOutPalette(seriesColor: seriesColor, stroke: stroke)
        
        let lineStyle : SCILineSeriesStyle = SCILineSeriesStyle()
        let linePen : SCIPenStyle = SCISolidPenStyle(color: seriesColor, withThickness: stroke)
        lineStyle.strokeStyle = linePen
        
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
        yAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(0.02), max: SCIGeneric(0.145))
        
        chartSurface.xAxes.add(xAxis)
        chartSurface.yAxes.add(yAxis)
        chartSurface.renderableSeries.add(wave1)
        chartSurface.renderableSeries.add(wave2)
        
        newWave = wave1
        oldWave = wave2
        
        chartSurface.bottomAxisAreaForcedSize = 0.0
        chartSurface.topAxisAreaForcedSize = 0.0
        chartSurface.leftAxisAreaForcedSize = 0.0
        chartSurface.rightAxisAreaForcedSize = 0.0
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            DataManager.getBloodOxygenationData { (dataSeries: SCIDataSeriesProtocol, errorMessage) in
                self.spo2Data = dataSeries
            }
        })
    }
    
    @objc func onTimerElapsed(timeInterval: Double) {
        if (spo2Data == nil) { return }
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
        
        let value : Double = SCIGenericDouble( spo2Data.yValues().value(at: _currentDataIndex) )
        let time : Double = 10 * (Double(_currentDataIndex) / Double(dataSize))
        
        let valueRange : Double = 0.145 - 0.02
        let valueRelative : Double = (100 * (value - 0.02) / valueRange) / 20 + 95
        
        spo2Panel.updateSPO2Value(value: Int(valueRelative))
        
        (newWave.dataSeries as! SCIXyDataSeries).appendX(SCIGeneric(time), y: SCIGeneric(value))
        (oldWave.dataSeries as! SCIXyDataSeries).appendX(SCIGeneric(time), y: SCIGeneric(Double.nan))
        
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
