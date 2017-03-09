//
//  SCSRealTimeTickingStocksControlPanelView.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 24/09/2016.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import UIKit

typealias Callback = (_ sender: UIButton) -> Void

class SCSRealTimeTickingStocksControlPanelView: UIView {
    var seriesTypeTouched: Callback!
    var pauseTickingTouched: Callback!
    var continueTickingTouched: Callback!
    
    
    @IBAction func seriesTypeChanged(_ sender: UIButton) {
        seriesTypeTouched(sender)
    }
    
    @IBAction func pauseTickingPressed(_ sender: UIButton) {
        pauseTickingTouched(sender)
    }
    
    @IBAction func proceedTicking(_ sender: UIButton) {
        continueTickingTouched(sender)
    }
    
}
