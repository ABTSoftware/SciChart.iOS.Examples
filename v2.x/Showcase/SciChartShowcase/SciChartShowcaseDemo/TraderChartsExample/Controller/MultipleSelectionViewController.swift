//
//  MultipleSelectionViewController.swift
//  SciChartShowcaseDemo
//
//  Created by Gkol on 7/31/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation


class MultipleSelectionViewController<T: Equatable> : UIViewController, UITableViewDelegate, UITableViewDataSource where T:CustomStringConvertible {

    @IBOutlet weak var tableView: UITableView!
    
    private var items: [T] = []
    private var selectedItems: [T] = []
    private var completionSelecting: ((_ selctedItems:[T]) -> Void)?
    
    // MARK: Public methods
    
    func setupList(with list: [T], selected:[T]?, hanlder: @escaping (_ selctedItems:[T]) -> Void) -> MultipleSelectionViewController {
        items = list
        if let preSelected = selected {
            selectedItems = preSelected
        }
        completionSelecting = hanlder
        return self;
    }
    
    func showWithCrossDissolveStyle(over controller: UIViewController) {
        modalPresentationStyle = .overCurrentContext
        modalTransitionStyle = .crossDissolve
        controller.present(self, animated: true, completion: nil)
    }
    
    // MARK: IBActions
    
    @IBAction func onCancelClick(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDoneClick(_ sender: Any) {
        if let callBack = completionSelecting {
            callBack(selectedItems)
        }
        dismiss(animated: true, completion: nil)
    }

    // MARK: Overrided Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isEditing = true
    }
    
    // MARK: TablewView DataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell : UITableViewCell
        
        if let cellIs = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            cell = cellIs
        }
        else {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellIdentifier)
        }
        
        cell.textLabel?.text = items[indexPath.row].description

        if selectedItems.contains(items[indexPath.row]) {
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .none)
        }

        return cell;

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItems.append(items[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedItems.remove(at: selectedItems.index(of: items[indexPath.row])!)
    }
    
}
