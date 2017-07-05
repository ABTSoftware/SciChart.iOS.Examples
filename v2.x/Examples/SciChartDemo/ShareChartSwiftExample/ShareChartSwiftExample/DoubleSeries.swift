//
//  DoubleSeries.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 19/04/2017.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

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
