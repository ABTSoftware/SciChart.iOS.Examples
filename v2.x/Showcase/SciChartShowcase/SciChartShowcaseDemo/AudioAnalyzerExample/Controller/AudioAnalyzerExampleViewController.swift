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
    
    @IBOutlet weak var audioWaveFormChartView: SCIChartSurface!
    @IBOutlet weak var fftChartView: SCIChartSurface!
    @IBOutlet weak var spectrogramChartView: SCIChartSurface!
    
    var imageAudioWave: UIImage?
    
    let audioRecorderDataManager:AudioRecorder = AudioRecorder()
   
    override func viewDidLoad() {

        super.viewDidLoad()
        createSurfaceControllers()
        subscribeSurfaceDelegates()
        audioRecorderDataManager.startRecording()
        
        displaylink = CADisplayLink(target: self, selector: #selector(updateData))
        displaylink.add(to: .current, forMode: .defaultRunLoopMode)

        let barButton = UIBarButtonItem(title: "FFT Settings", style: .plain, target: self, action: #selector(changeMaxHzFft))
        navigationItem.setRightBarButton(barButton, animated: true)
    }

    @IBAction func changeMaxHzFft(_ sender: UIBarButtonItem) {

        let alertController = UIAlertController(title: "Select Max Hz For", message: "", preferredStyle: .actionSheet)
        let varies = ["22 kHz", "10 kHz", "5 kHz", "1 kHz"]
        for i in 0..<4 {
            let title = varies[i]
            let actionTheme = UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) -> Void in
                if i == 0 {
                    self.fftFormController.setMaxHz(maxValue: 22000)
                }
                if i == 1 {
                    self.fftFormController.setMaxHz(maxValue: 10000)
                }
                if i == 2 {
                    self.fftFormController.setMaxHz(maxValue: 5000)
                }
                if i == 3 {
                    self.fftFormController.setMaxHz(maxValue: 1000)
                }
            })
            alertController.addAction(actionTheme)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let controller = alertController.popoverPresentationController {
            controller.sourceView = view
            controller.barButtonItem = sender
        }
        
        navigationController?.present(alertController, animated: true, completion: nil)
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
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
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
