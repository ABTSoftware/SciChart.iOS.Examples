//
//  MedicalSPO2View.swift
//  SciChartShowcaseDemo
//
//  Created by Admin on 28/02/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self)
    }
}

class MedicalSPO2View: UIView {
    @IBOutlet weak var spo2ValueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

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
    
    func updateValue(value : Int) {
        spo2ValueLabel.text = String(value)
    }
    
    func updateTime(date : Date) {
        timeLabel.text = date.toString()
    }

}
