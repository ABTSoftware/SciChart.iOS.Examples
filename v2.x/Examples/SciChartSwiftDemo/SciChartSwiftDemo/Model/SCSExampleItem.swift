//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSExampleItem.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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
