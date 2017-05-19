//
//  ViewController.swift
//  SciChartShowcaseDemo
//
//  Created by Mykola Hrybeniuk on 2/22/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import UIKit

struct ListExamplesSeguesId {
    static let medical = "MedicalExampleSegueId"
    static let audio = "AudioExampleSegueId"
    static let trader = "TraderExampleSegueId"
    static let dashboard = "DashboardExampleSegueId"
    static let sales = "SalesDashboardExampleSegueId"
}

class ListExamplesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var examplesTableView: UITableView!
    
    let dataSource = [ExampleItem("Heartbeat ECG", "This is a brand new way of presenting some medical data.", "MedicalExample", ListExamplesSeguesId.medical),
                      ExampleItem("Audio Analyzer", "And this is a brand new way of presenting audio data.", "AudioAnalyzerExample", ListExamplesSeguesId.audio),
                      ExampleItem("Trader", "Another cool example, which shows how amazing we are when you need to display trading data.", "", ListExamplesSeguesId.trader),
                      ExampleItem("Dashboard", "", "", ListExamplesSeguesId.dashboard),
                      ExampleItem("Sales Dashboard", "", "", ListExamplesSeguesId.sales)]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        examplesTableView.delegate = self
        examplesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            return
        }
        performSegue(withIdentifier: dataSource[indexPath.row - 1].segueId, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count + 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return self.examplesTableView.dequeueReusableCell(withIdentifier: "exampleTableViewHeader")! as UITableViewCell
        }
        else{
        let cell: ExampleTableViewCell = Bundle.main.loadNibNamed("ExampleTableViewCell", owner: self, options: nil)![0] as! ExampleTableViewCell
        cell.updateContent(exampleDetails: dataSource[indexPath.row-1])
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
        return 70
        }
        return 160
    }
}

