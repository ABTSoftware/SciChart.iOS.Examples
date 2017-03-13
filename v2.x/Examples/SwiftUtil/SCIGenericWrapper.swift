//
//  SCIGenericWrapper.swift
//  SciChart
//
//  Created by Admin on 31/05/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

/** \addtogroup SCIGenericType
 *  @{
 */

import Foundation
import SciChart

/**
 @file SCIGenericType
 */

#if swift(>=3.0)
    /**
     * @brief It is wrapper function that constructs SCIGenericType
     * @code
     * let generic1 = SCIGeneric(0)
     * let variable = 1
     * let generic2 = SCIGeneric( variable )
     * let generic3 = SCIGeneric( NSDate() )
     
     * let doubleVariable = SCIGenericDouble(generic1)
     * let intVariable = SCIGenericInt(generic2)
     * let floatVariable = SCIGenericFloat(generic2)
     * let date = SCIGenericDate(generic3)
     * let timeIntervalSince1970 = SCIGenericDouble(generic3)
     * @endcode
     * @see SCIGenericType
     */
    public func SCIGeneric<T>(_ x: T) -> SCIGenericType {
        var data = x
        if x is Double {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.double)
        } else if x is Float  {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.float)
        } else if x is Int32 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.int32)
        } else if x is Int16 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.int16)
        } else if x is Int64 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.int64)
        } else if x is Int8 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.byte)
        } else if let date = x as? Date {
            let timeInterval = date.timeIntervalSince1970
            var nsDate = NSDate.init(timeIntervalSince1970: timeInterval)
            return SCI_constructGenericTypeWithInfo(&nsDate, SCIDataType.dateTime)
        } else if x is NSDate {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.dateTime)
        } else if x is NSArray {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.array)
        } else if x is Int {
        // TODO: implement correct unsigned type handling
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.int32)
        } else if x is UInt32 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.int32)
        } else if x is UInt16 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.int16)
        } else if x is UInt64 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.int64)
        } else if x is UInt8 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.byte)
        } else if x is UInt {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.int32)
        } else {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.none)
        }
    }
    
#else
    /**
     @brief It is wrapper function that constructs SCIGenericType
     @code
     let generic1 = SCIGeneric(0)
     let variable = 1
     let generic2 = SCIGeneric( variable )
     let generic3 = SCIGeneric( NSDate() )
     
     let doubleVariable = SCIGenericDouble(generic1)
     let intVariable = SCIGenericInt(generic2)
     let floatVariable = SCIGenericFloat(generic2)
     let date = SCIGenericDate(generic3)
     let timeIntervalSince1970 = SCIGenericDouble(generic3)
     @endcode
     @see SCIGenericType
     */
    public func SCIGeneric<T>(x: T) -> SCIGenericType {
        var data = x
        if x is Double {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Double)
        } else if x is Float  {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Float)
        } else if x is Int32 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Int32)
        } else if x is Int16 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Int16)
        } else if x is Int64 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Int64)
        } else if x is Int8 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Byte)
        } else if x is NSDate {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.DateTime)
        } else if x is NSArray {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Array)
        } else if x is Int {
            // TODO: implement correct unsigned type handling
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Int32)
        } else if x is UInt32 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Int32)
        } else if x is UInt16 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Int16)
        } else if x is UInt64 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Int64)
        } else if x is UInt8 {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Byte)
        } else if x is UInt {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.Int32)
        } else {
            return SCI_constructGenericTypeWithInfo(&data, SCIDataType.None)
        }
    }
    
#endif

/** @} */
