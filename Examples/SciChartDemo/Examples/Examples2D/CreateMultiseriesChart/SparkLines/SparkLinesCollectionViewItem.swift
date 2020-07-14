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

final class SparkLinesCollectionViewItem: UICollectionViewCell {
        
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        createViews()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var surface: SCIChartSurface = {
        let surface = SCIChartSurface()
        surface.backgroundColor = .clear
        
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
        rs.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, thickness: 2)
        surface.xAxes.add(xAxis)
        surface.yAxes.add(yAxis)
        surface.renderableSeries.add(rs)
        surface.renderableSeriesAreaBorderStyle = SCISolidPenStyle(color: .clear, thickness: 0)
        
        SCIThemeManager.applyTheme(to: surface, withThemeKey: SCIChart_Bright_SparkStyleKey)
        
        return surface
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        
        return label
    }()
    
    private var valueLabel: UILabel = {
        return UILabel()
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
            valueLabel.textColor = .green
        } else {
            text.append("⇓")
            valueLabel.textColor = .red
        }
        text.append(String(format: "%.3f", value) + "%")
        
        valueLabel.text = text
    }
    
    private func createViews() {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, valueLabel, surface])
        stackView.axis = .horizontal
        stackView.spacing = 10
        
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            nameLabel.widthAnchor.constraint(equalToConstant: 70),
            valueLabel.widthAnchor.constraint(equalToConstant: 90),
        ])
    }
}
