//
//  SPO2PanelController.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class SPO2PanelController: NSObject {
    var view : MedicalSPO2View! = nil
    var _timer : Timer! = nil
    
    init(_ view: MedicalSPO2View) {
        self.view = view
    }
    
    func viewWillAppear() {
        _timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(onTimerElapsed), userInfo: nil, repeats: true)
    }
    
    func viewWillDissapear() {
        _timer.invalidate()
    }
    
    @objc func onTimerElapsed() {
        if (view == nil) {
            return
        }
        view.updateTime(date: Date())
    }
    
    func updateSPO2Value(value : Int) {
        view.updateValue(value: value)
    }

}
