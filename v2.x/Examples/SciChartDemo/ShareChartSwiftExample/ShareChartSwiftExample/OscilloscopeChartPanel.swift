//
//  OscilloscopeChartPanel.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 4/20/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

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
