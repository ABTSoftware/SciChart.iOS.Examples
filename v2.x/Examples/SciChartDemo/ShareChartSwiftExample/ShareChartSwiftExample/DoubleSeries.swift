//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DoubleSeries.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit
import SciChart

class DoubleSeries: NSObject {
    
    private var xArray: SCIArrayController
    private var yArray: SCIArrayController
    
    var xValues: SCIGenericType {
        var arrayPointer = SCIGeneric(xArray.data())
        arrayPointer.type = .doublePtr        
        return arrayPointer
    }
    
    var yValues: SCIGenericType {
        var arrayPointer = SCIGeneric(yArray.data())
        arrayPointer.type = .doublePtr
        return arrayPointer
    }
    
    var size: Int32 {
        return xArray.count()
    }
    
    override init() {
        xArray = SCIArrayController(type: .double)
        yArray = SCIArrayController(type: .double)
        super.init()
    }

    init(capacity: Int32) {
        xArray = SCIArrayController(type: .double, size: capacity)
        yArray = SCIArrayController(type: .double, size: capacity)
        super.init()
    }
    
    func addX(_ x: Double, y: Double) {
        xArray.append(SCIGeneric(x))
        yArray.append(SCIGeneric(y))
    }
}
