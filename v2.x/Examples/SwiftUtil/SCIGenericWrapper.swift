//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCIGenericWrapper.swift is part of SCICHART®, High Performance Scientific Charts
// For full terms and conditions of the license, see http://www.scichart.com/scichart-eula/
//
// This source code is protected by international copyright law. Unauthorized
// reproduction, reverse-engineering, or distribution of all or any portion of
// this source code is strictly prohibited.
//
// This source code contains confidential and proprietary trade secrets of
// SciChart Ltd., and should at no time be copied, transferred, sold,
// distributed or made available without express written permission.
//******************************************************************************

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
    
    
    public protocol SCIGenericInfo {
        func getInfoType() -> SCIDataType
    }
    
    extension Int16 : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.int16
        }
    }
    
    extension Int32 : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.int32
        }
    }
    
    extension Int : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.int32
        }
    }
    
    extension Int64 : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.int64
        }
    }
    
    extension UInt : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.int32
        }
    }
    
    extension UInt8 : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.byte
        }
    }
    
    extension UInt16 : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.int16
        }
    }
    
    extension UInt64 : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.int64
        }
    }
    
    extension UInt32 : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.int32
        }
    }
    
    extension Double : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.double
        }
    }
    
    extension Float : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.float
        }
    }
    
    extension Character : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.byte
        }
    }
    
    extension CChar : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.byte
        }
    }
    
    extension NSArray : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.array
        }
    }
    
    extension NSDate : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.dateTime
        }
    }
    
    extension Date : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.swiftDateTime
        }
    }
    
    extension UnsafeMutablePointer : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            if let pointerType = pointee as? SCIGenericInfo {
                switch pointerType.getInfoType() {
                case .int16:
                    return SCIDataType.int16Ptr
                case .int32:
                    return SCIDataType.int32Ptr
                case .int64:
                    return SCIDataType.int64Ptr
                case .byte:
                    return SCIDataType.charPtr
                case .float:
                    return SCIDataType.floatPtr
                case .double:
                    return SCIDataType.doublePtr
                default:
                    return SCIDataType.voidPtr
                }
            }
            return SCIDataType.voidPtr
        }
    }
    
    extension UnsafeMutableRawPointer : SCIGenericInfo {
        public func getInfoType() -> SCIDataType {
            return SCIDataType.voidPtr
        }
    }
    
    public func SCIGeneric<T: SCIGenericInfo>(_ x: T) -> SCIGenericType {
        var data = x
        var typeData = data.getInfoType()
        if typeData == .swiftDateTime {
            if let date = x as? Date {
                let timeInterval = date.timeIntervalSince1970
                var nsDate = NSDate.init(timeIntervalSince1970: timeInterval)
                typeData = .dateTime
                return SCI_constructGenericTypeWithInfo(&nsDate, typeData)
            }
        }
        return SCI_constructGenericTypeWithInfo(&data, typeData)
    }
    
    
    public func SCIGeneric<T:SCIGenericInfo>(_ x: [T]) -> SCIGenericType {
        let data = x
        let unsafePointer = UnsafeMutablePointer(mutating: data)
        return SCIGeneric(unsafePointer)
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
    
    public func SCIGeneric<T:SCIGenericInfo>(_ x: [T]) -> SCIGenericType {
        let data = x
        let unsafePointer = UnsafeMutablePointer(mutating: data)
        return SCIGeneric(unsafePointer)
    }
    
#endif

/** @} */
