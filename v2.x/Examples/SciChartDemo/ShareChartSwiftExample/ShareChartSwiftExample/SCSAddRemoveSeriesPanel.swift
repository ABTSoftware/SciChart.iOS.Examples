//
//  SCSAddRemoveSeriesPanel.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 26/04/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit
typealias PanelCallback = () -> Void

class SCSAddRemoveSeriesPanel: UIView {
    
    var onAddClicked : PanelCallback?
    var onRemoveClicked : PanelCallback?
    var onClearClicked : PanelCallback?
    
    @IBAction func addPressed(_ sender: UIButton) {
        if onAddClicked != nil {
            onAddClicked!()
        }
    }
    
    @IBAction func removePressed(_ sender: UIButton) {
        if onRemoveClicked != nil {
            onRemoveClicked!()
        }
    }
    
    @IBAction func clearPressed(_ sender: UIButton) {
        if onClearClicked != nil {
            onClearClicked!()
        }
    }
}
