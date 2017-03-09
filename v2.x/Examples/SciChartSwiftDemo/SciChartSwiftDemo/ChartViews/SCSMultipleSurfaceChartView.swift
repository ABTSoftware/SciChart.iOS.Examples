//
//  SCSMultipleSurfaceChartView.swift
//  SciChartSwiftDemo
//
//  Created by Mykola Hrybeniuk on 6/6/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class SCSMultipleSurfaceChartView: UIView {
    
    let sciChartView1 = SCSBaseChartView()
    let sciChartView2 = SCSBaseChartView()
    let rangeSync = SCIAxisRangeSyncronization()
    let sizeAxisAreaSync = SCIAxisAreaSizeSyncronization()
    let rolloverModifierSync = SCIMultiSurfaceModifier(modifierType: SCIRolloverModifier.self)
    let pinchZoomModifierSync = SCIMultiSurfaceModifier(modifierType: SCIPinchZoomModifier.self)
    let yDragModifierSync = SCIMultiSurfaceModifier(modifierType: SCIYAxisDragModifier.self)
    let xDragModifierSync = SCIMultiSurfaceModifier(modifierType: SCIXAxisDragModifier.self)
    let zoomExtendsSync = SCIMultiSurfaceModifier(modifierType: SCIZoomExtentsModifier.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    // MARK: Overrided Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        completeConfiguration()
    }
    
    // MARK: Private Functions
    
    fileprivate func configureChartSuraface() {
        
        sciChartView1.axisYId = "Y1"
        sciChartView1.axisXId = "X1"
        
        sciChartView2.axisYId = "Y2"
        sciChartView2.axisXId = "X2"
        
        sciChartView1.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView1)
        
        sciChartView2.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView2)
        
        let layoutDictionary = ["SciChart1" : sciChartView1, "SciChart2" : sciChartView2]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart1]-(0)-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart2]-(0)-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[SciChart1(SciChart2)]-(10)-[SciChart2(SciChart1)]-(0)-|",
            options: NSLayoutFormatOptions(),
            metrics: nil,
            views: layoutDictionary))
    }
    
    
    fileprivate func addAxis() {
        
        let axisStyle = sciChartView1.generateDefaultAxisStyle()
        
        let axisX1 = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        axisX1.axisId = sciChartView1.axisXId
        rangeSync.attachAxis(axisX1)
        sciChartView1.chartSurface.xAxes.add(axisX1)
        
        let axisY1 = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        axisY1.axisId = sciChartView1.axisYId
        sciChartView1.chartSurface.yAxes.add(axisY1)
        
        let axisX2 = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle);
        axisX2.axisId = sciChartView2.axisXId
        rangeSync.attachAxis(axisX2)
        sciChartView2.chartSurface.xAxes.add(axisX2)
        
        let axisY2 = SCSFactoryAxis.createDefaultNumericAxis(withAxisStyle: axisStyle)
        axisY2.axisId = sciChartView2.axisYId
        sciChartView2.chartSurface.yAxes.add(axisY2)
        
    }
    
    fileprivate func addModifiers() {

        sizeAxisAreaSync.syncMode = .right
        sizeAxisAreaSync.attachSurface(sciChartView1.chartSurface)
        sizeAxisAreaSync.attachSurface(sciChartView2.chartSurface)
        
//        var rolloverModifier = nil//rolloverModifierSync.modifier(forSurface: sciChartView1.chartSurface)
//        var zoomExtendsModifier = zoomExtendsSync.modifier(forSurface: sciChartView1.chartSurface)
        var yDragModifier = yDragModifierSync.modifier(forSurface: sciChartView1.chartSurface)
        if let yDragM = yDragModifier as? SCIYAxisDragModifier {
            yDragM.axisId = sciChartView1.axisYId
            yDragM.dragMode = .pan;
        }
        var xDragModifier = xDragModifierSync.modifier(forSurface: sciChartView1.chartSurface)
        if let xDragM = xDragModifier as? SCIXAxisDragModifier {
            xDragM.axisId = sciChartView1.axisXId
            xDragM.dragMode = .pan;
        }
//        var pinchModifier = pinchZoomModifierSync.modifier(forSurface: sciChartView1.chartSurface)
        var modifierGroup = SCIModifierGroup(childModifiers: [rolloverModifierSync, yDragModifierSync, pinchZoomModifierSync, zoomExtendsSync, xDragModifierSync])
        sciChartView1.chartSurface.chartModifier = modifierGroup

//        _ = rolloverModifierSync.modifier(forSurface: sciChartView2.chartSurface)
//        let zoomExtendsModifier = zoomExtendsSync.modifier(forSurface: sciChartView2.chartSurface)
        yDragModifier = yDragModifierSync.modifier(forSurface: sciChartView2.chartSurface)
        if let yDragM = yDragModifier as? SCIYAxisDragModifier {
            yDragM.axisId = sciChartView2.axisYId
            yDragM.dragMode = .pan;
        }
        xDragModifier = xDragModifierSync.modifier(forSurface: sciChartView2.chartSurface)
        if let xDragM = xDragModifier as? SCIXAxisDragModifier {
            xDragM.axisId = sciChartView2.axisXId
            xDragM.dragMode = .pan;
        }
//        let pinchModifier = pinchZoomModifierSync.modifier(forSurface: sciChartView2.chartSurface)
        modifierGroup = SCIModifierGroup(childModifiers: [rolloverModifierSync, yDragModifierSync, pinchZoomModifierSync, zoomExtendsSync, xDragModifierSync])
        sciChartView2.chartSurface.chartModifier = modifierGroup
    }
    
    fileprivate func addDataSeries() {
        
        let dataSeries1 = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.putDataInto(dataSeries1)
        dataSeries1.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let ellipseMarker = SCIEllipsePointMarker()
        ellipseMarker.drawBorder = true
        ellipseMarker.fillBrush = SCISolidBrushStyle(colorCode: 0xFFd7ffd6)
        ellipseMarker.height = 5
        ellipseMarker.width = 5
        
        var renderableDataSeries = SCIFastLineRenderableSeries()
        renderableDataSeries.style.pointMarker = ellipseMarker
        renderableDataSeries.style.drawPointMarkers = true
        renderableDataSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 0.7)
        renderableDataSeries.xAxisId = sciChartView1.axisXId
        renderableDataSeries.yAxisId = sciChartView1.axisYId
        renderableDataSeries.dataSeries = dataSeries1
        
        sciChartView1.chartSurface.renderableSeries.add(renderableDataSeries)
        sciChartView1.chartSurface.invalidateElement()
        
        
        let dataSeries2 = SCIXyDataSeries(xType: .float, yType: .float, seriesType: .defaultType)
        SCSDataManager.putDataInto(dataSeries2)
        dataSeries2.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        renderableDataSeries = SCIFastLineRenderableSeries()
        renderableDataSeries.style.linePen = SCISolidPenStyle(colorCode: 0xFFff8a4c, withThickness: 0.7)
        renderableDataSeries.xAxisId = sciChartView2.axisXId
        renderableDataSeries.yAxisId = sciChartView2.axisYId
        renderableDataSeries.dataSeries = dataSeries2
        
        sciChartView2.chartSurface.renderableSeries.add(renderableDataSeries)
        sciChartView2.chartSurface.invalidateElement()
        
    }
    
    
    // MARK: Internal Functions
    
    func completeConfiguration() {
        configureChartSuraface()
        addAxis()
        addModifiers()
        addDataSeries()

    }
    
    
}
