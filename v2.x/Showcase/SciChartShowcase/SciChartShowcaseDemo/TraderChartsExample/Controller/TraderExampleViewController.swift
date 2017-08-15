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
//        let customItem = GNAMenuItem(icon: UIImage(named: "shopingCart_inactive")!, activeIcon: UIImage(named: "shopingCart"), title: "Shop it")
//        customItem.changeTitle(withTitle: "ttt")
//        customItem.changeActiveIcon(withIcon: UIImage(named: "defaultImage")!)
//        customItem.changeIcon(withIcon: UIImage(named: "wishlist_inacitve")!)
//        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 60))
//        titleView.backgroundColor = .red
//        let titleLabel = UILabel(frame: .zero)
//        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: 1)
//        customItem.changeTitleView(withView: titleView)
//        customItem.changeTitleLabel(withLabel: titleLabel)
        
        let item1 = GNAMenuItem(icon: UIImage(named: "greenarrow")!, activeIcon: UIImage(named: "greenarrow"), title: "Up", frame: CGRect(x: 0.0, y: 0.0, width: 55, height: 55))
        item1.defaultLabelMargin = 20
        
        let item2 = GNAMenuItem(icon: UIImage(named: "redarrow")!, activeIcon: UIImage(named: "redarrow"), title: "Down", frame: CGRect(x: 0.0, y: 0.0, width: 55, height: 55))
        item2.defaultLabelMargin = 20
        
        menuView = GNAMenuView(touchPointSize: CGSize(width: 80, height: 80),
                               touchImage: nil,
                               menuItems:[item1, item2])
        
        menuView.delegate = self
    }
    
    private func loadTradeModel(_ stockType: StockIndex = .Apple, _ timeScale: TimeScale = .day, _ timePeriod: TimePeriod = .year) {
        startLoading()
        DataManager.getPrices(with: timeScale, timePeriod, stockType, handler: { (viewModel) in
            if self.traderModel != nil{
                let previousIndicators = self.traderModel.traderIndicators
                self.traderModel = viewModel
                self.traderModel.traderIndicators = previousIndicators
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
        
        if mainPaneChartSurface.frame.contains(point) {
            menuView.handleGesture(gesture, inView: mainPaneChartSurface)
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
        surfacesConfigurator.enableCreationUpAnnotation()
    }
    
    
}
