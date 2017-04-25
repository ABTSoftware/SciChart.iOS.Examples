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

class SPO2View: UIView {
    
    @IBOutlet weak var spo2ValueLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configStyle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configStyle()
    }
    
    func updateValue(value : Int) {
        spo2ValueLabel.text = String(value)
    }
    
    func updateTime(date : Date) {
        timeLabel.text = date.toString()
    }
    
    private func configStyle() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.init(red: 217.0/255.0, green: 217.0/255.0, blue: 193.0/255.0, alpha: 1.0).cgColor
    }

}
