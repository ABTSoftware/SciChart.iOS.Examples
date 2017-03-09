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
    
    @IBOutlet weak var ecgChartView: SCIChartSurfaceView!
    @IBOutlet weak var bloodPressureChartView: SCIChartSurfaceView!
    @IBOutlet weak var bloodVolumeChartView: SCIChartSurfaceView!
    @IBOutlet weak var bloodOxygenationChartView: SCIChartSurfaceView!
    
    @IBOutlet weak var heartBeatView: UIView!
    @IBOutlet weak var spo2PanelView: UIView!
    @IBOutlet weak var bloodPressureView: UIView!
    @IBOutlet weak var bloodVolumeView: UIView!
    
    var ecgController: ECGSurfaceController!
    var spo2Controller: SPO2ChartController!
    var bloodPreasureController: BloodPreasureChartController!
    var bloodVolumeController: BloodVolumeChartController!
    
    var heartRateController : HeartRateController!
    var spo2PanelController : SPO2PanelController!
    var bloodPressurePanelController : BloodPressurePanelController!
    var bloodVolumePanelController : BloodVolumePanelController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubViews()
        createSurfaceControllers()
    }
    
    private func createHeartBeatView() {
        let customView : MedicalHeartRateView = Bundle.main.loadNibNamed("MedicalHeartRateView", owner: self, options: nil)?[0] as! MedicalHeartRateView
        customView.translatesAutoresizingMaskIntoConstraints = false
        heartBeatView.addSubview(customView)
        
        let views = ["view": heartBeatView, "newView": customView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[newView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[newView]|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: views)
        
        heartBeatView.addConstraints(horizontalConstraints)
        heartBeatView.addConstraints(verticalConstraints)
        
        heartRateController = HeartRateController(customView)
    }
    
    private func createSPO2PanelView() {
        let customView : MedicalSPO2View = Bundle.main.loadNibNamed("MedicalSPO2View", owner: self, options: nil)?[0] as! MedicalSPO2View
        customView.translatesAutoresizingMaskIntoConstraints = false
        spo2PanelView.addSubview(customView)
        
        let views = ["view": spo2PanelView, "newView": customView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[newView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[newView]|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: views)
        
        spo2PanelView.addConstraints(horizontalConstraints)
        spo2PanelView.addConstraints(verticalConstraints)
        
        spo2PanelController = SPO2PanelController(customView)
    }
    
    private func createBloodPressurePanelView() {
        let customView : MedicalPressureView = Bundle.main.loadNibNamed("MedicalPressureView", owner: self, options: nil)?[0] as! MedicalPressureView
        customView.translatesAutoresizingMaskIntoConstraints = false
        bloodPressureView.addSubview(customView)
        
        let views = ["view": bloodPressureView, "newView": customView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[newView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[newView]|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: views)
        
        bloodPressureView.addConstraints(horizontalConstraints)
        bloodPressureView.addConstraints(verticalConstraints)
        
        bloodPressurePanelController = BloodPressurePanelController(customView)
    }
    
    private func createBloodVolumePanelView() {
        let customView : MedicalBloodVolumeView = Bundle.main.loadNibNamed("MedicalBloodVolumeView", owner: self, options: nil)?[0] as! MedicalBloodVolumeView
        customView.translatesAutoresizingMaskIntoConstraints = false
        bloodVolumeView.addSubview(customView)
        
        let views = ["view": bloodVolumeView, "newView": customView]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[newView]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[newView]|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: nil, views: views)
        
        bloodVolumeView.addConstraints(horizontalConstraints)
        bloodVolumeView.addConstraints(verticalConstraints)
        
        bloodVolumePanelController = BloodVolumePanelController(customView)
    }
    
    private func loadSubViews() {
        createHeartBeatView()
        createSPO2PanelView()
        createBloodPressurePanelView()
        createBloodVolumePanelView()
    }
    
    private func createSurfaceControllers() {
        ecgController = ECGSurfaceController(ecgChartView)
        spo2Controller = SPO2ChartController(view: bloodOxygenationChartView, panel: spo2PanelController)
        bloodPreasureController = BloodPreasureChartController(bloodPressureChartView)
        bloodVolumeController = BloodVolumeChartController(bloodVolumeChartView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        ecgController.viewWillAppear()
        spo2Controller.viewWillAppear()
        bloodPreasureController.viewWillAppear()
        bloodVolumeController.viewWillAppear()
        heartRateController.viewWillAppear()
        spo2PanelController.viewWillAppear()
        bloodPressurePanelController.viewWillAppear()
        bloodVolumePanelController.viewWillAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        ecgController.viewWillDissapear()
        spo2Controller.viewWillDissapear()
        bloodPreasureController.viewWillDissapear()
        bloodVolumeController.viewWillDissapear()
        heartRateController.viewWillDissapear()
        spo2PanelController.viewWillDissapear()
        bloodPressurePanelController.viewWillDissapear()
        bloodVolumePanelController.viewWillDissapear()
    }
}
