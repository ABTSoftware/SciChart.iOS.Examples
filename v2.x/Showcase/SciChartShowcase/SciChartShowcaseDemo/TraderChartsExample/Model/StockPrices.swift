//
//  StockPrices.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 7/17/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

struct StockItem {
    var dateTime: Date = Date()
    var high: Double = Double.nan
    var low: Double = Double.nan
    var open: Double = Double.nan
    var close: Double = Double.nan
    var volume: Double = Double.nan
    
    init(with dateTimeValue: Date?, _ highValue: Double?, _ lowValue: Double?, _ openValue: Double?, _ closeValue: Double?, _ volumeValue: Double?) {
        
        if let nonNilDateTime = dateTimeValue {
            dateTime = nonNilDateTime
        }
        
        if let isHigh = highValue {
            high = isHigh
        }
        
        if let isLow = lowValue {
            low = isLow
        }
        
        if let isOpen = openValue {
            open = isOpen
        }
        
        if let isClose = closeValue {
            close = isClose
        }
        
        if let isVolume = volumeValue {
            volume = isVolume
        }
        
    }
}

struct StockPrices : Mappable {
    
    var stockExachange : StockIndex = .NASDAQ
    var items : [StockItem] = [StockItem]()
    
    init(with responseString: String) {
        
        var strings = responseString.components(separatedBy: "\n")
        
        if strings[0].contains("INDEXSP") {
            stockExachange = .SP500
        }
        else if strings[0].contains("INDEXDJX") {
            stockExachange = .DowJones
        }
        else if strings[0].contains("APPL") {
            stockExachange = .Apple
        }
        else if strings[0].contains("GOOG") {
            stockExachange = .Google
        }
       
        guard let interval: Double = Double(strings[3].replacingOccurrences(of: "INTERVAL=", with: "")) else {
            print("Interval doesn't exist.")
            return;
        }
        
        strings.removeFirst(7)
        
        var startDateTime = Date()
        
        for row in strings {

            if row.contains("TIME") || row.isEmpty {
                continue
            }
            
            let subStrings = row.components(separatedBy: ",")
            
            let index = row.index(row.startIndex, offsetBy: 1)
            
            var currentDate : Date = startDateTime
            
            if row.substring(to: index).contains("a") {
                
                if let timeInterval = Double(subStrings[0].replacingOccurrences(of: "a", with: "")) {
                    startDateTime = Date.init(timeIntervalSince1970: timeInterval)
                    currentDate = startDateTime
                }
            }
            else {
                
                currentDate.addTimeInterval(interval * Double(subStrings[0])!)
                
            }
            
            let closeValue = Double(subStrings[1])
            let highValue = Double(subStrings[2])
            let lowValue = Double(subStrings[3])
            let openValue = Double(subStrings[4])
            let volumeValue = Double(subStrings[5])
            
            let item = StockItem(with: currentDate, highValue, lowValue, openValue, closeValue, volumeValue)
            
            items.append(item)
            
   
        }
        
    }
    
}
