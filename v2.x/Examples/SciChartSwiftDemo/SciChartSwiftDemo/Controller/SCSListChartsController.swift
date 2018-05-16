//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCSListChartsController.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit
import SciChart

let cellID = "SCSExampleTableViewCell"

class SCSListChartsController: UITableViewController {
    
    let cellId = "CellId"
    var categoryNames = [String]()
    var itemsOfCategories = [[SCSExampleItem]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let categoryList = SCSListDataSource()
        let listCategoriesItems : [String : [SCSExampleItem]] = categoryList.dataSource
        
        categoryNames = categoryList.categoryNames
        
        for categoryKey in categoryNames {
            if let items = listCategoriesItems[categoryKey] {
                itemsOfCategories.append(items)
            }
        }
        
        tableView.register(SCSTableViewHeader.classForCoder(), forHeaderFooterViewReuseIdentifier: SCSTableViewHeader.reuseId)
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return categoryNames.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsOfCategories[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableView.backgroundColor = UIColor.init(red:0.145, green:0.145, blue:0.145, alpha:1);
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? SCSExampleTableViewCell
        cell?.backgroundColor = UIColor.fromARGBColorCode(0x70424448)
        
        let itemsForSection = itemsOfCategories[indexPath.section]
        cell?.setup(with: itemsForSection[indexPath.row])
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SCSTableViewHeader.reuseId) as? SCSTableViewHeader
        header?.setupWithString(categoryNames[section])
        return header
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChartSegueId" {
         
            if let chartController = segue.destination as? SCSChartViewController, let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)!
                let className = "SciChartSwiftDemo."+itemsOfCategories[indexPath.section][indexPath.row].exampleClass
                let chartViewClass = NSClassFromString(className) as! UIView.Type
                chartController.loadViewIfNeeded()
                chartController.setupView(chartViewClass)
                chartController.title = "SciChart iOS | "+itemsOfCategories[indexPath.section][indexPath.row].exampleName
                
            }
        }
    }
}
