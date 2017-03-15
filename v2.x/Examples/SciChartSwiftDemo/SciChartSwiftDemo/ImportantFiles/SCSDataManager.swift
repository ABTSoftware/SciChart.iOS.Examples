//
//  SCSDataManager.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/2/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

typealias OnNewData = (_ sender: SCSMultiPaneItem) -> Void

class SCSDataManager {
    
    static fileprivate func generateXDateTimeSeries(with yValues: [Int]) -> SCIXyDataSeriesProtocol {
        let dataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double, seriesType: .defaultType)
        for i in 0 ..< yValues.count {
            let date = Date(timeIntervalSince1970: Double(60 * 60 * 24 * i))
            let xData = SCIGeneric(date)
            let value: Double = CDouble(yValues[i])
            dataSeries.appendX(xData, y: SCIGeneric(value))
        }
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        return dataSeries
    }
    
    static open func porkDataSeries() -> SCIDataSeriesProtocol {
        let porkData = [10, 13, 7, 16, 4, 6, 20, 14, 16, 10, 24, 11]
        return generateXDateTimeSeries(with: porkData)
    }
    
    static open func tomatoesDataSeries() -> SCIDataSeriesProtocol {
        let tomatoesData = [7, 30, 27, 24, 21, 15, 17, 26, 22, 28, 21, 22]
        return generateXDateTimeSeries(with: tomatoesData)
    }
    
    static open func cucumberDataSeries() -> SCIDataSeriesProtocol {
        let cucumberData = [16, 10, 9, 8, 22, 14, 12, 27, 25, 23, 17, 17]
        return generateXDateTimeSeries(with: cucumberData)
    }
    
    static open func vealDataSeries() -> SCIDataSeriesProtocol {
        let vealData = [12, 17, 21, 15, 19, 18, 13, 21, 22, 20, 5, 10]
        return generateXDateTimeSeries(with: vealData)
    }
    
    static open func pepperDataSeries() -> SCIDataSeriesProtocol {
        let pepperData = [7, 24, 21, 11, 19, 17, 14, 27, 26, 22, 28, 16]
        return generateXDateTimeSeries(with: pepperData)
    }
    
    static open func stackedBarChartSeries() -> [SCIDataSeriesProtocol] {
        var dataSeries = [SCIDataSeriesProtocol]()
        var yValues_1 = [0.0, 0.1, 0.2, 0.4, 0.8, 1.1, 1.5, 2.4, 4.6, 8.1, 11.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 5.4, 6.4, 7.1, 8.0, 9.0]
        var yValues_2 = [2.0, 10.1, 10.2, 10.4, 10.8, 1.1, 11.5, 3.4, 4.6, 0.1, 1.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 1.4, 0.4, 10.1, 0.0, 0.0]
        var yValues_3 = [20.0, 4.1, 4.2, 10.4, 10.8, 1.1, 11.5, 3.4, 4.6, 5.1, 5.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 1.4, 10.4, 8.1, 10.0, 15.0]
        let data1 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        let data2 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        let data3 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .defaultType)
        for i in 0..<yValues_1.count {
            data1.appendX(SCIGeneric(i), y: SCIGeneric(CDouble(yValues_1[i])))
            data2.appendX(SCIGeneric(i), y: SCIGeneric(CDouble(yValues_2[i])))
            data3.appendX(SCIGeneric(i), y: SCIGeneric(CDouble(yValues_3[i])))
        }
        dataSeries.append(data1)
        dataSeries.append(data2)
        dataSeries.append(data3)
        return dataSeries
    }
    
    static open func stackedSideBySideDataSeries() -> [SCIDataSeries] {
        
        var china = [1.269, 1.330, 1.356, 1.304]
        var india = [1.004, 1.173, 1.236, 1.656]
        var usa = [0.282, 0.310, 0.319, 0.439]
        var indonesia = [0.214, 0.243, 0.254, 0.313]
        var brazil = [0.176, 0.201, 0.203, 0.261]
        var pakistan = [0.146, 0.184, 0.196, 0.276]
        var nigeria = [0.123, 0.152, 0.177, 0.264]
        var bangladesh = [0.130, 0.156, 0.166, 0.234]
        var russia = [0.147, 0.139, 0.142, 0.109]
        var japan = [0.126, 0.127, 0.127, 0.094]
        var restOfWorld = [2.466, 2.829, 3.005, 4.306]
        
        let data1 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data2 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data3 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data4 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data5 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data6 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data7 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data8 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data9 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data10 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data11 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        let data12 = SCIXyDataSeries(xType: .double, yType: .double, seriesType: .xCategory)
        
        for i in 0..<4 {
            var xValue: Double = 2000
            if i == 1 {
                xValue = 2010
            }
            else if i == 2 {
                xValue = 2014
            }
            else if i == 3 {
                xValue = 2050
            }
            
            data1.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(china[i])))
            if i != 2 {
                data2.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(india[i])))
                data3.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(usa[i])))
                data4.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(indonesia[i])))
                data5.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(brazil[i])))
            }
            else {
                data2.appendX(SCIGeneric(xValue), y: SCIGeneric(Double.nan))
                data3.appendX(SCIGeneric(xValue), y: SCIGeneric(Double.nan))
                data4.appendX(SCIGeneric(xValue), y: SCIGeneric(Double.nan))
                data5.appendX(SCIGeneric(xValue), y: SCIGeneric(Double.nan))
            }
            data6.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(pakistan[i])))
            data7.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(nigeria[i])))
            data8.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(bangladesh[i])))
            data9.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(russia[i])))
            data10.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(japan[i])))
            data11.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(restOfWorld[i])))
            data12.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(china[i]) + CDouble(india[i]) + CDouble(usa[i]) + CDouble(indonesia[i]) + CDouble(brazil[i]) + CDouble(pakistan[i]) + CDouble(nigeria[i]) + CDouble(bangladesh[i]) + CDouble(russia[i]) + CDouble(japan[i]) + CDouble(restOfWorld[i])))
        }
        let dataSeries = [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12]
        return dataSeries
        
    }
    
    class func getPriceIndu(dataSeries: SCIXyDataSeriesProtocol, fileName:String){
        if let resourcePath = Bundle.main.resourcePath {
            let filePath = resourcePath+"/"+fileName+".csv"
            do {
                let contentFile = try? String.init(contentsOfFile: filePath, encoding: String.Encoding.utf8)
                
                let items = contentFile?.components(separatedBy: "\r\n")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "LL/dd/yyyy"
                
                
                for i in 0..<(items?.count)!-1 {
                    
                    let subItems = (items?[i].components(separatedBy: ","))! as [String]
                    
                    let date = dateFormatter.date(from: subItems[0])
                    let value = Float(subItems[1])
                    
                    dataSeries.appendX(SCIGeneric(date), y: SCIGeneric(value))
                }
            }
        }
    }
    
    static open func stackedVerticalColumnSeries() -> [SCIDataSeriesProtocol] {
        return [porkDataSeries(), vealDataSeries(), tomatoesDataSeries(), cucumberDataSeries(), pepperDataSeries()]
    }
    
    static func loadData<DataSeriesType: SCIXyDataSeriesProtocol>(into dataSeries: DataSeriesType,
                         fileName: String,
                         startIndex: Int,
                         increment: Int,
                         reverse: Bool) {
        
        
        if let resourcePath = Bundle.main.resourcePath {
            let filePath = resourcePath+"/"+fileName+".txt"
            do {
                let contentFile = try NSString(contentsOfFile: filePath, usedEncoding: nil) as String
                
                let items = contentFile.components(separatedBy: "\n")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                
                
                
                if reverse {
                    var i = items.count-1
                    while i >= startIndex {
                        
                        let subItems = items[i].components(separatedBy: ",")
                        
                        let date = dateFormatter.date(from: subItems[0])
                        let value = Float(subItems[1])
                        
                        dataSeries.appendX(SCIGeneric(date), y: SCIGeneric(value))
                        
                        i = i - increment
                    }
                    
                }
                else {
                    var i = startIndex
                    while i < items.count  {
                        
                        let subItems = items[i].components(separatedBy: ",")
                        
                        let date = dateFormatter.date(from: subItems[0])
                        let value = Float(subItems[1])
                        
                        dataSeries.appendX(SCIGeneric(date), y: SCIGeneric(value))
                        
                        i = i + increment
                    }
                }
            }
            catch {
                
                
            }
        }
    }
    
    static func getTradeTicks(_ dataSeries: SCIXyzDataSeriesProtocol, fileName: String){
        if let resourcePath = Bundle.main.resourcePath {
            let filePath = resourcePath+"/"+fileName+".csv"
            do {
                let contentFile = try? String.init(contentsOfFile: filePath, encoding: String.Encoding.utf8)
                
                let items = contentFile?.components(separatedBy: "\r\n")
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss.s"
                
                
                for i in 0..<(items?.count)!-1 {
                    
                    let subItems = (items?[i].components(separatedBy: ","))! as [String]
                    
                    let date = dateFormatter.date(from: subItems[0])
                    let value = Float(subItems[1])
                    let zValue = Float(subItems[2])
                    
                    dataSeries.appendX(SCIGeneric(date), y: SCIGeneric(value), z: SCIGeneric(zValue))
                }
            }
        }
    }
    
    static func putDataInto(_ dataSeries: SCIXyDataSeries) {
        let dataCount = 20
        var i = 0
        while i <= dataCount {
            let x = 10.0*Float(i)/Float(dataCount)
            let y = arc4random_uniform(UInt32(dataCount))
            let xValue = Float(x)
            let yValue = Float(y)
            dataSeries.appendX(SCIGeneric(xValue), y: SCIGeneric(yValue))
            i = i + 1
        }
    }
    
    static func putFourierDataInto(_ dataSeries: SCIXyDataSeries) {
        let dataCount = 1000
        var i = 0
        while i <= dataCount {
            let x = Float(10.0*Float(i)/Float(dataCount))
            let y = 2 * sin(x)+10
            dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
            i = i + 1
        }
    }
    
    static func setFourierDataInto(_ dataSeries: SCIXyDataSeries, amplitude:(Double), phaseShift:(Double), count:(Int)) {
        for i in 0..<count {
            let time = 10*Double(i) / Double(count);
            let wn = 2*M_PI / Double(count/10);
            let y1 = sin(Double(i) * wn + phaseShift)
            let y2 = 0.33 * sin(Double(i) * 3 * wn + phaseShift)
            let y3 = 0.20 * sin(Double(i) * 5 * wn + phaseShift)
            let y4 = 0.14 * sin(Double(i) * 7 * wn + phaseShift)
            let y5 = 0.11 * sin(Double(i) * 9 * wn + phaseShift)
            let y6 = 0.09 * sin(Double(i)*11 * wn + phaseShift)
            let y = M_PI * amplitude * (y1 + y2 + y3 + y4 + y5 + y6);
            dataSeries.appendX(SCIGeneric(time), y: SCIGeneric(y))
        }
    }
    
    static func getDampedSinewave(_ amplitude: Double, phase: Double, dampingFactor: Double, pointCount: Int, freq: Int) -> SCIXyDataSeries {
        
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType);
        var amplitudeMutable = amplitude
        var i = 0
        while i < pointCount {
            
            let time = 10.0 * Double(i) / Double(pointCount)
            let wn = 2.0 * M_PI / (Double(pointCount) / Double(freq))
            
            let d = amplitudeMutable * sin(Double(i) * wn + phase)
            
            dataSeries.appendX(SCIGeneric(time), y: SCIGeneric(d))
            
            amplitudeMutable *= (1.0 - dampingFactor)
            
            i += 1
        }
        
        return dataSeries;
    }
    
    static func randomize(_ min: Double, max: Double) -> Double {
        return (Double(arc4random()) / 0x100000000) * (max - min) + min
    }
    
    static open func loadPriceData(into dataSeries: SCIOhlcDataSeriesProtocol, fileName: String, isReversed: Bool, count: Int) {
        
        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")!
        let data = try! String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        let items = data.components(separatedBy: "\n")
        var subItems = [String]()
        if !isReversed {
            for i in 0..<count {
                subItems = items[i].components(separatedBy: ",")
                dataSeries.appendX(SCIGeneric(i), open: SCIGeneric(CFloat(subItems[1])), high: SCIGeneric(CFloat(subItems[2])), low: SCIGeneric(CFloat(subItems[3])), close: SCIGeneric(CFloat(subItems[4])))
            }
        }
        else {
            var j = 0
            var i = count - 1
            while i >= 0 {
                subItems = items[i].components(separatedBy: ",")
                dataSeries.appendX(SCIGeneric(j), open: SCIGeneric(CFloat(subItems[1])), high: SCIGeneric(CFloat(subItems[2])), low: SCIGeneric(CFloat(subItems[3])), close: SCIGeneric(CFloat(subItems[4])))
                j += 1
                i -= 1
            }
        }
        
    }
    
    static open func loadPaneStockData() -> [SCSMultiPaneItem] {
        
        let count = 3000
        let filePath = Bundle.main.path(forResource: "EURUSD_Daily", ofType: "txt")!
        let data = try! String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        var items = data.components(separatedBy: "\n")
        var subItems = [String]()
        var array = [SCSMultiPaneItem]() /* capacity: count */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        for i in 0..<count {
            subItems = items[i].components(separatedBy: ",")
            let item = SCSMultiPaneItem()
            item.dateTime = dateFormatter.date(from: subItems[0])!
            item.open = Double(subItems[1])!
            item.high = Double(subItems[2])!
            item.low = Double(subItems[3])!
            item.close = Double(subItems[4])!
            item.volume = Double(subItems[5])!
            array.append(item)
        }
        return array
        
    }
    
    static open func loadThemeData() -> [SCSMultiPaneItem] {
        
        let count = 250
        let filePath = Bundle.main.path(forResource: "FinanceData", ofType: "txt")!
        let data = try! String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        var items = data.components(separatedBy: "\n")
        var subItems = [String]()
        var array = [SCSMultiPaneItem]() /* capacity: count */
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        for i in 0..<count {
            subItems = items[i].components(separatedBy: ",")
            let item = SCSMultiPaneItem()
            item.dateTime = dateFormatter.date(from: subItems[0])!
            item.open = Double(subItems[1])!
            item.high = Double(subItems[2])!
            item.low = Double(subItems[3])!
            item.close = Double(subItems[4])!
            item.volume = Double(subItems[5])!
            array.append(item)
        }
        
        return array
    }
    
    static open func loadData(into dataSeries:SCIXyDataSeriesProtocol, from fileName: String) {
        
        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")!
        let data = try! String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        let items = data.components(separatedBy: "\n")
        
        for i in 0..<items.count {
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(CFloat(items[i])))
        }
        
    }
    
}


open class SCSMultiPaneItem {
    
    var open = Double.nan
    var high = Double.nan
    var low = Double.nan
    var close = Double.nan
    var volume = Double.nan
    var dateTime = Date()
    
}

open class SCSMcadPointItem {
    
    var mcad = Double.nan
    var signal = Double.nan
    var divergence = Double.nan
    
}

class SCSMovingAverage {
    
    var current: Double = 0.0
    private var length: Int = 0
    private var circIndex: Int = -1
    private var filled: Bool = false
    private var oneOverLength = Double.nan
    private var circularBuffer: [Double]!
    private var total : Double = 0.0
    
    init(length: Int) {
        self.length = length
        oneOverLength = 1.0/Double(length)
        circularBuffer = [Double].init(repeating: 0.0, count: length)
    }
    
    func push(_ value: Double) -> SCSMovingAverage {
        
        circIndex += 1
        if circIndex == length {
            circIndex = 0
        }
        
        let lostValue: Double = circIndex < circularBuffer.count ? Double(circularBuffer[circIndex]) : 0.0
        circularBuffer[circIndex] = value
        total += value
        total -= lostValue
        
        if !filled && circIndex != length - 1 {
            current = Double.nan
            return self
        }
        else {
            filled = true
        }
        
        current = total * oneOverLength
        
        return self
    }
    
    func update(_ value: Double) {
        
        let lostValue: Double = Double(circularBuffer[circIndex])
        
        circularBuffer[circIndex] = (value)
        
        // Maintain totals for Push function
        total += value
        total -= lostValue
        
        // If not yet filled, just return. Current value should be double.NaN
        if !filled {
            current = Double.nan
            return
        }
        
        // Compute the average
        var average: Double = 0.0
        for i in 0..<circularBuffer.count {
            average += Double(circularBuffer[i])
        }
        
        current = average * oneOverLength
        
    }
}

class SCSRandomPriceDataSource {
    
    var updateData: OnNewData?
    var newData: OnNewData?
    private var timer: Timer?
    private var Frequency: Double = 0.0
    private var candleIntervalMinutes = 0
    private var simulateDateGap = false
    private var lastPriceBar: SCSMultiPaneItem!
    private var initialPriceBar: SCSMultiPaneItem!
    private var currentTime: Double = 0.0
    private var updatesPerPrice = 0
    private var currentUpdateCount = 0
    private var openMarketTime = TimeInterval()
    private var closeMarketTime = TimeInterval()
    private var randomSeed = 0
    private var timeInerval: Double = 0.0
    
    init(candleIntervalMinutes: Int, simulateDateGap: Bool, timeInterval: Double, updatesPerPrice: Int, randomSeed: Int, startingPrice: Double, start startDate: Date) {
        
        Frequency = 1.1574074074074073E-05
        openMarketTime = 360
        closeMarketTime = 720
        self.candleIntervalMinutes = candleIntervalMinutes
        self.simulateDateGap = simulateDateGap
        self.updatesPerPrice = updatesPerPrice
        self.timeInerval = timeInterval
        self.initialPriceBar = SCSMultiPaneItem()
        self.initialPriceBar.close = startingPrice
        self.initialPriceBar.dateTime = startDate
        self.lastPriceBar = SCSMultiPaneItem()
        self.lastPriceBar.close = initialPriceBar.close
        self.lastPriceBar.dateTime = initialPriceBar.dateTime
        self.lastPriceBar.high = initialPriceBar.close
        self.lastPriceBar.low = initialPriceBar.close
        self.lastPriceBar.open = initialPriceBar.close
        self.lastPriceBar.volume = 0
        self.randomSeed = randomSeed
    }
    
    func startGeneratePriceBars() {
        
        timer = Timer(timeInterval: timeInerval,
                      target: self,
                      selector: #selector(onTimerElapsed),
                      userInfo: nil,
                      repeats: true)
        timer?.fire()
    }
    
    func stopGeneratePriceBars() {
        if let timer = timer, timer.isValid {
            timer.invalidate()
        }
    }
    
    func isRunning() -> Bool {
        if let timer = timer {
            return timer.isValid
        }
        return false
    }
    
    func getNextData() -> SCSMultiPaneItem {
        return getNextRandomPriceBar()
    }
    
    func getUpdateData() -> SCSMultiPaneItem {
        let num: Double = lastPriceBar.close + (SCSDataManager.randomize(0, max: Double(randomSeed)) - 48) * (lastPriceBar.close / 1000.0)
        let high: Double = num > lastPriceBar.high ? num : lastPriceBar.high
        let low: Double = num < lastPriceBar.low ? num : lastPriceBar.low
        let volumeInc = (SCSDataManager.randomize(0, max: Double(randomSeed)) * 3 + 2) * 0.5
        self.lastPriceBar.high = high
        self.lastPriceBar.low = low
        self.lastPriceBar.close = num
        self.lastPriceBar.volume += volumeInc
        return lastPriceBar
    }
    
    func getNextRandomPriceBar() -> SCSMultiPaneItem {
        
        let close: Double = lastPriceBar.close
        let num: Double = (SCSDataManager.randomize(0, max: Double(randomSeed)) - 0.9) * initialPriceBar.close / 30.0
        let num2: Double = SCSDataManager.randomize(0, max: Double(randomSeed))
        let num3: Double = initialPriceBar.close + initialPriceBar.close / 2.0 * sin(7.27220521664304E-06 * currentTime) + initialPriceBar.close / 16.0 * cos(7.27220521664304E-05 * currentTime) + initialPriceBar.close / 32.0 * sin(7.27220521664304E-05 * (10.0 + num2) * currentTime) + initialPriceBar.close / 64.0 * cos(7.27220521664304E-05 * (20.0 + num2) * currentTime) + num
        let num4: Double = fmax(close, num3)
        let num5: Double = Double(arc4random_uniform(UInt32(randomSeed))) * initialPriceBar.close / 100.0
        let high: Double = num4 + num5
        let num6: Double = fmin(close, num3)
        let num7: Double = Double(arc4random_uniform(UInt32(randomSeed))) * initialPriceBar.close / 100.0
        let low: Double = num6 - num7
        let volume = Int(arc4random_uniform(UInt32(randomSeed)) * 30000 + 20000)
        let openTime = simulateDateGap ? self.emulateDateGap(lastPriceBar.dateTime) : lastPriceBar.dateTime
        let closeTime = openTime.addingTimeInterval(TimeInterval(candleIntervalMinutes))
        let candle = SCSMultiPaneItem()
        candle.close = num3
        candle.dateTime = closeTime
        candle.high = high
        candle.low = low
        candle.volume = Double(volume)
        candle.open = close
        lastPriceBar = SCSMultiPaneItem()
        lastPriceBar.close = candle.close
        lastPriceBar.dateTime = candle.dateTime
        lastPriceBar.high = candle.high
        lastPriceBar.low = candle.low
        lastPriceBar.open = candle.open
        lastPriceBar.volume = candle.volume
        currentTime += Double(candleIntervalMinutes)
        
        return candle
    }
    
    func emulateDateGap(_ candleOpenTime: Date) -> Date {
        var result = candleOpenTime
        if candleOpenTime.timeIntervalSince1970 > closeMarketTime {
            var dateTime = candleOpenTime
            dateTime = dateTime.addingTimeInterval(500)
            result = dateTime.addingTimeInterval(openMarketTime)
        }
        while result.timeIntervalSince1970 < 500 {
            result = result.addingTimeInterval(500)
        }
        return result
    }
    
    @objc func onTimerElapsed() {
        if currentUpdateCount < updatesPerPrice {
            currentUpdateCount += 1
            let updatedData = getUpdateData()
            updateData!(updatedData)
        }
        else {
            self.currentUpdateCount = 0
            let nextData = getNextData()
            newData!(nextData)
        }
    }
    
    func clearEventHandlers() {
        
    }
    
    func tick() -> SCSMultiPaneItem {
        if currentUpdateCount < updatesPerPrice {
            currentUpdateCount += 1
            return getUpdateData()
        }
        else {
            self.currentUpdateCount = 0
            return getNextData()
        }
    }
    
}

class SCSMarketDataService {
    
    var startDate: Date!
    var timeFrameMinutes = 0
    var tickTimerIntervals = 0
    var generator: SCSRandomPriceDataSource!
    
    init(start startDate: Date, timeFrameMinutes: Int, tickTimerIntervals: Int) {
        
        self.startDate = startDate
        self.timeFrameMinutes = timeFrameMinutes
        self.tickTimerIntervals = tickTimerIntervals
        generator = SCSRandomPriceDataSource(candleIntervalMinutes: timeFrameMinutes,
                                             simulateDateGap: true,
                                             timeInterval: Double(tickTimerIntervals),
                                             updatesPerPrice: 25,
                                             randomSeed: 100,
                                             startingPrice: 30,
                                             start: startDate)
        
        
    }
    
    func getHistoricalData(_ numberBars: Int) -> [SCSMultiPaneItem] {
        var prices = [SCSMultiPaneItem]()
        for _ in 0..<numberBars {
            prices.append(generator.getNextData())
        }
        return prices
    }
    
    func getNextBar() -> SCSMultiPaneItem {
        return generator.tick()
    }
    
}

