//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RealTimeGhostedTracesPanel.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit
typealias RealTimeGhostedTracesPanelCallback = (_ sender:UISlider) -> Void

class RealTimeGhostedTracesPanel: UIView{
    
    @IBOutlet weak var msText: UILabel!
    var callBack: RealTimeGhostedTracesPanelCallback?
    
    @IBAction func speedChangedPresesd(_ sender: UISlider) {
        msText.text = String.init(format: "%.0f ms", sender.value)
        
        if let call = callBack{
            call(sender)
        }
    }
}
