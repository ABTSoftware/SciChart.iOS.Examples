//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SparkLinesCollectionViewItem.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

final class SparkLinesCollectionViewItem: SCICollectionViewCell {
        
    #if os(OSX)
    
    override init(nibName nibNameOrNil: NSNib.Name?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func loadView() {
        view = SCIView()
        view.platformBackgroundColor = .clear
        createViews()
    }
    
    #elseif os(iOS)
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createViews()
    }
    #endif
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var surface: SCIChartSurface = {
        let surface = SCIChartSurface()
        surface.platformBackgroundColor = .clear
        
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.05, max: 0.05)
        xAxis.autoRange = .always
        xAxis.drawMajorBands = false
        xAxis.drawLabels = false
        xAxis.drawMinorTicks = false
        xAxis.drawMajorTicks = false
        xAxis.drawMajorGridLines = false
        xAxis.drawMinorGridLines = false
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        yAxis.drawMajorBands = false
        yAxis.drawLabels = false
        yAxis.drawMinorTicks = false
        yAxis.drawMajorTicks = false
        yAxis.drawMajorGridLines = false
        yAxis.drawMinorGridLines = false
        
        let rs = SCIFastLineRenderableSeries()
        rs.strokeStyle = SCISolidPenStyle(color: 0xFF4682B4, thickness: 2)
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        surface.renderableSeries.add(rs)
        surface.renderableSeriesAreaBorderStyle = SCISolidPenStyle(color: .clear, thickness: 0)
        return surface
    }()
    
    private var nameLabel: SCILabel = {
        let label = SCILabel()
        #if os(iOS)
        label.textColor = .white
        #endif
        
        return label
    }()
    
    private var valueLabel: SCILabel = {
        return SCILabel()
    }()
    
    func configure(with model: SparkLineItemModel) {
        nameLabel.text = model.itemName
        setValueLabelText(value: model.itemValue)
        
        let renderableSeries = surface.renderableSeries.first()
        renderableSeries.dataSeries = model.dataSeries
    }
    
    private func setValueLabelText(value: Double) {
        var text = ""
        if value < 0 {
            text.append("⇑")
            valueLabel.textColor = SCIColor(red: 52/255.0, green: 193/255.0, blue: 156/255.0, alpha: 1)
        } else {
            text.append("⇓")
            valueLabel.textColor = SCIColor(red: 196/255.0, green: 51/255.0, blue: 96/255.0, alpha: 1)
        }
        text.append(String(format: "%.3f", value) + "%")
        
        valueLabel.text = text
    }
    
    private func createViews() {
        let stackView = SCIStackView(arrangedSubviews: [nameLabel, valueLabel, surface])
        stackView.axis = .horizontal
        
        cellView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        #if os(OSX)
        NSLayoutConstraint.activate([
            surface.widthAnchor.constraint(equalToConstant: 400),
        ])
        let trailingConstraint = stackView.trailingAnchor.constraint(lessThanOrEqualTo: cellView.trailingAnchor, constant: -10)
        #elseif os(iOS)
        let trailingConstraint = stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        #endif
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            trailingConstraint,
            stackView.topAnchor.constraint(equalTo: cellView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: cellView.bottomAnchor),
            
            nameLabel.widthAnchor.constraint(equalToConstant: 70),
            valueLabel.widthAnchor.constraint(equalToConstant: 90),
        ])
    }
}
