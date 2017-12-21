//
//  SCSDataManager.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/2/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart
import Accelerate

typealias OnNewData = (_ sender: SCSMultiPaneItem) -> Void

class SCSDataManager {

    class func getLissajousCurve(dataSeries:SCIXyDataSeries, alpha:Double, beta:Double, delta:Double, count:Int){
        // From http://en.wikipedia.org/wiki/Lissajous_curve
        // x = Asin(at + d), y = Bsin(bt)
        for i in 0..<count {
            dataSeries.appendX(SCIGeneric(sin(alpha * Double(i) * 0.1 + delta)),
                               y: SCIGeneric(sin(beta * Double(i) * 0.1)))
        }

    }
    
    class func getStraightLine(series:SCIXyDataSeries, gradient:(Double), yIntercept:(Double), pointCount:(Int)) {
        for i in 0..<pointCount {
        let x = Double(i) + 1;
            series.appendX(SCIGeneric(x), y: SCIGeneric(gradient*x+yIntercept))
        }
    }

    
    static fileprivate func generateXDateTimeSeries(with yValues: [Int]) -> SCIXyDataSeriesProtocol {
        let dataSeries = SCIXyDataSeries(xType: .dateTime, yType: .double)
        for i in 0..<yValues.count {
            let date = Date(timeIntervalSince1970: Double(60 * 60 * 24 * i))
            let xData = SCIGeneric(date)
            let value: Double = CDouble(yValues[i])
            dataSeries.appendX(xData, y: SCIGeneric(value))
        }
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        return dataSeries
    }

    static open func getRandomDoubleSeries(data: SCIXyDataSeriesProtocol, count: Int) {
        let amplitude = drand48() + 0.5;
        let freq = Double.pi * (drand48() + 0.5) * 10;
        let offset = drand48() - 0.5;

        for i in 0..<count {
            data.appendX(SCIGeneric(i), y: SCIGeneric(offset + amplitude + sin(freq * Double(i))))
        }
    }

    static open func getExponentialCurve(data: SCIXyDataSeriesProtocol, count: Int, exponent: Double) {
        var x = 0.00001;
        var y = 0.0;
        let fudgeFactor = 1.4;

        for i in 0..<count {
            x *= fudgeFactor
            y = pow(Double(i + 1), exponent)

            data.appendX(SCIGeneric(x), y: SCIGeneric(y))
        }
    }

    static open func porkDataSeries() -> SCIDataSeriesProtocol {
        let porkData = [10, 13, 7, 16, 4, 6, 20, 14, 16, 10, 24, 11]
        let dataSeries = generateXDateTimeSeries(with: porkData)
        dataSeries.seriesName = "Pork"
        return dataSeries
    }

    static open func tomatoesDataSeries() -> SCIDataSeriesProtocol {
        let tomatoesData = [7, 30, 27, 24, 21, 15, 17, 26, 22, 28, 21, 22]
        let dataSeries = generateXDateTimeSeries(with: tomatoesData)
        dataSeries.seriesName = "Tomatoes"
        return dataSeries
    }

    static open func cucumberDataSeries() -> SCIDataSeriesProtocol {
        let cucumberData = [16, 10, 9, 8, 22, 14, 12, 27, 25, 23, 17, 17]
        let dataSeries = generateXDateTimeSeries(with: cucumberData)
        dataSeries.seriesName = "Cucumber"
        return dataSeries
    }

    static open func vealDataSeries() -> SCIDataSeriesProtocol {
        let vealData = [12, 17, 21, 15, 19, 18, 13, 21, 22, 20, 5, 10]
        let dataSeries = generateXDateTimeSeries(with: vealData)
        dataSeries.seriesName = "Veal"
        return dataSeries
    }

    static open func pepperDataSeries() -> SCIDataSeriesProtocol {
        let pepperData = [7, 24, 21, 11, 19, 17, 14, 27, 26, 22, 28, 16]
        let dataSeries = generateXDateTimeSeries(with: pepperData)
        dataSeries.seriesName = "Pepper"
        return dataSeries
    }

    static open func stackedBarChartSeries() -> [SCIDataSeriesProtocol] {
        var dataSeries = [SCIDataSeriesProtocol]()
        var yValues_1 = [0.0, 0.1, 0.2, 0.4, 0.8, 1.1, 1.5, 2.4, 4.6, 8.1, 11.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 5.4, 6.4, 7.1, 8.0, 9.0]
        var yValues_2 = [2.0, 10.1, 10.2, 10.4, 10.8, 1.1, 11.5, 3.4, 4.6, 0.1, 1.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 1.4, 0.4, 10.1, 0.0, 0.0]
        var yValues_3 = [20.0, 4.1, 4.2, 10.4, 10.8, 1.1, 11.5, 3.4, 4.6, 5.1, 5.7, 14.4, 16.0, 13.7, 10.1, 6.4, 3.5, 2.5, 1.4, 10.4, 8.1, 10.0, 15.0]
        let data1 = SCIXyDataSeries(xType: .double, yType: .double)
        let data2 = SCIXyDataSeries(xType: .double, yType: .double)
        let data3 = SCIXyDataSeries(xType: .double, yType: .double)
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

        var china : [Double] = [1.269, 1.330, 1.356, 1.304]
        var india : [Double] = [1.004, 1.173, 1.236, 1.656]
        var usa : [Double] = [0.282, 0.310, 0.319, 0.439]
        var indonesia : [Double] = [0.214, 0.243, 0.254, 0.313]
        var brazil : [Double] = [0.176, 0.201, 0.203, 0.261]
        var pakistan : [Double] = [0.146, 0.184, 0.196, 0.276]
        var nigeria : [Double] = [0.123, 0.152, 0.177, 0.264]
        var bangladesh : [Double] = [0.130, 0.156, 0.166, 0.234]
        var russia : [Double] = [0.147, 0.139, 0.142, 0.109]
        var japan : [Double] = [0.126, 0.127, 0.127, 0.094]
        var restOfWorld : [Double] = [2.466, 2.829, 3.005, 4.306]

        let data1 = SCIXyDataSeries(xType: .double, yType: .double)
        let data2 = SCIXyDataSeries(xType: .double, yType: .double)
        let data3 = SCIXyDataSeries(xType: .double, yType: .double)
        let data4 = SCIXyDataSeries(xType: .double, yType: .double)
        let data5 = SCIXyDataSeries(xType: .double, yType: .double)
        let data6 = SCIXyDataSeries(xType: .double, yType: .double)
        let data7 = SCIXyDataSeries(xType: .double, yType: .double)
        let data8 = SCIXyDataSeries(xType: .double, yType: .double)
        let data9 = SCIXyDataSeries(xType: .double, yType: .double)
        let data10 = SCIXyDataSeries(xType: .double, yType: .double)
        let data11 = SCIXyDataSeries(xType: .double, yType: .double)
        let data12 = SCIXyDataSeries(xType: .double, yType: .double)

        for i in 0..<4 {
            var xValue: Double = 2000
            if i == 1 {
                xValue = 2010
            } else if i == 2 {
                xValue = 2014
            } else if i == 3 {
                xValue = 2050
            }

            data1.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(china[i])))
            if i != 2 {
                data2.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(india[i])))
                data3.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(usa[i])))
                data4.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(indonesia[i])))
                data5.appendX(SCIGeneric(xValue), y: SCIGeneric(CDouble(brazil[i])))
            } else {
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
            
            let asia = china[i] + india[i] + indonesia[i]
            let asia2 = bangladesh[i] + japan[i]
            let newWorld = usa[i] + brazil[i]
            let rest = pakistan[i] + nigeria[i] + russia[i] + restOfWorld[i]
            let all = asia+newWorld+rest+asia2
            data12.appendX(SCIGeneric(xValue), y: SCIGeneric(all))
        }
        let dataSeries = [data1, data2, data3, data4, data5, data6, data7, data8, data9, data10, data11, data12]
        return dataSeries

    }

    class func getPriceIndu(dataSeries: SCIOhlcDataSeriesProtocol, fileName: String) {
        if let resourcePath = Bundle.main.resourcePath {
            let filePath = resourcePath + "/" + fileName + ".csv"
            do {
                let contentFile = try? String.init(contentsOfFile: filePath, encoding: String.Encoding.utf8)

                let items = contentFile?.components(separatedBy: "\r\n")

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "LL/dd/yyyy"


                for i in 0..<(items?.count)! - 1 {

                    let subItems = (items?[i].components(separatedBy: ","))! as [String]

                    let date:Date = dateFormatter.date(from: subItems[0])!

                    dataSeries.appendX(SCIGeneric(date),
                                       open: SCIGeneric(Float(subItems[1])!),
                                       high: SCIGeneric(Float(subItems[2])!),
                                       low: SCIGeneric(Float(subItems[3])!),
                                       close: SCIGeneric(Float(subItems[4])!))
                }
            }
        }
    }

    static open func stackedVerticalColumnSeries() -> [SCIDataSeriesProtocol] {
        return [porkDataSeries(), vealDataSeries(), tomatoesDataSeries(), cucumberDataSeries(), pepperDataSeries()]
    }

    static func loadData<DataSeriesType:SCIXyDataSeriesProtocol>(into dataSeries: DataSeriesType,
                                                                 fileName: String,
                                                                 startIndex: Int,
                                                                 increment: Int,
                                                                 reverse: Bool) {


        if let resourcePath = Bundle.main.resourcePath {
            let filePath = resourcePath + "/" + fileName + ".txt"
            do {
                let contentFile = try NSString(contentsOfFile: filePath, usedEncoding: nil) as String

                let items = contentFile.components(separatedBy: "\n")

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"

                if reverse {
                    var i = items.count - 1
                    while i >= startIndex {

                        let subItems = items[i].components(separatedBy: ",")

                        let date = dateFormatter.date(from: subItems[0])
                        let value = Float(subItems[1])

                        dataSeries.appendX(SCIGeneric(date!), y: SCIGeneric(value!))

                        i = i - increment
                    }

                } else {
                    var i = startIndex
                    while i < items.count {

                        let subItems = items[i].components(separatedBy: ",")

                        let date = dateFormatter.date(from: subItems[0])
                        let value = Float(subItems[1])

                        dataSeries.appendX(SCIGeneric(date!), y: SCIGeneric(value!))

                        i = i + increment
                    }
                }
            } catch {


            }
        }
    }

    static func getTradeTicks(_ dataSeries: SCIXyzDataSeriesProtocol, fileName: String) {
        if let resourcePath = Bundle.main.resourcePath {
            let filePath = resourcePath + "/" + fileName + ".csv"
            do {
                let contentFile = try? String.init(contentsOfFile: filePath, encoding: String.Encoding.utf8)

                let items = contentFile?.components(separatedBy: "\r\n")

                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss.s"


                for i in 0..<(items?.count)! - 1 {

                    let subItems = (items?[i].components(separatedBy: ","))! as [String]

                    let date = dateFormatter.date(from: subItems[0])
                    let value = Float(subItems[1])
                    let zValue = Float(subItems[2])

                    dataSeries.appendX(SCIGeneric(date!), y: SCIGeneric(value!), z: SCIGeneric(zValue!))
                }
            }
        }
    }

    static func putDataInto(_ dataSeries: SCIXyDataSeries) {
        let dataCount = 20
        var i = 0
        while i <= dataCount {
            let x = 10.0 * Float(i) / Float(dataCount)
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
            let x = Float(10.0 * Float(i) / Float(dataCount))
            let y = 2 * sin(x) + 10
            dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
            i = i + 1
        }
    }

    static func setFourierDataInto(_ dataSeries: SCIXyDataSeries, amplitude: (Double), phaseShift: (Double), count: (Int)) {
        for i in 0..<count {
            let time = 10 * Double(i) / Double(count);
            let wn = 2 * .pi / Double(count / 10);
            let y1 = sin(Double(i) * wn + phaseShift)
            let y2 = 0.33 * sin(Double(i) * 3 * wn + phaseShift)
            let y3 = 0.20 * sin(Double(i) * 5 * wn + phaseShift)
            let y4 = 0.14 * sin(Double(i) * 7 * wn + phaseShift)
            let y5 = 0.11 * sin(Double(i) * 9 * wn + phaseShift)
            let y6 = 0.09 * sin(Double(i) * 11 * wn + phaseShift)
            let y = .pi * amplitude * (y1 + y2 + y3 + y4 + y5 + y6);
            dataSeries.appendX(SCIGeneric(time), y: SCIGeneric(y))
        }
    }

    static func getFourierDataZoomed(_ dataSeries: SCIXyDataSeries, amplitude: (Double), phaseShift: (Double), xStart: (Double), xEnd: (Double), count: (Int)) {
        self.setFourierDataInto(dataSeries, amplitude: amplitude, phaseShift: phaseShift, count: 5000)

        var index0: Int = 0
        var index1: Int = 0

        for i in 0..<count {
            if (SCIGenericDouble(dataSeries.xValues().value(at: Int32(i))) > xStart && index0 == 0) {
                index0 = i;
            }

            if (SCIGenericDouble(dataSeries.xValues().value(at: Int32(i))) > xEnd && index1 == 0) {
                index1 = i;
                break;
            }
        }

        dataSeries.xValues().removeRange(from: Int32(index1), count: Int32(count - index1))
        dataSeries.yValues().removeRange(from: Int32(index1), count: Int32(count - index1))
        dataSeries.xValues().removeRange(from: 0, count: Int32(index0))
        dataSeries.yValues().removeRange(from: 0, count: Int32(index0))
    }

    static func randomize(_ min: Double, max: Double) -> Double {
        return RandomUtil.nextDouble() * (max - min) + min
    }

    static open func loadPriceData(into dataSeries: SCIOhlcDataSeriesProtocol, fileName: String, isReversed: Bool, count: Int) {

        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")!
        let data = try! String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        let items = data.components(separatedBy: "\n")
        var subItems = [String]()
        if !isReversed {
            for i in 0..<count {
                subItems = items[i].components(separatedBy: ",")
                dataSeries.appendX(SCIGeneric(i),
                                   open: SCIGeneric(Float(subItems[1])!),
                                   high: SCIGeneric(Float(subItems[2])!),
                                   low: SCIGeneric(Float(subItems[3])!),
                                   close: SCIGeneric(Float(subItems[4])!))
            }
        } else {
            var j = 0
            var i = count - 1
            while i >= 0 {
                subItems = items[i].components(separatedBy: ",")
                dataSeries.appendX(SCIGeneric(j),
                                   open: SCIGeneric(Float(subItems[1])!),
                                   high: SCIGeneric(Float(subItems[2])!),
                                   low: SCIGeneric(Float(subItems[3])!),
                                   close: SCIGeneric(Float(subItems[4])!))
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

    static open func loadData(into dataSeries: SCIXyDataSeriesProtocol, from fileName: String) {

        let filePath = Bundle.main.path(forResource: fileName, ofType: "txt")!
        let data = try! String(contentsOfFile: filePath, encoding: String.Encoding.utf8)
        let items = data.components(separatedBy: "\n")

        for i in 0..<items.count {
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(Float(items[i])!))
        }

    }

    static func getDampedSinewave(_ amplitude: Double, dampingFactor: Double, pointCount: Int32, freq: Int32) -> DoubleSeries {
        return self.getDampedSinewave(0, amplitude: amplitude, phase: 0.0, dampingFactor: dampingFactor, pointCount: pointCount, freq: freq)
    }
    
    static func getDampedSinewave(_ pad: Int32, amplitude: Double, phase: Double, dampingFactor: Double, pointCount: Int32, freq: Int32) -> DoubleSeries {
        let doubleSeries = DoubleSeries(capacity: pointCount)

        for i in 0..<pad {
            let time = 10 * Double(i) / Double(pointCount)
            doubleSeries.addX(time, y: 0)
        }
        
        var i = pad
        var j = 0
        var mutableAmplitude = amplitude
        while i < pointCount {
            let time = 10.0 * Double(i) / Double(pointCount)
            let wn = 2.0 * .pi / (Double(pointCount) / Double(freq))
            
            let d: Double = mutableAmplitude * sin(Double(j) * wn + phase)
            doubleSeries.addX(time, y: d)
            
            mutableAmplitude *= (1.0 - dampingFactor)
            i += 1
            j += 1
        }
        
        return doubleSeries
    }
    
    static func getSinewave(_ amplitude: Double, phase: Double, pointCount: Int32, freq: Int32) -> DoubleSeries {
        return self.getDampedSinewave(0, amplitude: amplitude, phase: phase, dampingFactor: 0, pointCount: pointCount, freq: freq)
    }
    
    static func getSinewave(_ amplitude: Double, phase: Double, pointCount: Int32) -> DoubleSeries {
        return self.getSinewave(amplitude, phase: phase, pointCount: pointCount, freq: 10)
    }

    static func getNoisySinewave(_ amplitude: Double, phase: Double, pointCount: Int32, noiseAmplitude: Double) -> DoubleSeries {
        let doubleSeries: DoubleSeries? = self.getSinewave(amplitude, phase: phase, pointCount: pointCount)
        let yValues: SCIGenericType? = doubleSeries?.yValues
       
        for i in 0..<pointCount {
            
            let y = SCIGenericDoublePtr(yValues!)[Int(i)]

            SCIGenericDoublePtr(yValues!)[Int(i)] = y + RandomUtil.nextDouble() * noiseAmplitude - noiseAmplitude * 0.5
        }
        
        return doubleSeries!
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
    private var total: Double = 0.0

    init(length: Int) {
        self.length = length
        oneOverLength = 1.0 / Double(length)
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
        } else {
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
        let num: Double = (drand48() - 0.9) * initialPriceBar.close / 30.0
        let num2: Double = drand48()
        let num3: Double = initialPriceBar.close + initialPriceBar.close / 2.0 * sin(7.27220521664304E-06 * currentTime) + initialPriceBar.close / 16.0 * cos(7.27220521664304E-05 * currentTime) + initialPriceBar.close / 32.0 * sin(7.27220521664304E-05 * (10.0 + num2) * currentTime) + initialPriceBar.close / 64.0 * cos(7.27220521664304E-05 * (20.0 + num2) * currentTime) + num
        let num4: Double = fmax(close, num3)
        let num5: Double = drand48() * initialPriceBar.close / 100.0
        let high: Double = num4 + num5
        let num6: Double = fmin(close, num3)
        let num7: Double = drand48() * initialPriceBar.close / 100.0
        let low: Double = num6 - num7
        let volume = Int(drand48() * 30000 + 20000)
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
        } else {
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
        } else {
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
