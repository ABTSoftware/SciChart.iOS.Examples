//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSFPSCheck.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation
import MachO
import UIKit
import QuartzCore
import Darwin


struct SCSTestKeys {
    static let kFIFOTypeTest = "SCSFIFOSpeedTestSciChart"
    static let kSeriesTypeTest = "SCSNxMSeriesSpeedTestSciChart"
    static let kScatterTypeTest = "SCSScatterSpeedTestSciChart"
    static let kAppendTypeTest = "SCSAppendSpeedTestSciChart"
    static let kSeriesAppendTypetest = "SCSSeriesAppendingTestSciChart"
}

enum SCSResamplingMode : Int {
    case none
    case minMax
    case mid
    case max
    case min
    case nyquist
    case cluster2D
    case minMaxWithUnevenSpacing
    case auto
}

struct SCSTestParameters {
    var resamplingMode : SCSResamplingMode = .none
    var pointCount = 0
    var seriesNumber = 0
    var strokeThikness = 1.0
    var appendPoints = 0
    var duration: Double = 0.0
    var timeScale: Double = 0.0
}


protocol SCSDrawingProtocolDelegate {
    
    func processCompleted(_ testCaseData: [Any])
    
    func processCompleted()
    
    func chartExampleStarted()
    
}

protocol SCSSpeedTestProtocol {
    
    var delegate: SCSDrawingProtocolDelegate? { get set }
    
    var chartProviderName: String { get set }
    
    func run(_ testParameters: SCSTestParameters)
    
    func updateChart()
    
    func stop()
    
}

class SCSFPSCheck <T: SCSSpeedTestProtocol> : SCSDrawingProtocolDelegate where T: UIView {

    var version  = ""
    var chartTypeTest = ""
    var testParameters = SCSTestParameters()
    
    var displayLink : CADisplayLink!
    var secondDisplay : CADisplayLink!
    var startTime = CFTimeInterval()
    var frameCount = 0.0
    var isCompleted = false
    weak var chartUIView : T!
    weak var parentViewController : UIViewController!
    
    var fpsdata: Double = 0.0
    var cpudata: Double = 0.0
    var result = [[Any]]()
    var testcaseName = ""
    var chartProviderStartTime: Date!
    var chartTakenTime = TimeInterval()
    var calculateStartTime = false
    var timeIsOut = false
    
    var delegate: SCSDrawingProtocolDelegate?
    
    init(_ version: String, _ chartUIView: T, _ testKey: String) {
        self.chartUIView = chartUIView
        self.version = version
        self.chartTypeTest = testKey
        testParameters = parameters(forTypeTest: chartTypeTest)
    }
    
    internal func processCompleted(_ testCaseData: [Any]) {
        
    }
    
    func parameters(forTypeTest typeTest: String) -> SCSTestParameters {
        let typeTest = typeTest.replacingOccurrences(of: "SciChartSwiftDemo.", with: "")
        if (typeTest == SCSTestKeys.kScatterTypeTest) {
            var testParameters = SCSTestParameters()
            testParameters.pointCount = 10000
            testParameters.duration = 10.0
            return testParameters
        }
        else if (typeTest == SCSTestKeys.kFIFOTypeTest) {
            var testParameters = SCSTestParameters()
            testParameters.pointCount = 1000
            testParameters.strokeThikness = 1.0
            testParameters.duration = 10.0
            return testParameters
        }
        else if (typeTest == SCSTestKeys.kSeriesTypeTest) {
            var testParameters = SCSTestParameters()
            testParameters.seriesNumber = 100
            testParameters.pointCount = 100
            testParameters.strokeThikness = 1.0
            testParameters.duration = 10.0
            return testParameters
        }
        else if (typeTest == SCSTestKeys.kAppendTypeTest) {
            var testParameters = SCSTestParameters()
            testParameters.pointCount = 10000
            testParameters.appendPoints = 1000
            testParameters.strokeThikness = 1
            testParameters.duration = 10.0
            return testParameters
        }
        else if (typeTest == SCSTestKeys.kSeriesAppendTypetest) {
            var testParameters = SCSTestParameters()
            testParameters.pointCount = 500
            testParameters.appendPoints = 500
            testParameters.strokeThikness = 0.5
            testParameters.duration = 30.0
            testParameters.seriesNumber = 3
            return testParameters
        }
        
        var testParameters = SCSTestParameters()
        testParameters.pointCount = 1000
        testParameters.duration = 10.0
        return testParameters
    }
    
    func processCompleted() {
        if !timeIsOut {
            prepareResults()
        }
        stopDisplayLink()
//        if chartUIView {
//            chartUIView.removeFromSuperview()
//            self.chartUIView = SpeedTest()
//        }
        if let delegate = delegate {
            delegate.processCompleted(result)
        }
    }
    
    func chartExampleStarted() {
        if calculateStartTime {
            chartTakenTime = fabs(chartProviderStartTime.timeIntervalSinceNow)
            calculateStartTime = false
        }
    }
    
    func runTest(_ vc: UIViewController) {
        result = [[Int]]()
        parentViewController = vc
        running()
    }
    
    func running() {
        timeIsOut = false
        chartProviderStartTime = Date()
        chartUIView.delegate = self
        chartUIView.run(testParameters)
        startDisplayLink()
    }
    
    func startDisplayLink() {
        isCompleted = false
        calculateStartTime = true
        displayLink = CADisplayLink(target: self, selector: #selector(calcFps))
        startTime = CACurrentMediaTime()
        displayLink.add(to: RunLoop.current, forMode: .defaultRunLoopMode)
    }
    
    func stopDisplayLink() {
        isCompleted = true
        displayLink.invalidate()
        displayLink = nil
    }
    
    @objc func calcFps(_ displayLink: CADisplayLink) {
        frameCount += 1
        cpudata += usageCPU().user
        let elapsed = displayLink.timestamp - startTime
        if elapsed >= testParameters.duration {
            timeIsOut = true
            prepareResults()
            chartUIView.stop()
        }
        else {
            chartUIView.updateChart()
        }
    }
    
    private func prepareResults() {
        let elapsed = self.displayLink.timestamp - self.startTime
        fpsdata = frameCount / elapsed
        cpudata = cpudata/frameCount
        self.frameCount = 0
        self.startTime = self.displayLink.timestamp
        result.append(["", chartUIView.chartProviderName, fpsdata, cpudata, Date(timeIntervalSinceReferenceDate: chartTakenTime)])
    }
    

    private let HOST_CPU_LOAD_INFO_COUNT : mach_msg_type_number_t = UInt32(MemoryLayout<host_cpu_load_info_data_t>.size / MemoryLayout<integer_t>.size)
    
    private var loadPrevious = host_cpu_load_info()
    
    public func usageCPU() -> (system : Double,
        user   : Double,
        idle   : Double,
        nice   : Double) {
            let load = self.hostCPULoadInfo()
            
            let userDiff = Double(load.cpu_ticks.0 - loadPrevious.cpu_ticks.0)
            let sysDiff  = Double(load.cpu_ticks.1 - loadPrevious.cpu_ticks.1)
            let idleDiff = Double(load.cpu_ticks.2 - loadPrevious.cpu_ticks.2)
            let niceDiff = Double(load.cpu_ticks.3 - loadPrevious.cpu_ticks.3)
            
            let totalTicks = sysDiff + userDiff + niceDiff + idleDiff
            
            let sys  = sysDiff  / totalTicks * 100.0
            let user = userDiff / totalTicks * 100.0
            let idle = idleDiff / totalTicks * 100.0
            let nice = niceDiff / totalTicks * 100.0
            
            loadPrevious = load
            
            // TODO: 2 decimal places
            // TODO: Check that total is 100%
            return (sys, user, idle, nice)
    }
    
    private func hostCPULoadInfo() -> host_cpu_load_info {
        var size     = HOST_CPU_LOAD_INFO_COUNT
        var hostInfo = host_cpu_load_info()
        
        let result = withUnsafeMutablePointer(to: &hostInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(size)) {
                host_statistics(mach_host_self(), Int32(HOST_CPU_LOAD_INFO), $0, &size)
            }
        }
        
        #if DEBUG
            if result != KERN_SUCCESS {
                print("ERROR - \(#file):\(#function) - kern_result_t = "
                    + "\(result)")
            }
        #endif
        
        return hostInfo
    }
    
    
}
