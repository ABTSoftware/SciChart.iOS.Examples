//
//  FifoScrollingChartPanel.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 5/1/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

typealias FifoScrollingPanelCallback = () -> Void

class FifoScrollingChartPanel: UIView{
    var playCallback: FifoScrollingPanelCallback?
    var pauseCallback: FifoScrollingPanelCallback?
    var stopCallback: FifoScrollingPanelCallback?
    
    
    @IBAction func playPressed(_ sender: UIButton) {
        if (playCallback != nil) {
            playCallback?()
        }
    }
    @IBAction func pausePressed(_ sender: UIButton) {
        if (pauseCallback != nil) {
            pauseCallback?()
        }
    }
    @IBAction func stopPressed(_ sender: UIButton) {
        if (stopCallback != nil) {
            stopCallback?()
        }
    }
}
