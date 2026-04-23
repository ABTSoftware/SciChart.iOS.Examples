// ******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ChartViewController.swift is part of the SCICHART® PerformanceComparison.
// Permission is hereby granted to modify, create derivative works,
// distribute and publish any part of this source code whether for commercial,
// private or personal use.
//
// The SCICHART® PerformanceComparison are distributed in the hope
// that they will be useful, but without any warranty. It is provided "AS IS"
// without warranty of any kind, either expressed or implied.
// ******************************************************************************

import UIKit
import SciChart

class ChartViewController: UIViewController, ISpeedTestDelegate {
    // Change this for true if you want to have nice tests logs in console
    private let consoleLogEnabled = true
    
    @IBOutlet weak var fpsLabel: UILabel!
    @IBOutlet weak var fpsLabelPlaceholder: UIView!
    @IBOutlet weak var chartPlaceholder: UIView!
    
    private let testCases = TestCaseSequence()
    private var iterator: TestCaseSequence.Iterator!
    private var testResults = [SpeedTestResult]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.startTests()
    }
    
    private func startTests() {
        testResults.removeAll()

        iterator = testCases.makeIterator()
        if let test = iterator.next() {
            runTestCase(testCase: test)
        }
    }
    
    private func runTestCase(testCase: TestCase, deadline: DispatchTime = .now()) {
        let title = "\(testCase.chartProvider.rawValue) \(testCase.chartProviderParams) [\(iterator.currentTestIndex)/\(iterator.currentGroupTestCount)]"
        let subTitle = testCase.testParameters.description
        navigationItem.setTwoLineTitle(lineOne: title, lineTwo: subTitle)
        
        testCase.delegate = self
        testCase.fpsCounterDelegate = self
        
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            testCase.runTest(chartPlaceholder: self.chartPlaceholder)
        }
    }
    
    func testCompleted(speedTestResult: SpeedTestResult) {
        testResults.append(speedTestResult)
        if consoleLogEnabled {
            print(speedTestResult)
        }
        
        // Less than 5 FPS considered unacceptable
        // Memory usage more than 30% considered unacceptable
        if (speedTestResult.fps < 5.0 || MemoryUtil.memoryUsage > 0.3) {
            // Skip test which are left from the current group
            while let test = iterator.next() {
                testResults.append(test.discardTest())
            }
        }
        
        if let test = iterator.next() {
             // Next test if there are some in the current test group
            runTestCase(testCase: test)
        } else if let test = iterator.nextGroupTest() {
            // Test from the next group if there are groups left
            // Delay before new group, to allow system finish clean up all previoud resources
            runTestCase(testCase: test, deadline: .now() + 1)
        } else {
            // No groups left, testing finished
            presentFinishedAlert()
        }
    }
}

extension ChartViewController {
    private func presentFinishedAlert() {
        let alert = UIAlertController(title: "Finished", message: "All test cases have been finished.", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Share Results", style: .default, handler: { _ in
            self.shareTestResults()
        }))
        alert.addAction(UIAlertAction(title: "Run test again", style: .default, handler: { _ in
            self.startTests()
        }))
        alert.addAction(UIAlertAction(title: "Exit Application", style: .cancel, handler: { _ in
            exit(0)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func shareTestResults() {
        let csvAllMetrics = CsvUtil.exportToCsv(testResults: testResults, metricsToExport: MeasuredMetrics.allCases)
        let csvFpsOnly = CsvUtil.exportToCsv(testResults: testResults, metricsToExport: [.fps])
        
        let csvAllMetricsData = csvAllMetrics.data(using: .utf8)
        let csvFpsOnlyData = csvFpsOnly.data(using: .utf8)
        
        let allMetricsURL = csvAllMetricsData?.dataToFile(fileName: "AllMetricsComparison.csv")
        let fpsURL = csvFpsOnlyData?.dataToFile(fileName: "FPSComparison.csv")
        
        let filesToShare = [allMetricsURL!, fpsURL!]
        
        let activityViewController = UIActivityViewController(activityItems: filesToShare, applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            self.presentFinishedAlert()
        }
        
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension ChartViewController: FpsCounterDelegate {
  
    func didUpdate(framesPerSecond: Double) {
        fpsLabel.text = "\(framesPerSecond.format(f: 2)) FPS"
        
        switch framesPerSecond {
        case 40...:
            fpsLabelPlaceholder.backgroundColor = UIColor.fromARGBColorCode(0xff42B649)
        case 20...:
            fpsLabelPlaceholder.backgroundColor = .orange
        default:
            fpsLabelPlaceholder.backgroundColor = .red
        }
    }
}
