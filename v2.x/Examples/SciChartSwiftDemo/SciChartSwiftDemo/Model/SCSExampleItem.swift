//
//  SCSExampleItemModel.swift
//  SciChartSwiftDemo
//
//  Created by Hrybenuik Mykola on 4/27/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

struct SCSExampleItem {
    
    let exampleName : String
    let exampleIcon : String
    let exampleClass : String
    let exampleDescription : String
    
    init(_ name: String, _ icon: String, _ className: String, _ descr:String) {
        exampleName = name
        exampleDescription = descr
        exampleIcon = icon
        exampleClass = className
    }
    
}
