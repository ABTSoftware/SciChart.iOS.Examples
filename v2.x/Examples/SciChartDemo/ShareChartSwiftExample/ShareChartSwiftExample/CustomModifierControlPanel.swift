//
//  CustomModifierControlPanel.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 20/09/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import UIKit

typealias CustomModifierControlPanelCallback = () -> Void

open class CustomModifierControlPanel : UIView {
    
    var onClearClicked : CustomModifierControlPanelCallback!
    var onPrevClicked : CustomModifierControlPanelCallback!
    var onNextClicked : CustomModifierControlPanelCallback!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBAction func prevClick(_ sender: AnyObject) {
        if (onPrevClicked != nil) {
            onPrevClicked()
        }
    }
    
    @IBAction func nextClick(_ sender: AnyObject) {
        if (onNextClicked != nil) {
            onNextClicked()
        }
    }
    
    @IBAction func clearClick(_ sender: AnyObject) {
        if (onClearClicked != nil) {
            onClearClicked()
        }
    }
    
    open func setText(_ text : String ) {
        infoLabel.text = text
    }
    
}
