//
//  HeartRateController.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class HeartRateController {

    var view : HeartRateView! = nil
    var heartRateCurrent : Float = 70.0
    var heartRateMinLimit : Float = 68.0
    var heartRateMaxLimit : Float = 71.0
    var heartRateChangeStep : Float = 0.3
    var timeIntervalSecond = 0.0
    
    init(_ view: HeartRateView) {
        self.view = view
    }

    @objc func onTimerElapsed(timeInterval: Double) {
        if (view == nil || timeIntervalSecond <= 1.0) {
            timeIntervalSecond += timeInterval
            return
        }
        timeIntervalSecond = 0.0
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
