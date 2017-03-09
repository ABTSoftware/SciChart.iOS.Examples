//
//  SCSThemeProviderUsingChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 12/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSThemeProviderUsingChartView: UIView {
    
    let sciChartView = SCSBaseChartView()
    var controlPanel : UIView!
    var dataSource : [SCSMultiPaneItem]!
    
    override init(frame: CGRect) {
        dataSource = SCSDataManager.loadThemeData()
        super.init(frame: frame)
        configureChartSurface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        dataSource = SCSDataManager.loadThemeData()
        super.init(coder: aDecoder)
        configureChartSurface()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureChartSurface()
    }
    
    fileprivate func addPanel() {
        controlPanel = UIView.init(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: 45))
        controlPanel.translatesAutoresizingMaskIntoConstraints = false
        controlPanel.backgroundColor = UIColor.black
        
        let button = UIButton(frame: controlPanel.frame)
        
        button.setTitle("Sci Chart v4 Dark", for: UIControlState())
        button.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controlPanel.addSubview(button)
        
        button.addTarget(self, action: #selector(SCSThemeProviderUsingChartView.changeTheme(_:)), for: .touchUpInside)
        
        self.addSubview(controlPanel)
    }
    
    fileprivate func configureChartSurface() {
        
        sciChartView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView)
        
        addPanel()
        
        let layoutDictionary: [String : UIView] = ["SciChart" : sciChartView, "Panel" : controlPanel]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[Panel(45)]-(0)-[SciChart]-(0)-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart]-(0)-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[Panel]-(0)-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: layoutDictionary))
        
        completeConfiguration()
    }
    
    func changeTheme(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Theme", message: "", preferredStyle: .actionSheet)
        let themes = ["Black Steel", "Bright Spark", "Chrome", "Chart V4 Dark", "Electric", "Expression Dark", "Expression Light", "Oscilloscope"]
        for themeName: String in themes {
            let actionTheme = UIAlertAction(title: themeName, style: .default, handler: {(action: UIAlertAction) -> Void in
                let index = UInt(themes.startIndex.distance(to: themes.index(of: themeName)!))
                self.applyTheme(SCIKeyTheme(rawValue:  index)!)
                sender.setTitle(themeName, for: UIControlState())
            })
            alertController.addAction(actionTheme)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if let controller = alertController.popoverPresentationController {
            controller.sourceView = self
            controller.sourceRect = sender.frame
        }
        
        self.window!.rootViewController!.present(alertController, animated: true, completion: { _ in })
    }
    
    func applyTheme(_ themeKey: SCIKeyTheme) {
        sciChartView.chartSurface.applyTheme(withThemeProvider: SCIThemeProvider(themeKey: themeKey))
    }
    
    // MARK: Overrided Functions
    
    func completeConfiguration() {
        dataSource = SCSDataManager.loadThemeData()
        sciChartView.completeConfiguration()
        addAxis()
        sciChartView.addDefaultModifiers()
        addDataSeries()
        applyTheme(.chartV4DarkTheme)
        addModifiers()
    }
    
    // MARK: Private Methods
    
    fileprivate func addAxis() {
        
        let axisStyle = sciChartView.generateDefaultAxisStyle()
        
        let xAxis = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        xAxis.axisTitle = "Bottom Axis Title";
        sciChartView.chartSurface.xAxes.add(xAxis)
        
        let yAxis = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        yAxis.axisTitle = "Right Axis Title"
        sciChartView.chartSurface.yAxes.add(yAxis)
        
        axisStyle.drawMajorGridLines = false
        axisStyle.drawMinorGridLines = false
        axisStyle.drawMinorTicks = false
        axisStyle.drawMajorBands = false;
        let yAxis2 = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        yAxis2.axisId = "yAxis2"
        sciChartView.chartSurface.yAxes.add(yAxis2)
        yAxis2.axisAlignment = .left
        yAxis2.axisTitle = "Left Axis Title"

    }
    
    fileprivate func addDataSeries() {
        
        let priceDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        priceDataSeries.seriesName = "Line Series"
        priceDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let priceRenderableSeries = SCIFastLineRenderableSeries()
        priceRenderableSeries.style.drawPointMarkers = false
        priceRenderableSeries.dataSeries = priceDataSeries
        sciChartView.chartSurface.renderableSeries.add(priceRenderableSeries)
        
        let ohlcDataSeries = SCIOhlcDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        ohlcDataSeries.seriesName = "Candle Series"
        ohlcDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let candlestickRenderableSeries = SCIFastCandlestickRenderableSeries()
        candlestickRenderableSeries.dataSeries = ohlcDataSeries
        sciChartView.chartSurface.renderableSeries.add(candlestickRenderableSeries)
        
        let mountainDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        mountainDataSeries.seriesName = "Mountain Series"
        mountainDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let mountainRenderableSeries = SCIFastMountainRenderableSeries()
        mountainRenderableSeries.dataSeries = mountainDataSeries
        sciChartView.chartSurface.renderableSeries.add(mountainRenderableSeries)
        
        let columnDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        columnDataSeries.seriesName = "Column Series"
        columnDataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let columnRenderableSeries = SCIFastColumnRenderableSeries()
        columnRenderableSeries.style.dataPointWidth = 0.3
        columnRenderableSeries.dataSeries = columnDataSeries
        sciChartView.chartSurface.renderableSeries.add(columnRenderableSeries)
        
        let averageHigh = SCSMovingAverage(length: 20)
        var i = 0
        for item: SCSMultiPaneItem in dataSource {
            let date = SCIGeneric(i)
            let open = SCIGeneric(item.open)
            let high = SCIGeneric(item.high)
            let low = SCIGeneric(item.low)
            let close = SCIGeneric(item.close)
            ohlcDataSeries.appendX(date, open: open, high: high, low: low, close: close)
            priceDataSeries.appendX(date, y: SCIGeneric(averageHigh.push(item.close).current))
            mountainDataSeries.appendX(date, y: SCIGeneric(item.close - 1000))
            columnDataSeries.appendX(date, y: SCIGeneric(item.close - 3500))
            i += 1
        }
        sciChartView.chartSurface.invalidateElement()

    }
    
    func addModifiers() {
        let legend = SCILegendCollectionModifier(position: [.left, .top], andOrientation: .vertical)
        if let groupModifier = sciChartView.chartSurface.chartModifier as? SCIModifierGroup {
            groupModifier.addItem(legend)
        }
    }
    
    
}
