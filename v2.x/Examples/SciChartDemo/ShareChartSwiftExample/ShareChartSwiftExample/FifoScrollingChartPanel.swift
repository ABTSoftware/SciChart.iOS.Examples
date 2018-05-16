//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// FifoScrollingChartPanel.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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
