//
//  MedicalBloodVolumeView.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 01/03/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class MedicalBloodVolumeView: UIView {

    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var rrBarsView: UIView!
    @IBOutlet weak var rrBarsOffsetConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rpmBarsView: UIView!
    @IBOutlet weak var rpmBarsOffsetConstraint: NSLayoutConstraint!

    func updateVolume(volume : Float) {
        volumeLabel.text = String(format: "%.1f", volume)
    }
    
    func updateRRBars(value : Int) {
        let normalizedValue = (value > 12) ? 12 : (value < 0) ? 0 : value
        let offsetStep = rrBarsView.frame.size.height / 12
        let offset = offsetStep * CGFloat(normalizedValue - 5)
        rrBarsOffsetConstraint.constant = offset
    }
    
    func updateRPRBars(value : Int) {
        let normalizedValue = (value > 12) ? 12 : (value < 0) ? 0 : value
        let offsetStep = rrBarsView.frame.size.height / 12
        let offset = offsetStep * CGFloat(normalizedValue - 5)
        rpmBarsOffsetConstraint.constant = offset
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.white.cgColor
    }
}
