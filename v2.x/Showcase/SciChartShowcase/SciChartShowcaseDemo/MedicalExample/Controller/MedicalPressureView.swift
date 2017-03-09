//
//  MedicalPressureView.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class MedicalPressureView: UIView {

    @IBOutlet weak var bloodPressureLabel: UILabel!
    @IBOutlet weak var barsOffsetConstraint: NSLayoutConstraint!
    @IBOutlet weak var barsView: UIView!

    func updateBloodPressure(high : Int, low : Int) {
        bloodPressureLabel.text = String(format: "%d/%d", high, low)
    }
    
    func updateBars(percentage : Int) {
        let offsetStep = barsView.frame.size.width / 10
        let offset = offsetStep * CGFloat(percentage / 10 - 5)
        barsOffsetConstraint.constant = offset
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
