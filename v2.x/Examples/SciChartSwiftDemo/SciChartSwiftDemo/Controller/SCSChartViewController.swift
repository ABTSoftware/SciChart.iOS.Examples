//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSChartViewController.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit
import SciChart

class SCSChartViewController: UIViewController, SCSDrawingProtocolDelegate {
    
    var caseTest : SCSFPSCheck<SCSTestBaseView>?
    var viewClass : UIView.Type?
    var chartView : UIView?

    func setupView(_ viewClass: UIView.Type) {
        
        self.viewClass = viewClass
        
        let chartView = viewClass.init()
        

        self.chartView = chartView
        
        if let _chartView = chartView as? SCSTestBaseView  {
            
            let anyClassType = type(of: _chartView)
            let chartTypeTest = anyClassType.description()
            
            let caseTest = SCSFPSCheck<SCSTestBaseView>("", _chartView, chartTypeTest)
            caseTest.delegate = self
            caseTest.runTest(self)
            self.caseTest = caseTest
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        chartView?.frame.size = view.frame.size
        chartView?.frame.origin = CGPoint()
        chartView?.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        chartView?.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(chartView!)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let caseTest = caseTest {
            if !(caseTest.isCompleted) {
                caseTest.processCompleted()
                if let view = chartView {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    func processCompleted() {
        
    }
    
    func chartExampleStarted() {
        
    }
    
    func processCompleted(_ testCaseData: [Any]) {
        
        if let view = chartView {
            view.removeFromSuperview()
        }
        
        
        if let results = testCaseData.first as? NSArray, navigationController?.topViewController == self  {
            
            let fps : NSNumber = results[2] as! NSNumber
            let cpu : NSNumber = results[3] as! NSNumber
            let date : Date = results[4] as! Date
            let formatDate = DateFormatter()
            formatDate.dateFormat = "s.SSS"
            let startTime = formatDate.string(from: date)
            
            let descr = String.localizedStringWithFormat("Average FPS: %.2f\nCPU Load: %.2f %%\nStart Time: %@", fps.doubleValue, cpu.doubleValue, startTime)
            let alertController = UIAlertController.init(title: "Finished", message: descr, preferredStyle: .alert)
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                
                _ = self.navigationController?.popViewController(animated: true)
                
            }))
                
            alertController.addAction(UIAlertAction(title: "Run Test Again", style: .default, handler: { (action) in
                if let viewClass = self.viewClass {
                    self.setupView(viewClass)
                }
            }))
            
            present(alertController, animated: true, completion: nil);
            
        }
        
    }

}

