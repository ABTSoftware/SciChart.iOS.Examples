//
//  MedicalPressureView.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

class BloodPressureView: UIView {

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
        configStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configStyle()
    }
    
    private func configStyle() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.init(red: 217.0/255.0, green: 217.0/255.0, blue: 193.0/255.0, alpha: 1.0).cgColor
    }
    
}
