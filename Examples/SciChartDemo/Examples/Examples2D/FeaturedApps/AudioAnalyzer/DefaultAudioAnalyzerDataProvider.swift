//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DefaultAudioAnalyzerDataProvider.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

struct AudioData {
    let pointsCount: Int
    let xData: SCILongValues
    let yData: SCIIntegerValues
    let fftData: SCIFloatValues
    
    init(pointsCount: Int) {
        self.pointsCount = pointsCount
        self.xData = SCILongValues(capacity: pointsCount)
        self.yData = SCIIntegerValues(capacity: pointsCount)
        self.fftData = SCIFloatValues(capacity: 1024)
    }
}

protocol IAudioAnalyzerDataProvider where Self: DataProviderBase<AudioData> {
    var bufferSize: Int { get }
    var sampleRate: Int { get }
}

class DefaultAudioAnalyzerDataProvider: DataProviderBase<AudioData>, IAudioAnalyzerDataProvider {
    
    let bufferSize: Int
    let sampleRate: Int
    private var time = 0
    
    private lazy var audioData: AudioData = {
        return AudioData(pointsCount: bufferSize)
    }()
        
    private let audioRecorder: AudioRecorder = AudioRecorder()
    
    var samplesValues: samplesToEngine!
    var fftValues: samplesToEngineFloat!
    
    convenience init() {
        self.init(sampleRate: 44100, minBufferSize: 2048)
    }
    
    init(sampleRate: Int, minBufferSize: Int) {
        self.sampleRate = sampleRate
        self.bufferSize = minBufferSize

        super.init(dispatchTimeInterval: .milliseconds(sampleRate / minBufferSize))
    }
    
    override func onStart() {
        audioRecorder.startRecording(Int32(sampleRate), andMinBufferSize: Int32(bufferSize))
    }
    
    override func onStop() {
        audioRecorder.stopRecording()
    }
    
    override func onNext() -> AudioData {
        audioData.xData.clear()
        audioData.yData.clear()
        audioData.fftData.clear()
        
        for _ in 0 ..< bufferSize {
            time += 1
            audioData.xData.add(Int64(time))
        }
        
        if let samples = audioRecorder.samples {
            let sampleValues = Array(UnsafeBufferPointer(start: samples, count: bufferSize)).map { Int($0) }
            audioData.yData.add(values: sampleValues)
        }
        
        if let fftData = audioRecorder.fftData {
            let fftValues = Array(UnsafeBufferPointer(start: fftData, count: bufferSize))
                        
            audioData.fftData.add(values: fftValues)
        }
        return audioData
    }
}
