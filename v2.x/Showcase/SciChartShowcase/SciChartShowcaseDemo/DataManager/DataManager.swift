//
//  DataManager.swift
//  SciChartShowcaseDemo
//
//  Created by Mykola Hrybeniuk on 2/23/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

struct ResourcesFileName {
    static let bloodOxygenation = "BloodOxygenation"
    static let bloodPressure = "BloodPressure"
    static let bloodVolume = "BloodVolume"
    static let heartRate = "HeartRate"
}

typealias DataHanlder = (_ dataSeries: SCIDataSeriesProtocol) -> Void
private typealias ReadFileHandler = (_ content: [String]) -> Void

class DataManager {
    
    static func getHeartRateData(with handler: @escaping DataHanlder) {
        readText(fromFile: ResourcesFileName.heartRate) { (content: [String]) in
            handler(getXyDataSeries(xColumnNumber: 0, yColumnNumber: 1, content: content))
        }
    }
    
    static func getBloodPressureData(with handler:@escaping DataHanlder) {
        readText(fromFile: ResourcesFileName.bloodPressure) { (content: [String]) in
            handler(getXyDataSeries(xColumnNumber: 0, yColumnNumber: 1, content: content))
        }
    }
    
    static func getBloodVolumeData(with handler:@escaping DataHanlder) {
        readText(fromFile: ResourcesFileName.bloodVolume) { (content: [String]) in
            handler(getXyDataSeries(xColumnNumber: 0, yColumnNumber: 1, content: content))
        }
    }
    
    static func getBloodOxygenationData(with handler:@escaping DataHanlder) {
        readText(fromFile: ResourcesFileName.bloodOxygenation) { (content: [String]) in
            handler(getXyDataSeries(xColumnNumber: 0, yColumnNumber: 1, content: content))
        }
    }
    
    private static func getXyDataSeries(xColumnNumber: Int, yColumnNumber: Int, content: [String]) -> SCIXyDataSeries {
        
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        
        for item in content {
            
            let subItems : [String] = item.components(separatedBy: ";")
            
            
            let y : Float = Float(subItems[yColumnNumber])!
            let x : Float = Float(subItems[xColumnNumber])!
            
            dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
            
        }
        
        return dataSeries
        
    }
    
    private static func readText(fromFile name: String, handler: @escaping ReadFileHandler) {
        
        DispatchQueue.global(qos: .userInitiated).async {

            var items = [""]
            
            if let resourcePath = Bundle.main.resourcePath {
                
                let filePath = resourcePath+"/"+name+".txt"
                
                do {
                    
                    var contentFile = try String(contentsOfFile: filePath)
                    
                    contentFile = contentFile.replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range:nil)
                    
                    items = contentFile.components(separatedBy: "\n")

                    items.removeLast()
                    
                }
                catch let error {
                    
                    print("Reading File Error - "+error.localizedDescription)
                    
                }
            }
            else {
                print("Resource Path doesn't exist")
            }
            
            DispatchQueue.main.async {

                handler(items)
                
            }
        }
        
    }
    
    
}
