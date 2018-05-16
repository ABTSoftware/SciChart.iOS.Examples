//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSExampleTableViewCell.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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

