//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// StubAudioAnalyzerDataProvider.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

class StubAudioAnalyzerDataProvider: DataProviderBase<AudioData>, IAudioAnalyzerDataProvider {
    
    let bufferSize: Int = 2048
    let sampleRate: Int = 44100
    private var time: Int64 = 0
    
    init() {
        super.init(dispatchTimeInterval: .milliseconds(20))
    }
    
    private let audioRecorder: AudioRecorder = AudioRecorder()
    
    private lazy var audioData: AudioData = {
        return AudioData(pointsCount: bufferSize)
    }()
    
    private lazy var provider: IYValuesProvider = {
        let providers: [IYValuesProvider] = [
            FrequencySinewaveYValueProvider(amplitude: 8000, phase: 0, minFrequency: 0, maxFrequency: 1, step: 0.0000005),
            NoisySinewaveYValueProvider(amplitude: 8000, phase: 0, frequency: 0.000032, noiseAmplitude: 200),
            NoisySinewaveYValueProvider(amplitude: 6000, phase: 0, frequency: 0.000016, noiseAmplitude: 100),
            NoisySinewaveYValueProvider(amplitude: 4000, phase: 0, frequency: 0.000064, noiseAmplitude: 100)
        ]
        return AggregateYValueProvider(providers: providers)
    }()
    
    override func onNext() -> AudioData {
        audioData.xData.clear()
        audioData.yData.clear()
        audioData.fftData.clear()
        
        for _ in 0 ..< bufferSize {
            audioData.xData.add(Int64(time))
            audioData.yData.add(provider.getYValueForIndex(Int(time)))
            time += 1
        }
        
        audioData.yData.withUnsafeMutablePointer { [weak self] pointer in
            let fftData: UnsafeMutablePointer<Float>! = self?.audioRecorder.calculateFFT(pointer, size: UInt32(bufferSize))
            audioData.fftData.addValues(fftData, count: bufferSize)
        }
        
        return audioData
    }
}

protocol IYValuesProvider {
    func getYValueForIndex(_ index: Int) -> Int32
}

class AggregateYValueProvider: IYValuesProvider {
    let providers: [IYValuesProvider]
    
    init(providers: [IYValuesProvider]) {
        self.providers = providers
    }
    
    func getYValueForIndex(_ index: Int) -> Int32 {
        var sum: Int32 = 0
        for provider in providers {
            sum += provider.getYValueForIndex(index) * 30000
        }
        return sum
    }
}

class FrequencySinewaveYValueProvider: IYValuesProvider {
    private let amplitude: Double
    private let phase: Double
    private let minFrequency: Double
    private let maxFrequency: Double
    private let step: Double
    
    private var frequency: Double
    
    init(amplitude: Double, phase: Double, minFrequency: Double, maxFrequency: Double, step: Double) {
        self.amplitude = amplitude
        self.phase = phase
        self.minFrequency = minFrequency
        self.maxFrequency = maxFrequency
        self.step = step
        
        self.frequency = minFrequency
    }
    
    func getYValueForIndex(_ index: Int) -> Int32 {
        frequency = frequency <= maxFrequency ? frequency + step : minFrequency
        let wn = 2 * Double.pi * frequency
        return Int32(amplitude * sin(Double(index) * wn + phase))
    }
}

class NoisySinewaveYValueProvider: IYValuesProvider {
    private let amplitude: Double
    private let phase: Double
    private let noiseAmplitude: Double
    private let wn: Double
    
    init(amplitude: Double, phase: Double, frequency: Double, noiseAmplitude: Double) {
        self.amplitude = amplitude
        self.phase = phase
        self.noiseAmplitude = noiseAmplitude
        self.wn = 2 * Double.pi * frequency
    }
    
    func getYValueForIndex(_ index: Int) -> Int32 {
        return Int32(amplitude * sin(Double(index) * wn + phase) + (Double.random(in: 0 ..< 1) - 0.5) * noiseAmplitude)
    }
}
