//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// OscilloscopeChartPanel.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit
typealias OscilloscopePanelCallback = (UIButton?) -> Void

class OscilloscopeChartPanel: UIView{
    var rotateCallback: OscilloscopePanelCallback?
    var flipHorizontallyCallback: OscilloscopePanelCallback?
    var flipVerticallyCallback: OscilloscopePanelCallback?
    var changeSourceCallback: OscilloscopePanelCallback?
    
    @IBAction func flipHorizontallyTouched(_ sender: UIButton) {
        if flipHorizontallyCallback != nil{
            flipHorizontallyCallback!(nil)
        }
    }
   
    @IBAction func flipVerticallyTouched(_ sender: UIButton) {
        if flipVerticallyCallback != nil{
            flipVerticallyCallback!(nil)
        }
    }
    
    @IBAction func rotateTouched(_ sender: UIButton) {
        if rotateCallback != nil{
            rotateCallback!(nil)
        }
    }
    
    @IBAction func changeSourceTouched(_ sender: UIButton) {
        if changeSourceCallback != nil{
            changeSourceCallback!(sender)
        }
    }
}
