//
//  RealTimeGhostedTracesPanel.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 5/1/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

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
