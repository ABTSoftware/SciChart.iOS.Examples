//
//  MedicalExampleViewController.swift
//  SciChartShowcaseDemo
//
//  Created by Mykola Hrybeniuk on 2/23/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import UIKit
import SciChart

class MedicalExampleViewController: BaseViewController  {
    
    @IBOutlet weak var ecgChartView: SCIChartSurface!
    @IBOutlet weak var bloodPressureChartView: SCIChartSurface!
    @IBOutlet weak var bloodVolumeChartView: SCIChartSurface!
    @IBOutlet weak var bloodOxygenationChartView: SCIChartSurface!
    
    @IBOutlet weak var heartBeatView: HeartRateView!
    @IBOutlet weak var spo2PanelView: SPO2View!
    @IBOutlet weak var bloodPressureView: BloodPressureView!
    @IBOutlet weak var bloodVolumeView: BloodVolumeView!
    
    var ecgController: ECGChartController!
    var spo2Controller: SPO2ChartController!
    var bloodPreasureController: BloodPreasureChartController!
    var bloodVolumeController: BloodVolumeChartController!
    
    var heartRateController : HeartRateController!
    var spo2PanelController : SPO2PanelController!
    var bloodPressurePanelController : BloodPressurePanelController!
    var bloodVolumePanelController : BloodVolumePanelController!
    
    var displaylink : CADisplayLink!
    var lastTimestamp : Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSurfaceControllers()
        displaylink = CADisplayLink(target: self, selector: #selector(updateData))
        displaylink.add(to: .current, forMode: .defaultRunLoopMode)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        displaylink.invalidate()
        displaylink = nil
    }
    
    @objc func updateData(displayLink: CADisplayLink) {
        
        var diffTimeStamp = displayLink.timestamp - lastTimestamp
        if lastTimestamp == 0 {
            diffTimeStamp = displayLink.duration
        }
        
        //Charts Update
        ecgController.onTimerElapsed(timeInterval: diffTimeStamp)
        bloodPreasureController.onTimerElapsed(timeInterval: diffTimeStamp)
        bloodVolumeController.onTimerElapsed(timeInterval: diffTimeStamp)
        spo2Controller.onTimerElapsed(timeInterval: diffTimeStamp)
        
        //Panels Update
        heartRateController.onTimerElapsed(timeInterval: diffTimeStamp)
        bloodPressurePanelController.onTimerElapsed(timeInterval: diffTimeStamp)
        bloodVolumePanelController.onTimerElapsed(timeInterval: diffTimeStamp)
        spo2PanelController.onTimerElapsed(timeInterval: diffTimeStamp)
        
        lastTimestamp = displayLink.timestamp
    }
    
    private func createSurfaceControllers() {
        
        //Panels
        heartRateController = HeartRateController(heartBeatView)
        bloodVolumePanelController = BloodVolumePanelController(bloodVolumeView)
        spo2PanelController = SPO2PanelController(spo2PanelView)
        bloodPressurePanelController = BloodPressurePanelController(bloodPressureView)
        
        //Charts
        ecgController = ECGChartController(ecgChartView)
        spo2Controller = SPO2ChartController(view: bloodOxygenationChartView, panel: spo2PanelController)
        bloodPreasureController = BloodPreasureChartController(bloodPressureChartView)
        bloodVolumeController = BloodVolumeChartController(bloodVolumeChartView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }

}
