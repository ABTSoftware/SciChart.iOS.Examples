//
//  TraderExampleViewController.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 7/13/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

struct AxisIds {
    static let volumeYAxisId = "volumeYAxis"
}

struct ContextMenu {
    static let upItemId = "upItemId"
    static let downItemId = "downItemId"
    static let lineItemId = "lineItemId"
    static let textItemId = "textItemId"
    static let themeItemId = "themeItemId"
}



class TraderExampleViewController : BaseViewController, GNAMenuItemDelegate {
    
    //MARK: Filter Buttons
    @IBOutlet weak var stockTypeButton: UIButton!
    @IBOutlet weak var timePeriodButton: UIButton!
    @IBOutlet weak var timeScaleButton: UIButton!
    
    //MARK: Chart Surfaces
    @IBOutlet weak var mainPaneChartSurface: SCIChartSurface!
    @IBOutlet weak var subPaneRsiChartSurface: SCIChartSurface!
    @IBOutlet weak var subPaneMcadChartSurface: SCIChartSurface!
    
    @IBOutlet weak var topSeparatorView: DividerView!
    @IBOutlet weak var bottomSeparatorView: DividerView!
    
    @IBOutlet weak var noInternetConnectionLabel: UILabel!
    
    // MARK: Constraints for no internet connection message showing and hiding
    @IBOutlet weak var filterPanelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noInternetConnectionLeftConstraint: NSLayoutConstraint!
    
    // MARK: Panels Constraints
    @IBOutlet var mainPanelToMcadPanelConstraint: NSLayoutConstraint! // Default is not active
    @IBOutlet var mainPanelToRsiPanelConstraint: NSLayoutConstraint!
    @IBOutlet var rsiPanelToMcadPanelConstraint: NSLayoutConstraint!
    @IBOutlet var rsiPanelHeightConstraint: NSLayoutConstraint!
    @IBOutlet var macdPanelHeightConstraint: NSLayoutConstraint!
    
    // MARK: Ivar
    
    private var temporaryGesture: UIPanGestureRecognizer!
    private var lastLineAnnotation: SCILineAnnotation!
    private var surfacesConfigurator: TraderChartSurfacesConfigurator!
    private var menuView : GNAMenuView!
    private var defaultFrameView = CGRect()
    
    var traderModel: TraderViewModel! {
        didSet {
            surfacesConfigurator.setupSurfacesWithTraderModel(with: self.traderModel)
            stockTypeButton.setTitle(self.traderModel.stockType.description, for: .normal)
            timeScaleButton.setTitle(self.traderModel.timeScale.description, for: .normal)
            timePeriodButton.setTitle(self.traderModel.timePeriod.description, for: .normal)
        }
    }
    
    // MARK: Overrided methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        surfacesConfigurator = TraderChartSurfacesConfigurator(with: mainPaneChartSurface, subPaneRsiChartSurface, subPaneMcadChartSurface)
        surfacesConfigurator.textAnnotationsKeyboardEventsHandler = {[unowned self] (notification, textView) -> () in
            if notification.name == NSNotification.Name.UIKeyboardWillShow {
                self.defaultFrameView = self.view.frame
                let windowFrame = self.view.frame
                let finalkeyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect
                let visibleRect = CGRect(x: 0.0, y: 0.0, width: windowFrame.size.width, height: (finalkeyboardFrame?.origin.y)!)
                let rectInWindow = textView.superview?.convert(textView.frame, to: self.view)
                
                if visibleRect.contains(rectInWindow!) {
                    print("Text View is visible")
                }
                else {
                    print("Text View is hidden")
                    
                    let difference = (finalkeyboardFrame?.origin.y)! - ((rectInWindow?.origin.y)!+(rectInWindow?.height)!)
                    UIView.animate(withDuration: 0.25, animations: { 
                        self.view.frame = CGRect(x: 0.0, y: difference, width: self.view.frame.size.width, height:  self.view.frame.size.height)
                    })
                }
            }
            else {
                UIView.animate(withDuration: 0.25, animations: {
                    if let windowFrame = self.view.window?.frame {
                        self.view.frame = CGRect(x: 0.0, y: windowFrame.size.height - self.view.frame.size.height,
                                                 width: self.view.frame.size.width, height:  self.view.frame.size.height)
                    }
                })
            }
            
            
        }
        NotificationCenter.default.addObserver(self, selector: #selector(internetConnectionStatusChanged), name: .flagsChanged, object: Network.reachability)
        createMenuItem()
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadTradeModel()
        
        navigationController?.navigationBar.isHidden = false
        topSeparatorView.superview?.bringSubview(toFront: topSeparatorView)
        bottomSeparatorView.superview?.bringSubview(toFront: bottomSeparatorView)
        
        updateInternetConnectionInfo(false)
        let barButton = UIBarButtonItem(title: "Surface List", style: .plain, target: self, action: #selector(addSurfaceClick))
        navigationItem.setRightBarButton(barButton, animated: true)
        
        
        
    }

    // MARK: Private Methods
    
    private func createMenuItem() {

        let item1 = GNAMenuItem(icon: UIImage(named: "upContextMenu")!, activeIcon: UIImage(named: "upContextMenu"), title: "Up", frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50))
        item1.defaultLabelMargin = 20
        item1.itemId = ContextMenu.upItemId
        
        let item2 = GNAMenuItem(icon: UIImage(named: "downContextMenu")!, activeIcon: UIImage(named: "downContextMenu"), title: "Down", frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50))
        item2.defaultLabelMargin = 20
        item2.itemId = ContextMenu.downItemId
        
        let item3 = GNAMenuItem(icon: UIImage(named: "contextText")!, activeIcon: UIImage(named: "contextText"), title: "Text", frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50))
        item3.defaultLabelMargin = 20
        item3.itemId = ContextMenu.textItemId
        
        let item4 = GNAMenuItem(icon: UIImage(named: "contextLine")!, activeIcon: UIImage(named: "contextLine"), title: "Line", frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50))
        item4.defaultLabelMargin = 20
        item4.itemId = ContextMenu.lineItemId
        
        let item5 = GNAMenuItem(icon: UIImage(named: "contextmenu")!, activeIcon: UIImage(named: "contextmenu"), title: "Theme", frame: CGRect(x: 0.0, y: 0.0, width: 50, height: 50))
        item5.defaultLabelMargin = 20
        item5.itemId = ContextMenu.themeItemId
        
        menuView = GNAMenuView(touchPointSize: CGSize(width: 140, height: 140),
                               touchImage: nil,
                               menuItems:[item1, item2, item3, item4, item5])
        
        menuView.delegate = self
    }
    
    private func loadTradeModel(_ stockType: StockIndex = .Apple, _ timeScale: TimeScale = .day, _ timePeriod: TimePeriod = .year) {
        startLoading()
        DataManager.getPrices(with: timeScale, timePeriod, stockType, handler: { (viewModel) in
            if self.traderModel != nil{
                let previousIndicators = self.traderModel.traderIndicators
                var updatedViewModel = viewModel
                updatedViewModel.traderIndicators = previousIndicators
                self.traderModel = updatedViewModel
            }
            else {
                self.traderModel = viewModel
            }

            self.stopLoading()
        })
    }
    
    private func showAlertController(_ alert: UIAlertController, _ senderFrame: CGRect) {
        if let controller = alert.popoverPresentationController {
            controller.sourceView = view
            controller.sourceRect = senderFrame
        }
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func internetConnectionStatusChanged() {
        updateInternetConnectionInfo(true)
    }
    
    private func updateInternetConnectionInfo(_ animated: Bool = true) {
        guard let reachability = Network.reachability else {
            showNoInternetConnection(animated)
            return
        }
        
        if reachability.status == .wifi || (!reachability.isRunningOnDevice && reachability.isConnectedToNetwork) {
            hideNoInternetConnection(animated)
        }
        else {
            showNoInternetConnection(animated)
        }
    }
    
    private func showNoInternetConnection(_ animated: Bool = true) {
        
        noInternetConnectionLeftConstraint.constant = view.frame.size.width
        filterPanelHeightConstraint.constant = 30.0
        noInternetConnectionLabel.layoutSubviews()
        
        noInternetConnectionLabel.isHidden = false
        
        noInternetConnectionLeftConstraint.constant = 0.0
        filterPanelHeightConstraint.constant = 40.0
        
        if animated {
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        else {
            self.view.layoutIfNeeded()
        }
        
    }
    
    private func hideNoInternetConnection(_ animated: Bool = true) {
        self.noInternetConnectionLeftConstraint.constant = self.view.frame.size.width
        self.filterPanelHeightConstraint.constant = 30.0
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            }) { (finished) in
                if finished {
                    self.noInternetConnectionLabel.isHidden = true
                }
            }
        }
        else {
            view.layoutIfNeeded()
            noInternetConnectionLabel.isHidden = true
        }
    }
    
    private func setupView(with indicators: [TraderIndicators]) {
        
        let previuosState = traderModel.traderIndicators
        
        traderModel.traderIndicators = indicators
        
        if  indicators.contains(.rsiPanel) && !previuosState.contains(.rsiPanel) ||
            !indicators.contains(.rsiPanel) && previuosState.contains(.rsiPanel) ||
            indicators.contains(.macdPanel) && !previuosState.contains(.macdPanel) ||
            !indicators.contains(.macdPanel) && previuosState.contains(.macdPanel) {
            redrawPanels(with: indicators)
        }
        
        surfacesConfigurator.setupOnlyIndicators(indicators)
        
    }
    
    private func redrawPanels(with indicators:[TraderIndicators]) {
    
        if indicators.contains(.macdPanel) && indicators.contains(.rsiPanel) {
            subPaneRsiChartSurface.isHidden = false
            subPaneMcadChartSurface.isHidden = false
            bottomSeparatorView.isHidden = false
            
            rsiPanelHeightConstraint.isActive = false
            macdPanelHeightConstraint.isActive = false
            mainPanelToMcadPanelConstraint.isActive = false
            
            mainPanelToRsiPanelConstraint.isActive = true
            rsiPanelToMcadPanelConstraint.isActive = true
            topSeparatorView.relationConstraint = mainPanelToRsiPanelConstraint
            
        }
        else if !indicators.contains(.macdPanel) && !indicators.contains(.rsiPanel) {
            subPaneRsiChartSurface.isHidden = false
            subPaneMcadChartSurface.isHidden = false
            bottomSeparatorView.isHidden = false
            topSeparatorView.isHidden = false
            
            mainPanelToRsiPanelConstraint.isActive = false
            mainPanelToMcadPanelConstraint.isActive = false
            rsiPanelToMcadPanelConstraint.isActive = false
            
            rsiPanelHeightConstraint.isActive = true
            macdPanelHeightConstraint.isActive = true
            
        }
        else if indicators.contains(.rsiPanel) && !indicators.contains(.macdPanel) {
         
            // Show rsi panel
            topSeparatorView.relationConstraint = mainPanelToRsiPanelConstraint
            rsiPanelHeightConstraint.isActive = false
            subPaneRsiChartSurface.isHidden = false
            mainPanelToRsiPanelConstraint.isActive = true
            
            // Hide macd panel
            rsiPanelToMcadPanelConstraint.isActive = false
            macdPanelHeightConstraint.isActive = true
            bottomSeparatorView.isHidden = true
            subPaneMcadChartSurface.isHidden = true
            
        }
        else if !indicators.contains(.rsiPanel) && indicators.contains(.macdPanel) {
            
            // Hide rsi panel
            mainPanelToRsiPanelConstraint.isActive = false
            subPaneRsiChartSurface.isHidden = true
            bottomSeparatorView.isHidden = true
            rsiPanelHeightConstraint.isActive = true
            rsiPanelToMcadPanelConstraint.isActive = false
            
            // Show macd panel
            topSeparatorView.relationConstraint = mainPanelToMcadPanelConstraint
            mainPanelToMcadPanelConstraint.isActive = true
            subPaneMcadChartSurface.isHidden = false
            macdPanelHeightConstraint.isActive = false
            
        }
        
        view.layoutIfNeeded()
    }

    // MARK: IBActions
    
    @objc private func handleLongPress(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: view)
        
        if mainPaneChartSurface.frame.contains(point) ||
            subPaneRsiChartSurface.frame.contains(point) ||
            subPaneMcadChartSurface.frame.contains(point)
        {
            menuView.handleGesture(gesture, inView: view)
        }

    }
    
    @objc private func addSurfaceClick(_ sender: UIBarButtonItem) {
        let selectionController = MultipleSelectionViewController<TraderIndicators>(nibName: "MultipleSelectionViewController", bundle: nil)
        selectionController.setupList(with: TraderIndicators.allValues, selected: traderModel.traderIndicators) { (selectedItems) in
            self.setupView(with: selectedItems)
        }.showWithCrossDissolveStyle(over: self)
    }

    @IBAction func stockTypeClick(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Stock Index", message: "", preferredStyle: .actionSheet).fillActions(actions: StockIndex.allValues) { (stockType) in
            if let stockTypeNonNil = stockType {
               self.loadTradeModel(stockTypeNonNil, self.traderModel.timeScale, self.traderModel.timePeriod)
            }
        }
        showAlertController(actionSheet, sender.frame)
    }
    
    @IBAction func timeScaleClick(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Time Scale", message: "", preferredStyle: .actionSheet).fillActions(actions: TimeScale.allValues) { (timeScale) in
            if let timeScaleNonNil = timeScale {
                self.loadTradeModel(self.traderModel.stockType, timeScaleNonNil, self.traderModel.timePeriod)
            }
        }
        showAlertController(actionSheet, sender.frame)
    }
    
    @IBAction func timePeriodClick(_ sender: UIButton) {
        let actionSheet = UIAlertController(title: "Choose Time Period", message: "", preferredStyle: .actionSheet).fillActions(actions: TimePeriod.allValues) { (timePeriod) in
            if let timePeriodNonNil = timePeriod {
                self.loadTradeModel(self.traderModel.stockType, self.traderModel.timeScale, timePeriodNonNil)
            }
        }
        showAlertController(actionSheet, sender.frame)
    }
    
    // MARK: GNAMenuItemDelegate
    
    func menuItemWasPressed(_ menuItem: GNAMenuItem, info: [String : Any]?) {
        
        if menuItem.itemId == ContextMenu.downItemId {
           surfacesConfigurator.enableCreationDownAnnotation()
        }
        else if menuItem.itemId == ContextMenu.upItemId {
            surfacesConfigurator.enableCreationUpAnnotation()
        }
        else if menuItem.itemId == ContextMenu.lineItemId {
            surfacesConfigurator.enableCreationLineAnnotation()
        }
        else if menuItem.itemId == ContextMenu.textItemId {
            surfacesConfigurator.enableCreationTextAnnotation()
        }
        else {
            surfacesConfigurator.changeTheme()
        }
        
        
    }
    
    
}
