//
//  BloodPressurePanelController.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class BloodPressurePanelController {
    var view : BloodPressureView! = nil
    
    var bloodHighCurrent : Float = 115.0
    var bloodHighMin : Float = 114.0
    var bloodHighMax : Float = 118.0
    var bloodHighStep : Float = 0.7
    
    var bloodLowCurrent : Float = 70.0
    var bloodLowMin : Float = 70.0
    var bloodLowMax : Float = 75.0
    var bloodLowStep : Float = 0.3
    
    var timeIntervalUpdate = 0.0
    
    init(_ view: BloodPressureView) {
        self.view = view
    }
    
    @objc func onTimerElapsed(timeInterval: Double) {
        if (view == nil || timeIntervalUpdate <= 1.5) {
            timeIntervalUpdate += timeInterval
            return
        }
        
        timeIntervalUpdate = 0.0
        
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
