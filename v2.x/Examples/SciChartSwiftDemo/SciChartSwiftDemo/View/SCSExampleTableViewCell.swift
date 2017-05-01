//
//  SCSExampleTableViewCell.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 4/27/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import UIKit

class SCSExampleTableViewCell: UITableViewCell {
    
    @IBOutlet var exampleIcon : UIImageView!
    @IBOutlet var exampleName : UILabel!
    @IBOutlet var exampleDescription : UILabel!
    var exampleClass : String = ""
    
    func setup(with exampleItem: SCSExampleItem) {
        exampleClass = exampleItem.exampleClass
        if let icon = UIImage.init(named: exampleItem.exampleIcon, in: nil, compatibleWith: nil) {
            exampleIcon.image = icon
        }
        exampleName.text = exampleItem.exampleName
        exampleDescription.text = exampleItem.exampleDescription
    }
    
}

