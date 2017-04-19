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
    
    private var xArray: SCIArrayController?
    private var yArray: SCIArrayController?
    
    var xValues: SCIGenericType {
        var arrayPointer = SCIGenericType()
        arrayPointer.voidPtr = xArray?.data()
        arrayPointer.type = .doublePtr
        
        return arrayPointer
    }
    
    var yValues: SCIGenericType {
        var arrayPointer = SCIGenericType()
        arrayPointer.voidPtr = yArray?.data()
        arrayPointer.type = .doublePtr
        
        return arrayPointer
    }
    
    var size: Int32 {
        return (xArray?.count())!
    }
    
    override init() {
        super.init()
        
        xArray = SCIArrayController(type: .double)
        yArray = SCIArrayController(type: .double)
        
    }

    init(capacity: Int32) {
        super.init()
        
        xArray = SCIArrayController(type: .double, size: capacity)
        yArray = SCIArrayController(type: .double, size: capacity)
        
    }
    
    func addX(_ x: Double, y: Double) {
        xArray?.append(SCIGeneric(x))
        yArray?.append(SCIGeneric(y))
    }
}
