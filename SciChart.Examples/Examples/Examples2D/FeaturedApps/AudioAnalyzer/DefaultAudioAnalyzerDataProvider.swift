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

class DefaultAudioAnalyzerDataProvider: DataProviderBase<AudioData>, IAudioAnalyzerDataProvider {
    
    let bufferSize: Int
    let sampleRate: Int
    private var time: Int64 = 0
    
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
        
        if let samples = audioRecorder.samples {
            let sequence = time ..< time + Int64(bufferSize)
            audioData.xData.add(sequence)
            audioData.yData.addValues(samples, count: bufferSize)
            time += Int64(bufferSize)
        }

        audioData.yData.withUnsafeMutablePointer { [weak self] pointer in
            let fftData: UnsafeMutablePointer<Float>! = self?.audioRecorder.calculateFFT(pointer, size: UInt32(bufferSize))
            audioData.fftData.addValues(fftData, count: bufferSize)
        }
        
        return audioData
    }
}
