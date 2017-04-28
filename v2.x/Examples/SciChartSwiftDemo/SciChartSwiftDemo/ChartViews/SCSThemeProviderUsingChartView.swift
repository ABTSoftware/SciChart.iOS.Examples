//
//  SCSThemeProviderUsingChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 12/19/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class ThousandsLabelProvider: SCINumericLabelProvider {
    override func formatLabel(_ dataValue: SCIGenericType) -> Swift.String! {
        return super.formatLabel(SCIGeneric(SCIGenericDouble(dataValue) / 1000)) + "k"
    }
}

class BillionsLabelProvider: SCINumericLabelProvider {
    override func formatLabel(_ dataValue: SCIGenericType) -> Swift.String! {
        return super.formatLabel(SCIGeneric(SCIGenericDouble(dataValue) / pow(10, 9))) + "B"
    }
}

class SCSThemeProviderUsingChartView: UIView {

    let sciChartView = SCSBaseChartView()
    var controlPanel: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureChartSurface()
    }

    required init?(coder aDecoder: NSCoder) {
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

        let layoutDictionary: [String: UIView] = ["SciChart": sciChartView, "Panel": controlPanel]

        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[Panel(45)]-(0)-[SciChart]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: layoutDictionary))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: layoutDictionary))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[Panel]-(0)-|", options: NSLayoutFormatOptions(), metrics: nil, views: layoutDictionary))

        completeConfiguration()
    }

    func changeTheme(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Select Theme", message: "", preferredStyle: .actionSheet)
        let themes = ["Black Steel", "Bright Spark", "Chrome", "Chart V4 Dark", "Electric", "Expression Dark", "Expression Light", "Oscilloscope"]
        for themeName: String in themes {
            let actionTheme = UIAlertAction(title: themeName, style: .default, handler: { (action: UIAlertAction) -> Void in
                let index = UInt(themes.startIndex.distance(to: themes.index(of: themeName)!))
                self.applyTheme(SCIThemeKey(rawValue: index)!)
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

    func applyTheme(_ themeKey: SCIThemeKey) {
        sciChartView.chartSurface.applyThemeProvider(SCIThemeColorProvider(themeKey: themeKey))
    }

    // MARK: Overrided Functions

    func completeConfiguration() {
        sciChartView.completeConfiguration()

        let axisStyle = SCIAxisStyle()
        axisStyle.drawMajorTicks = false
        axisStyle.drawMinorTicks = false

        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        xAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(150), max: SCIGeneric(180))

        let yRightAxis = SCINumericAxis()
        yRightAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        yRightAxis.axisAlignment = .right
        yRightAxis.autoRange = .always
        yRightAxis.axisId = "PrimaryAxisId"
        yRightAxis.style = axisStyle
        yRightAxis.labelProvider = ThousandsLabelProvider()

        let yLeftAxis = SCINumericAxis()
        yLeftAxis.growBy = SCIDoubleRange(min: SCIGeneric(0), max: SCIGeneric(3))
        yLeftAxis.axisAlignment = .left;
        yLeftAxis.autoRange = .always;
        yLeftAxis.axisId = "SecondaryAxisId";
        yLeftAxis.style = axisStyle;
        yLeftAxis.labelProvider = BillionsLabelProvider()

        let mountainDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        mountainDataSeries.seriesName = "Mountain Series"
        let lineDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        lineDataSeries.seriesName = "Line Series"
        let columnDataSeries = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        columnDataSeries.seriesName = "Column Series"
        let candlestickDataSeries = SCIOhlcDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        candlestickDataSeries.seriesName = "Candlestick Series"

        let averageHigh = SCSMovingAverage(length: 50)

        let dataSource = SCSDataManager.loadThemeData()
        for i in 0..<dataSource.count {
            let item = dataSource[i]

            let xValue = SCIGeneric(i)
            let open = SCIGeneric(item.open)
            let high = SCIGeneric(item.high)
            let low = SCIGeneric(item.low)
            let close = SCIGeneric(item.close)

            mountainDataSeries.appendX(xValue, y: SCIGeneric(item.close - 1000))
            lineDataSeries.appendX(xValue, y: SCIGeneric(averageHigh.push(item.close).current))
            columnDataSeries.appendX(xValue, y: SCIGeneric(item.volume))
            candlestickDataSeries.appendX(xValue, open: open, high: high, low: low, close: close)
        }

        let mountainRenderableSeries = SCIFastMountainRenderableSeries()
        mountainRenderableSeries.dataSeries = mountainDataSeries
        mountainRenderableSeries.yAxisId = "PrimaryAxisId";

        let lineRenderableSeries = SCIFastLineRenderableSeries()
        lineRenderableSeries.dataSeries = lineDataSeries
        lineRenderableSeries.yAxisId = "PrimaryAxisId";

        let columnRenderableSeries = SCIFastColumnRenderableSeries()
        columnRenderableSeries.dataSeries = columnDataSeries
        columnRenderableSeries.yAxisId = "SecondaryAxisId";

        let candlestickRenderableSeries = SCIFastCandlestickRenderableSeries()
        candlestickRenderableSeries.dataSeries = candlestickDataSeries
        candlestickRenderableSeries.yAxisId = "PrimaryAxisId";

        sciChartView.chartSurface.xAxes.add(xAxis)
        sciChartView.chartSurface.yAxes.add(yRightAxis)
        sciChartView.chartSurface.yAxes.add(yLeftAxis)
        sciChartView.chartSurface.renderableSeries.add(mountainRenderableSeries)
        sciChartView.chartSurface.renderableSeries.add(lineRenderableSeries)
        sciChartView.chartSurface.renderableSeries.add(columnRenderableSeries)
        sciChartView.chartSurface.renderableSeries.add(candlestickRenderableSeries)

        let legendModifier = SCILegendCollectionModifier(position: [.left, .top], andOrientation: .vertical)
        legendModifier?.showCheckBoxes = false

        sciChartView.chartSurface.chartModifier = SCIModifierGroup.init(childModifiers: [legendModifier!, SCICursorModifier(), SCIZoomExtentsModifier()])

        sciChartView.chartSurface.invalidateElement()
        applyTheme(.chartV4DarkTheme)
    }
}
