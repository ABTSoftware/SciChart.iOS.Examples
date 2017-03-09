//
//  SCSExampleItem.swift
//  SciChartShowcaseDemo
//
//  Created by Mykola Hrybeniuk on 2/22/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import UIKit

class ExampleItem {
    
    let title : String
    let description : String
    let iconName : String
    let segueId : String
    
    
    init(_ title: String, _ description: String, _ iconName: String, _ segueId: String) {
        
        self.title = title
        self.description = description
        self.iconName = iconName
        self.segueId = segueId
        
    }
    
    
}
