//
//  SCSExampleCarouselView.swift
//  SciChartShowcaseDemo
//
//  Created by Yaroslav Pelyukh on 2/22/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import UIKit

class ExampleTableViewCell: UITableViewCell {
    @IBOutlet weak var exampleImage: UIImageView!
    @IBOutlet weak var exampleName: UILabel!
    @IBOutlet weak var exampleDescription: UITextView!
    
    func updateContent(exampleDetails: ExampleItem) {
        self.exampleImage.image = UIImage.init(named:  exampleDetails.iconName)
        self.exampleName.text = exampleDetails.title
        self.exampleDescription.text = exampleDetails.description
    }
}
