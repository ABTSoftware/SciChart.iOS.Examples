//
//  HeartRateController.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class HeartRateController: NSObject {

    var view : MedicalHeartRateView! = nil
    var _timer : Timer! = nil
    var heartRateCurrent : Float = 70.0
    var heartRateMinLimit : Float = 68.0
    var heartRateMaxLimit : Float = 71.0
    var heartRateChangeStep : Float = 0.3
    
    init(_ view: MedicalHeartRateView) {
        self.view = view
    }
    
    func viewWillAppear() {
        _timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerElapsed), userInfo: nil, repeats: true)
        heartRateCurrent = 70.0
        heartRateChangeStep = -0.3
    }
    
    func viewWillDissapear() {
        _timer.invalidate()
    }
    
    @objc func onTimerElapsed() {
        if (view == nil) {
            return
        }
        heartRateCurrent += heartRateChangeStep
        if (heartRateCurrent > heartRateMaxLimit) {
            heartRateChangeStep = -heartRateChangeStep
        }
        if (heartRateCurrent < heartRateMinLimit) {
            heartRateChangeStep = -heartRateChangeStep
        }
        view.updateValue(value: Int(heartRateCurrent))
    }
}
