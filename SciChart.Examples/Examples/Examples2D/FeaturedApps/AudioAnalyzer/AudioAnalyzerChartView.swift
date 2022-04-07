//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AudioAnalyzerChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation
import RxSwift

class AudioAnalyzerChartView: SCDAudioAnalyzerLayoutViewController {
    
    private let AUDIO_STREAM_BUFFER_SIZE: Int = 500000
    private let MAX_FREQUENCY: Int = 10000
    private let minDB: Double = -30
    private let maxDB: Double = 70
    
    private var bufferSize: Int {
        return dataProvider.bufferSize
    }
    
    private var sampleRate: Int {
        return dataProvider.sampleRate
    }
    
    private var hzPerDataPoint: Int {
        return sampleRate / bufferSize
    }
    
    private var fftCount: Int {
        return AUDIO_STREAM_BUFFER_SIZE / bufferSize
    }
    
    private var fftSize: Int {
        return MAX_FREQUENCY / hzPerDataPoint
    }
    
    private var fftValuesCount: Int {
        return fftSize * fftCount
    }
    
    private var dataProvider: IAudioAnalyzerDataProvider!
    private var audioDS: SCIXyDataSeries!
    private var fftDS: SCIXyDataSeries!
    private var spectrogramDS: SCIUniformHeatmapDataSeries!
    private var spectogramValues: SCDSpectogramItems!
    private var disposable: Disposable?
        
    deinit {
        disposable?.dispose()
    }
    
    override func initExample() {
        
        SCDPermissionRequestHelper.requestPermission { [weak self] granted in
            if granted {
                self?.dataProvider = DefaultAudioAnalyzerDataProvider()
            } else {
                self?.dataProvider = StubAudioAnalyzerDataProvider()
            }
            DispatchQueue.main.async { [weak self] in
                self?.proceedWithInit()
            }
        }
    }
    
    private func proceedWithInit() {
        audioDS = SCIXyDataSeries(xType: .long, yType: .int)
        fftDS = SCIXyDataSeries(xType: .double, yType: .float)
        spectrogramDS = SCIUniformHeatmapDataSeries(xType: .long, yType: .long, zType: .float, xSize: fftSize, ySize: fftCount)
        
        initAudioStreamChart()
        initFFTChart()
        initSpectrogramChart()
            
        disposable = dataProvider
            .getData()
            .do(onNext: { [weak self] audioData in
                guard let self = self else { return }
                
                self.audioDS.append(x: audioData.xData, y: audioData.yData)
                
                let fftData = audioData.fftData
                fftData.count = self.fftSize
                self.fftDS.update(y: fftData, at: 0)
                
                self.spectogramValues.replace(withNewItems: fftData)
                self.spectrogramDS.update(z: self.spectogramValues.values)
            })
            .subscribe()
    }
    
    private func initAudioStreamChart() {
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        xAxis.drawLabels = false
        xAxis.drawMinorTicks = false
        xAxis.drawMajorTicks = false
        xAxis.drawMajorBands = false
        xAxis.drawMinorGridLines = false
        xAxis.drawMajorGridLines = false
        
        let yAxis = SCINumericAxis()
        yAxis.visibleRange = SCIDoubleRange(min: Double(Int32.min), max: Double(Int32.max))
        yAxis.drawLabels = false
        yAxis.drawMinorTicks = false
        yAxis.drawMajorTicks = false
        yAxis.drawMajorBands = false
        yAxis.drawMinorGridLines = false
        yAxis.drawMajorGridLines = false
        
        audioDS.fifoCapacity = AUDIO_STREAM_BUFFER_SIZE
        
        let rSeries = SCIFastLineRenderableSeries()
        rSeries.dataSeries = audioDS
        rSeries.strokeStyle = SCISolidPenStyle(color: .gray, thickness: 1.0)
        
        SCIUpdateSuspender.usingWith(audioStreamChart) {
            self.audioStreamChart.xAxes.add(items: xAxis)
            self.audioStreamChart.yAxes.add(items: yAxis)
            self.audioStreamChart.renderableSeries.add(items: rSeries)
        }
    }
    
    private func initFFTChart() {
        let xAxis = SCINumericAxis()
        xAxis.drawMajorBands = false
        xAxis.drawMinorGridLines = false
        xAxis.maxAutoTicks = 5
        xAxis.axisTitle = "Hz"
        xAxis.axisTitlePlacement = .right
        xAxis.axisTitleOrientation = .horizontal
        
        let yAxis = SCINumericAxis()
        yAxis.axisAlignment = .left
        yAxis.visibleRange = SCIDoubleRange(min: minDB, max: maxDB)
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.drawMinorTicks = false
        yAxis.drawMinorGridLines = false
        yAxis.drawMajorBands = false
        yAxis.axisTitle = "dB"
        yAxis.axisTitlePlacement = .top
        yAxis.axisTitleOrientation = .horizontal
        
        fftDS.fifoCapacity = fftSize
        for i in 0 ..< fftSize {
            fftDS.append(x: i * Int(hzPerDataPoint), y: Float.nan)
        }
        
        let rSeries = SCIFastColumnRenderableSeries()
        rSeries.dataSeries = fftDS
        rSeries.zeroLineY = minDB
        rSeries.paletteProvider = FFTPaletteProvider()
        
        SCIUpdateSuspender.usingWith(fftChart) {
            self.fftChart.xAxes.add(items: xAxis)
            self.fftChart.yAxes.add(items: yAxis)
            self.fftChart.renderableSeries.add(rSeries)
        }
    }
    
    private func initSpectrogramChart() {
        
        spectogramValues = SCDSpectogramItems(capacity: fftValuesCount)
        
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .always
        xAxis.drawLabels = false
        xAxis.drawMinorTicks = false
        xAxis.drawMajorTicks = false
        xAxis.drawMajorBands = false
        xAxis.drawMinorGridLines = false
        xAxis.drawMajorGridLines = false
        xAxis.axisAlignment = .left
        xAxis.flipCoordinates = true
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        yAxis.drawLabels = false
        yAxis.drawMinorTicks = false
        yAxis.drawMajorTicks = false
        yAxis.drawMajorBands = false
        yAxis.drawMinorGridLines = false
        yAxis.drawMajorGridLines = false
        yAxis.axisAlignment = .bottom
        
        let rSeries = SCIFastUniformHeatmapRenderableSeries()
        rSeries.dataSeries = spectrogramDS
        rSeries.minimum = minDB
        rSeries.maximum = maxDB
        
        rSeries.colorMap = SCIColorMap(colors: [.clear, SCIColor.fromARGBColorCode(0xFF00008B), .purple, .red, .yellow, .white], andStops: [0, 0.0001, 0.25, 0.50, 0.75, 1])
        
        SCIUpdateSuspender.usingWith(spectrogramChart) {
            self.spectrogramChart.xAxes.add(xAxis)
            self.spectrogramChart.yAxes.add(yAxis)
            self.spectrogramChart.renderableSeries.add(rSeries)
        }
    }
}
