//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DataManagerExtensions.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

extension DataManager {
    
    static func getGenericDataArray<T>(_ unsafePointer: UnsafeMutablePointer<T>) -> SCIGenericType {
        var arrayPointer = SCIGenericType()
        arrayPointer.voidPtr = UnsafeMutableRawPointer(unsafePointer)
        arrayPointer.type = .doublePtr
        
        return arrayPointer
    }
    
    static func getGenericDataLongArray<T>(_ unsafePointer: UnsafeMutablePointer<T>) -> SCIGenericType {
        var arrayPointer = SCIGenericType()
        arrayPointer.voidPtr = UnsafeMutableRawPointer(unsafePointer)
        arrayPointer.type = .int64Ptr
        
        return arrayPointer
    }
    
    static func getGenericDataArrayWithOffset(_ sourceArray: UnsafeMutablePointer<Double>, size: Int32, offset: Double) -> SCIGenericType {
        let resultArray = [Double](repeating: 0, count: Int(size))
        let resultArrayPointer: UnsafeMutablePointer<Double> = UnsafeMutablePointer(mutating: resultArray)
        
        DataManager.offsetArray(sourceArray, destArray: resultArrayPointer, count: size, offset: offset)
        
        var arrayPointer = SCIGenericType()
        arrayPointer.voidPtr = UnsafeMutableRawPointer(resultArrayPointer)
        arrayPointer.type = .doublePtr
        
        return arrayPointer
    }
}
