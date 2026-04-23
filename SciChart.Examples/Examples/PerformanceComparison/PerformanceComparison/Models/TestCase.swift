// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TestCase.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit

class TestCase {

    public let testParameters: TestParameters
    public let chartProvider: ChartProviderType
    public let chartProviderParams: IChartProviderParameters
    
    private var speedTest: ISpeedTest?
    var delegate: ISpeedTestDelegate?
    var fpsCounterDelegate: FpsCounterDelegate?

    // FPS properties
    private var displayLink: CADisplayLink?
    private var frameCount: UInt = 0
    private var startTime: TimeInterval = 0
    private var startUpTime: TimeInterval = 0
    
    init(testParameters: TestParameters, chartProvider: ChartProviderType, chartProviderParams: IChartProviderParameters) {
        self.testParameters = testParameters
        self.chartProvider = chartProvider
        self.chartProviderParams = chartProviderParams
    }
    
    func runTest(chartPlaceholder: UIView) {
        let testCaseClassName = "\(testParameters.type.rawValue)SpeedTest\(chartProvider.rawValue)"
        guard let viewType: SpeedTestBase.Type = testCaseClassName.toClass() else {
            return
        }

        let chartInitializationStartTime = Date()
        if let speedTest = viewType.init() as? ISpeedTest {
            speedTest.setUpChart(parent: chartPlaceholder, testParameters: testParameters, chartProviderParameters: chartProviderParams)
            speedTest.initChart(testParameters: testParameters)
            self.speedTest = speedTest
            
            startUpTime = fabs(chartInitializationStartTime.timeIntervalSinceNow)
            
            startDisplayLink()
        }
    }
    
    func discardTest() -> SpeedTestResult {
        return SpeedTestResult(
            testName: testParameters.description,
            chartProvider: chartProvider,
            chartProviderParameters: chartProviderParams,
            fps: 0,
            cpuUsage: 0,
            memoryUsed: 0,
            startUpTime: 0
        )
    }
        
    private func startDisplayLink() {
        startTime = CACurrentMediaTime()
        
        displayLink = CADisplayLink(target: self, selector: #selector(frameUpdated))
        displayLink?.add(to: RunLoop.main, forMode: .default)
    }

    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func frameUpdated() {
        frameCount += 1
        let currentTimestamp = displayLink!.timestamp
        let timeElapsed = currentTimestamp - startTime
        
        let fpsData = Double(frameCount) / timeElapsed
        fpsCounterDelegate?.didUpdate(framesPerSecond: fpsData)
        
        if timeElapsed < testParameters.duration {
            speedTest!.updateChart(testParameters: testParameters)
        } else {
            stopDisplayLink()
            speedTest?.clear()
            speedTest = nil

            self.frameCount = 0
            self.startTime = currentTimestamp

            let cpuUsage = CpuUtil.getUsage()
            let memoryUsed = MemoryUtil.getMemoryUsed()

            let result = SpeedTestResult(
                testName: testParameters.description,
                chartProvider: chartProvider,
                chartProviderParameters: chartProviderParams,
                fps: fpsData,
                cpuUsage: cpuUsage,
                memoryUsed: memoryUsed,
                startUpTime: startUpTime
            )
            
            delegate?.testCompleted(speedTestResult: result)
        }
    }
}
