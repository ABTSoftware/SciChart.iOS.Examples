//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSRealTimeTickingStocksControlPanelView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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
