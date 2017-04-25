//
//  BloodVolumePanelControl.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 01/03/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class BloodVolumePanelController {
    var view : BloodVolumeView! = nil
    var twoSeconds = 0.0
    
    init(_ view: BloodVolumeView) {
        self.view = view
    }
    
    @objc func onTimerElapsed(timeInterval: Double) {
        if (view == nil || twoSeconds <= 2.0) {
            twoSeconds += timeInterval;
            return
        }
        twoSeconds = 0.0;
        
        let randomVolume: Float = Float(arc4random_uniform(10))/10 + 13
        view.updateVolume(volume: randomVolume)
        
        let randomRRBars: Int = Int(arc4random_uniform(4)) + 8
        view.updateRRBars(value: randomRRBars)
        let randomRPMBars: Int = randomRRBars + 4 - Int(arc4random_uniform(2))
        view.updateRPRBars(value: randomRPMBars)
    }
}
