//
//  BloodVolumePanelControl.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 01/03/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class BloodVolumePanelController: NSObject {
    var view : MedicalBloodVolumeView! = nil
    var _timer : Timer! = nil
    
    init(_ view: MedicalBloodVolumeView) {
        self.view = view
    }
    
    func viewWillAppear() {
        _timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(onTimerElapsed), userInfo: nil, repeats: true)
    }
    
    func viewWillDissapear() {
        _timer.invalidate()
    }
    
    @objc func onTimerElapsed() {
        if (view == nil) {
            return
        }
        
        let randomVolume: Float = Float(arc4random_uniform(10))/10 + 13
        view.updateVolume(volume: randomVolume)
        
        let randomRRBars: Int = Int(arc4random_uniform(4)) + 8
        view.updateRRBars(value: randomRRBars)
        let randomRPMBars: Int = randomRRBars + 4 - Int(arc4random_uniform(2))
        view.updateRPRBars(value: randomRPMBars)
    }
}
