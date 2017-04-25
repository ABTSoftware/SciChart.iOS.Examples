//
//  SPO2PanelController.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class SPO2PanelController {
    var view : SPO2View! = nil
    var timeIntervalSecond = 0.0
    
    init(_ view: SPO2View) {
        self.view = view
    }
    
    @objc func onTimerElapsed(timeInterval: Double) {
        if (view == nil || timeIntervalSecond <= 1.0) {
            timeIntervalSecond += timeInterval
            return
        }
        timeIntervalSecond = 0.0
        view.updateTime(date: Date())
    }
    
    func updateSPO2Value(value : Int) {
        view.updateValue(value: value)
    }

}
