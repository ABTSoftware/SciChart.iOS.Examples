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
    
    var displaylink : CADisplayLink!
    
    @IBOutlet weak var audioWaveFormChartView: SCIChartSurfaceView!
    @IBOutlet weak var fftChartView: SCIChartSurfaceView!
    @IBOutlet weak var spectrogramChartView: SCIChartSurfaceView!
    
    var imageAudioWave: UIImage?
    
    let audioRecorderDataManager:AudioRecorder = AudioRecorder()
   
    override func viewDidLoad() {

        super.viewDidLoad()
        createSurfaceControllers()
        subscribeSurfaceDelegates()
        audioRecorderDataManager.startRecording()
        
        displaylink = CADisplayLink(target: self, selector: #selector(updateData))
        displaylink.add(to: .current, forMode: .defaultRunLoopMode)

//        let barButton = UIBarButtonItem(title: "Screenshot", style: .plain, target: self, action: #selector(makeScreenshot))
//        navigationItem.setRightBarButton(barButton, animated: true)
    }
    
    @objc func updateData(displayLink: CADisplayLink) {
        audioWaveformController.updateData(displayLink: displayLink)
        fftFormController.updateData(displayLink: displayLink)
        spectrogramFormController.updateData(displayLink: displayLink)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func makeScreenshot() {

        UIImageWriteToSavedPhotosAlbum(audioWaveformController.chartSurface.exportToUIImage(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        UIImageWriteToSavedPhotosAlbum(fftFormController.chartSurface.exportToUIImage(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        UIImageWriteToSavedPhotosAlbum(spectrogramFormController.chartSurface.exportToUIImage(), self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)

    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioRecorderDataManager.stopRecording()
        displaylink.invalidate()
        displaylink = nil
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
