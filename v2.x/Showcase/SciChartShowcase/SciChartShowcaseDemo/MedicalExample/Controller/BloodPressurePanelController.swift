//
//  BloodPressurePanelController.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class BloodPressurePanelController: NSObject {
    var view : MedicalPressureView! = nil
    var _timer : Timer! = nil
    
    var bloodHighCurrent : Float = 115.0
    var bloodHighMin : Float = 114.0
    var bloodHighMax : Float = 118.0
    var bloodHighStep : Float = 0.7
    
    var bloodLowCurrent : Float = 70.0
    var bloodLowMin : Float = 70.0
    var bloodLowMax : Float = 75.0
    var bloodLowStep : Float = 0.3
    
    init(_ view: MedicalPressureView) {
        self.view = view
    }
    
    func viewWillAppear() {
        _timer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: #selector(onTimerElapsed), userInfo: nil, repeats: true)
    }
    
    func viewWillDissapear() {
        _timer.invalidate()
    }
    
    @objc func onTimerElapsed() {
        if (view == nil) {
            return
        }
        
        bloodHighCurrent += bloodHighStep
        if (bloodHighCurrent > bloodHighMax) || (bloodHighCurrent < bloodHighMin) {
            bloodHighStep = -bloodHighStep
        }
        bloodLowCurrent += bloodLowStep
        if (bloodLowCurrent > bloodLowMax) || (bloodLowCurrent < bloodLowMin) {
            bloodLowStep = -bloodLowStep
        }
        
        view.updateBloodPressure(high: Int(bloodHighCurrent), low: Int(bloodLowCurrent))
        
        let randomNum: Int = Int(arc4random_uniform(35))
        view.updateBars(percentage: 40 + randomNum)
    }
}
