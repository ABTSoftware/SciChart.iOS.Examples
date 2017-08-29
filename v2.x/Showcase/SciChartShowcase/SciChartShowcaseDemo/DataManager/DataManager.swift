//
//  DataManager.swift
//  SciChartShowcaseDemo
//
//  Created by Mykola Hrybeniuk on 2/23/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

enum StockIndex : String, EnumCollection, CustomStringConvertible {
    case NASDAQ = ".IXIC"
    case SP500 = ".INX"
    case DowJones = ".DJI"
    case Google = "GOOG"
    case Apple = "AAPL"
    
    var description: String {
        switch self {
        case .NASDAQ:
            return "NASDAQ"
        case .SP500:
            return "SP500"
        case .DowJones:
            return "Dow Jones"
        case .Google:
            return "Google"
        case .Apple:
            return "Apple"
        }
    }
}

enum TimePeriod : String, EnumCollection, CustomStringConvertible {
    case hour = "60m"
    case day = "1d"
    case week = "7d"
    case year = "1Y"
    
    var description: String {
        switch self {
        case .hour:
            return "1 hour"
        case .day:
            return "1 day"
        case .week:
            return "7 days"
        case .year:
            return "1 year"
        }
    }
}

enum TimeScale : Int, EnumCollection, CustomStringConvertible {
    case oneMin = 60
    case fiveMin = 300
    case fifteenMin = 900
    case hour = 3600
    case day = 86400
    
    var description: String {
        switch self {
        case .oneMin:
            return "1 min"
        case .fiveMin:
            return "5 min"
        case .fifteenMin:
            return "15 min"
        case .hour:
            return "1 hour"
        case .day:
            return "1 day"
        }
    }
}

protocol EnumCollection: Hashable {
    static var allValues: [Self] { get }
}

extension EnumCollection {
    
    static func cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
    
    static var allValues: [Self] {
        return Array(self.cases())
    }
}

struct ResourcesFileName {
    static let bloodOxygenation = "BloodOxygenation"
    static let bloodPressure = "BloodPressure"
    static let bloodVolume = "BloodVolume"
    static let heartRate = "HeartRate"
}

typealias DataHanlder<T> = (_ dataSeries: T, _ errorMessage: ErrorMessage?) -> Void
private typealias ReadFileHandler = (_ content: [String]) -> Void

class DataManager {
    
    static func getHeartRateData(with handler: @escaping DataHanlder<SCIXyDataSeries>) {
        readText(fromFile: ResourcesFileName.heartRate) { (content: [String]) in
            handler(getXyDataSeries(xColumnNumber: 0, yColumnNumber: 1, content: content), nil)
        }
    }
    
    static func getBloodPressureData(with handler:@escaping DataHanlder<SCIXyDataSeries>) {
        readText(fromFile: ResourcesFileName.bloodPressure) { (content: [String]) in
            handler(getXyDataSeries(xColumnNumber: 0, yColumnNumber: 1, content: content), nil)
        }
    }
    
    static func getBloodVolumeData(with handler:@escaping DataHanlder<SCIXyDataSeries>) {
        readText(fromFile: ResourcesFileName.bloodVolume) { (content: [String]) in
            handler(getXyDataSeries(xColumnNumber: 0, yColumnNumber: 1, content: content), nil)
        }
    }
    
    static func getBloodOxygenationData(with handler:@escaping DataHanlder<SCIXyDataSeries>) {
        readText(fromFile: ResourcesFileName.bloodOxygenation) { (content: [String]) in
            handler(getXyDataSeries(xColumnNumber: 0, yColumnNumber: 1, content: content), nil)
        }
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
    
    // MARK: Trader methods
    
    static func getPrices(with timeScale: TimeScale = .day, _ timePeriod: TimePeriod = .week, _ stockIndex: StockIndex = .NASDAQ, handler: @escaping DataHanlder<TraderViewModel>) {
        
        guard let reachability = Network.reachability else {
            let dataSeries = getTraderCachedDataSeries()
            let viewModel = TraderViewModel(stockIndex, timeScale, timePeriod, dataSeries: dataSeries)
            handler(viewModel, NetworkDomainErrors.noInternetConnection)
            return
        }
        
        let cachedDataHandler = { (_ errorMessage: (title: String, description: String?)?) in
            DispatchQueue.global().async {
                let dataSeries = getTraderCachedDataSeries()
                let viewModel = TraderViewModel(stockIndex, timeScale, timePeriod, dataSeries: dataSeries)
                DispatchQueue.main.async {
                    handler(viewModel, errorMessage)
                }
            }
        }
        
        if reachability.status == .wifi || (!reachability.isRunningOnDevice && reachability.isConnectedToNetwork) {
            ServiceManager().getPrices(with: stockIndex, timeScale: timeScale, period: timePeriod, handler: { (succes, data, errorMessage) in
                if let isData = data, succes {
                    let dataSeries = getTraderDataSeries(from: isData)
                    let viewModel = TraderViewModel(stockIndex, timeScale, timePeriod, dataSeries: dataSeries)
                    handler(viewModel, nil)
                }
                else {
                    cachedDataHandler(errorMessage)
                }
            })
        }
        else {
            cachedDataHandler(NetworkDomainErrors.noInternetConnection)
        }
        
    }
    
    typealias TraderDataSeries = (ohlc: SCIOhlcDataSeries, volume: SCIXyDataSeries, averageLow: SCIXyDataSeries, averageHigh: SCIXyDataSeries, rsi: SCIXyDataSeries, mcad: SCIXyyDataSeries, histogram: SCIXyDataSeries)
    
    private static func getTraderCachedDataSeries() -> TraderDataSeries {
        let count = 3000
        let filePath = Bundle.main.path(forResource: "TraderData", ofType: "txt")!
        let data = try! String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        var items = data.components(separatedBy: "\n")
        var subItems = [String]()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .dateTime, yType: .double)
        let volumeDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        let lowDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        let highDataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        let rsi = SCIXyDataSeries(xType: .dateTime, yType: .double)
        let mcad = SCIXyyDataSeries(xType: .dateTime, yType: .double)
        let histogram = SCIXyDataSeries(xType: .dateTime, yType: .double)
        
        let averageLow = MovingAverage(length: 50)
        let averageHigh = MovingAverage(length: 200)
        let averageGainRsi = MovingAverage(length: 14)
        let averageLossRsi = MovingAverage(length: 14)
        let averageSLow = MovingAverage(length: 12)
        let averageFast = MovingAverage(length: 26)
        let averageSignal = MovingAverage(length: 9)
        var previousClose = Double.nan
        
        for i in 0..<count {
            subItems = items[i].components(separatedBy: ",")
            
            let dateTime = dateFormatter.date(from: subItems[0])!
            let open = Double(subItems[1])!
            let high = Double(subItems[2])!
            let low = Double(subItems[3])!
            let close = Double(subItems[4])!
            let volume = Double(subItems[5])!
            
            ohlcDataSeries.appendX(SCIGeneric(dateTime), open: SCIGeneric(open), high: SCIGeneric(high), low: SCIGeneric(low), close: SCIGeneric(close))
            volumeDataSeries.appendX(SCIGeneric(dateTime), y: SCIGeneric(volume))
            lowDataSeries.appendX(SCIGeneric(dateTime), y: SCIGeneric(averageLow.push(close).current))
            highDataSeries.appendX(SCIGeneric(dateTime), y: SCIGeneric(averageHigh.push(close).current))
            
            // Rsi calculations and fill data series
            let rsiValue = rsiForAverageGain(averageGainRsi, andAveLoss: averageLossRsi, previousClose, close)
            rsi.appendX(SCIGeneric(dateTime), y: SCIGeneric(rsiValue))
            
            // Mcad calculations and fill data series
            var mcadPoint = mcadPointForSlow(averageSLow, forFast: averageFast, forSignal: averageSignal, andCloseValue: close)
            if mcadPoint.divergence.isNaN {
                mcadPoint.divergence = 0.00000000000000;
            }
            mcad.appendX(SCIGeneric(dateTime), y1: SCIGeneric(mcadPoint.mcad), y2: SCIGeneric(mcadPoint.signal))
            histogram.appendX(SCIGeneric(dateTime), y: SCIGeneric(mcadPoint.divergence))
            
            previousClose = close
            
        }
        
        return (ohlcDataSeries, volumeDataSeries, lowDataSeries, highDataSeries, rsi, mcad, histogram)
    }
    
    private static func getTraderDataSeries(from stockPrices: StockPrices) -> TraderDataSeries {
        
        let ohlc = SCIOhlcDataSeries(xType: .dateTime, yType: .double)
        let volume = SCIXyDataSeries(xType: .dateTime, yType: .double)
        let low = SCIXyDataSeries(xType: .dateTime, yType: .double)
        let high = SCIXyDataSeries(xType: .dateTime, yType: .double)
        let rsi = SCIXyDataSeries(xType: .dateTime, yType: .double)
        let mcad = SCIXyyDataSeries(xType: .dateTime, yType: .double)
        let histogram = SCIXyDataSeries(xType: .dateTime, yType: .double)
        
        let averageLow = MovingAverage(length: 50)
        let averageHigh = MovingAverage(length: 200)
        let averageGainRsi = MovingAverage(length: 14)
        let averageLossRsi = MovingAverage(length: 14)
        let averageSLow = MovingAverage(length: 12)
        let averageFast = MovingAverage(length: 26)
        let averageSignal = MovingAverage(length: 9)
        var previousClose = Double.nan
        
        for item in stockPrices.items {
            ohlc.appendX(SCIGeneric(item.dateTime), open: SCIGeneric(item.open), high: SCIGeneric(item.high), low: SCIGeneric(item.low), close: SCIGeneric(item.close))
            volume.appendX(SCIGeneric(item.dateTime), y: SCIGeneric(item.volume))
            low.appendX(SCIGeneric(item.dateTime), y: SCIGeneric(averageLow.push(item.close).current))
            high.appendX(SCIGeneric(item.dateTime), y: SCIGeneric(averageHigh.push(item.close).current))
            
            // Rsi calculations and fill data series
            let rsiValue = rsiForAverageGain(averageGainRsi, andAveLoss: averageLossRsi, previousClose, item.close)
            rsi.appendX(SCIGeneric(item.dateTime), y: SCIGeneric(rsiValue))
            
            // Mcad calculations and fill data series
            var mcadPoint = mcadPointForSlow(averageSLow, forFast: averageFast, forSignal: averageSignal, andCloseValue: item.close)
            if mcadPoint.divergence.isNaN {
                mcadPoint.divergence = 0.00000000000000;
            }
            mcad.appendX(SCIGeneric(item.dateTime), y1: SCIGeneric(mcadPoint.mcad), y2: SCIGeneric(mcadPoint.signal))
            histogram.appendX(SCIGeneric(item.dateTime), y: SCIGeneric(mcadPoint.divergence))
            
            previousClose = item.close
        }
        
        return (ohlc, volume, low, high, rsi, mcad, histogram)
    }
    
    private static func rsiForAverageGain(_ averageGain: MovingAverage, andAveLoss averageLoss: MovingAverage, _ previousClose: Double, _ currentClose: Double) -> Double  {
        let gain = currentClose > previousClose ? currentClose - previousClose : 0.0
        let loss = previousClose > currentClose ? previousClose - currentClose : 0.0
        _ = averageGain.push(gain)
        _ = averageLoss.push(loss)
        let relativeStrength = averageGain.current.isNaN || averageLoss.current.isNaN ? Double.nan : averageGain.current / averageLoss.current
        return relativeStrength.isNaN ? Double.nan : 100.0 - (100.0 / (1.0 + relativeStrength))
    }
    
    private static func mcadPointForSlow(_ slow: MovingAverage, forFast fast: MovingAverage, forSignal signal: MovingAverage, andCloseValue close: Double) -> (mcad: Double, signal: Double, divergence: Double) {
        _ = slow.push(close)
        _ = fast.push(close)
        let macd = slow.current - fast.current
        let signalLine = macd.isNaN ? Double.nan : signal.push(macd).current
        let divergence = macd.isNaN || signalLine.isNaN ? Double.nan : macd - signalLine
        return (macd, signalLine, divergence)
    }
    
    
}
