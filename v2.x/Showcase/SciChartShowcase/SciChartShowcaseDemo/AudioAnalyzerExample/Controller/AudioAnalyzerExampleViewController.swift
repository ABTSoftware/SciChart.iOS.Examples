//
//  AudioAnalyzerExampleViewController.swift
//  SciChartShowcaseDemo
//
//  Created by Yaroslav Pelyukh on 2/26/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import UIKit
import SciChart

//typealias updateDataSeriesDelegate = (_ dataSeries: SCIXyDataSeries ) -> Void

class AudioAnalyzerExampleViewController: BaseViewController  {
    
    var audioWaveformController: AudioWaveformSurfaceController!
    var fftFormController: FFTFormSurfaceController!
    var spectrogramFormController: SpectogramSurfaceController!
    
    @IBOutlet weak var audioWaveFormChartView: SCIChartSurfaceView!
    @IBOutlet weak var fftChartView: SCIChartSurfaceView!
    @IBOutlet weak var spectrogramChartView: SCIChartSurfaceView!
    
    let audioRecorderDataManager:AudioRecorder = AudioRecorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSurfaceControllers()
        subscribeSurfaceDelegates()
        
        audioRecorderDataManager.startRecording()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioRecorderDataManager.stopRecording()
    }
    
    private func createSurfaceControllers() {
        audioWaveformController = AudioWaveformSurfaceController(audioWaveFormChartView)
        fftFormController = FFTFormSurfaceController(fftChartView)
        spectrogramFormController = SpectogramSurfaceController(spectrogramChartView)
    }
    
    private func subscribeSurfaceDelegates(){
        audioRecorderDataManager.sampleToEngineDelegate = audioWaveformController.updateDataSeries
        audioRecorderDataManager.fftSamplesDelegate = fftFormController.updateDataSeries
        audioRecorderDataManager.spectrogramSamplesDelegate = spectrogramFormController.updateDataSeries
    }
    
    
}
