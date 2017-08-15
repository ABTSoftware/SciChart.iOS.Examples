//
//  TraderChartSurfacesConfigurator.swift
//  SciChartShowcaseDemo
//
//  Created by Gkol on 7/31/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

extension SCIAnnotationCreationType {
    public static let upArrowAnnotationType: SCIAnnotationCreationType = SCIAnnotationCreationType("upArrowAnnotationType")
    public static let downArrowAnnotationType: SCIAnnotationCreationType = SCIAnnotationCreationType("downArrowAnnotationType")
}

class TraderAnnotationFactory : SCICreationAnnotationFactory {
    
    override public func createAnnotation(forType annotationType: SCIAnnotationCreationType) -> SCIAnnotationProtocol? {
        
        let annotation = super.createAnnotation(forType: annotationType)
        
        if annotationType == .upArrowAnnotationType {
            let upAnnotation = SCICustomAnnotation()
            upAnnotation.customView = UIImageView(image: UIImage.imageNamedUpArrow())
            return upAnnotation
        }
        
        if annotationType == .downArrowAnnotationType {
            let downAnnotation = SCICustomAnnotation()
            downAnnotation.customView = UIImageView(image: UIImage.imageNamedDownArrow())
            return downAnnotation
        }
        
        return annotation
        
    }
    
}

class TraderChartSurfacesConfigurator {
    
    let ohlcRenderableSeries: SCIFastCandlestickRenderableSeries = SCIFastCandlestickRenderableSeries()
    let volumeRenderableSeries: SCIFastColumnRenderableSeries = SCIFastColumnRenderableSeries()
    let averageLowRenderableSeries: SCIFastLineRenderableSeries = SCIFastLineRenderableSeries()
    let averageHighRenderableSeries: SCIFastLineRenderableSeries = SCIFastLineRenderableSeries()
    let rsiRenderableSeries: SCIFastLineRenderableSeries = SCIFastLineRenderableSeries()
    let mcadRenderableSeries: SCIFastBandRenderableSeries = SCIFastBandRenderableSeries()
    let histogramRenderableSeries: SCIFastColumnRenderableSeries = SCIFastColumnRenderableSeries()
    
    private weak var mainPaneChartSurface: SCIChartSurface!
    private weak var subPaneRsiChartSurface: SCIChartSurface!
    private weak var subPaneMcadChartSurface: SCIChartSurface!
    
    private let sizeAxisAreaSync = SCIAxisAreaSizeSynchronization()
    private let pinchZoomModifierSync = SCIMultiSurfaceModifier(modifierType: SCIPinchZoomModifier.self)
    private let zoomExtendsSync = SCIMultiSurfaceModifier(modifierType: SCIZoomExtentsModifier.self)
    private let zoomPanSync = SCIMultiSurfaceModifier(modifierType: SCIZoomPanModifier.self)
    
    private let creationLineModfier = SCIAnnotationCreationModifier(annotationType: .lineAnnotationType)
    private let creationTextModfier = SCIAnnotationCreationModifier(annotationType: .textAnnotationType)
    private let creationUpArrowModfier = SCIAnnotationCreationModifier(annotationType: .upArrowAnnotationType)
    private let creationDownArrowModfier = SCIAnnotationCreationModifier(annotationType: .downArrowAnnotationType)
    
    init(with mainChartSurface: SCIChartSurface, _ subRsiChartSurface: SCIChartSurface, _ subMcadChartSurface: SCIChartSurface) {
        mainPaneChartSurface = mainChartSurface
        subPaneRsiChartSurface = subRsiChartSurface
        subPaneMcadChartSurface = subMcadChartSurface
        sizeAxisAreaSync.syncMode = .right
        
        configureMainSurface()
        configureRsiSubSurface()
        configureMcadSubSurface()
        
        configureCreationModifiers()
        enableDefaultStateModifiers()
    }
    
    func enableDefaultStateModifiers() {
        pinchZoomModifierSync.isEnabled = true
        zoomExtendsSync.isEnabled = true
        zoomPanSync.isEnabled = true
        
        creationUpArrowModfier.isEnabled = false
        creationLineModfier.isEnabled = false
        creationTextModfier.isEnabled = false
        creationDownArrowModfier.isEnabled = false
    }
    
    func disableAllModifiers() {
        pinchZoomModifierSync.isEnabled = false
        zoomExtendsSync.isEnabled = false
        zoomPanSync.isEnabled = false
        
        creationUpArrowModfier.isEnabled = false
        creationLineModfier.isEnabled = false
        creationTextModfier.isEnabled = false
        creationDownArrowModfier.isEnabled = false
    }
    
    func enableCreationUpAnnotation() {
        disableAllModifiers()
        creationUpArrowModfier.isEnabled = true
    }
    
    func enableCreationDownAnnotation() {
        disableAllModifiers()
        creationDownArrowModfier.isEnabled = true
    }
    
    func setupSurfacesWithTraderModel(with traderModel: TraderViewModel) {
        
        ohlcRenderableSeries.dataSeries = traderModel.stockPrices
        volumeRenderableSeries.dataSeries = traderModel.volume
        averageLowRenderableSeries.dataSeries = traderModel.averageLow
        averageHighRenderableSeries.dataSeries = traderModel.averageHigh
        rsiRenderableSeries.dataSeries = traderModel.rsi
        mcadRenderableSeries.dataSeries = traderModel.mcad
        histogramRenderableSeries.dataSeries = traderModel.histogram
        
        mainPaneChartSurface.zoomExtents()
        subPaneMcadChartSurface.zoomExtents()
        subPaneRsiChartSurface.zoomExtents()
        
        mainPaneChartSurface.annotations.clear()
        subPaneMcadChartSurface.annotations.clear()
        subPaneRsiChartSurface.annotations.clear()
        
        addAxisMarkerAnnotation(surface: mainPaneChartSurface,
                                yID: mainPaneChartSurface.yAxes[0].axisId,
                                color: UIColor.strokeAverageLowColor(),
                                valueFormat: "$%.2f",
                                value: averageLowRenderableSeries.dataSeries.yValues().value(at: averageLowRenderableSeries.dataSeries.count()-1))
        
        addAxisMarkerAnnotation(surface: mainPaneChartSurface,
                                yID: mainPaneChartSurface.yAxes[0].axisId,
                                color: UIColor.strokeAverageHighColor(),
                                valueFormat: "$%.2f",
                                value: averageHighRenderableSeries.dataSeries.yValues().value(at: averageHighRenderableSeries.dataSeries.count()-1))
        
        
        addAxisMarkerAnnotation(surface: subPaneRsiChartSurface,
                                yID: subPaneRsiChartSurface.yAxes[0].axisId,
                                color: UIColor.strokeRSIColor(),
                                valueFormat: "$%.2f",
                                value: rsiRenderableSeries.dataSeries.yValues().value(at: rsiRenderableSeries.dataSeries.count()-1))
        
        
        addAxisMarkerAnnotation(surface: subPaneMcadChartSurface,
                                yID: subPaneMcadChartSurface.yAxes[0].axisId,
                                color: UIColor.strokeMcadColor(),
                                valueFormat: "$%.2f",
                                value: traderModel.mcad.yValues().value(at: traderModel.mcad.count()-1))
        
        addAxisMarkerAnnotation(surface: subPaneMcadChartSurface,
                                yID: subPaneMcadChartSurface.yAxes[0].axisId,
                                color: UIColor.strokeY1McadColor(),
                                valueFormat: "$%.2f",
                                value: traderModel.mcad.y1Values().value(at: traderModel.mcad.count()-1))
        
    }
    
    func setupOnlyIndicators(_ indicators:[TraderIndicators]) {
        averageHighRenderableSeries.isVisible = indicators.contains(.movingAverage100)
        averageLowRenderableSeries.isVisible = indicators.contains(.movingAverage50)
        mainPaneChartSurface.zoomExtents()
        subPaneMcadChartSurface.zoomExtents()
        subPaneRsiChartSurface.zoomExtents()
    }
    
    private func configureCreationModifiers() {
    
        let handler = { [unowned self] () -> Void in
            self.enableDefaultStateModifiers()
        };
        
        creationLineModfier.creationHanlder = handler
        creationUpArrowModfier.creationHanlder = handler
        creationDownArrowModfier.creationHanlder = handler
        creationTextModfier.creationHanlder = handler

        creationUpArrowModfier.annotationsFactory = TraderAnnotationFactory()
        creationDownArrowModfier.annotationsFactory = TraderAnnotationFactory()
        
    }
    
    private func configureMainSurface() {
        
        mainPaneChartSurface.xAxes.add(SCICategoryDateTimeAxis())
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        mainPaneChartSurface.yAxes.add(yAxis)
        
        averageLowRenderableSeries.strokeStyle = SCISolidPenStyle(color: UIColor.strokeAverageLowColor(), withThickness: 1.0)
        averageHighRenderableSeries.strokeStyle = SCISolidPenStyle(color: UIColor.strokeAverageHighColor(), withThickness: 1.0)
        
        ohlcRenderableSeries.strokeUpStyle = SCISolidPenStyle(color: UIColor.strokeUpOhlcColor(), withThickness: 1.0)
        ohlcRenderableSeries.fillUpBrushStyle = SCISolidBrushStyle(color: UIColor.fillUpBrushOhlcColor())
        ohlcRenderableSeries.fillDownBrushStyle = SCISolidBrushStyle(color: UIColor.fillDownBrushOhlcColor())
        ohlcRenderableSeries.strokeDownStyle = SCISolidPenStyle(color: UIColor.strokeDownOhlcColor(), withThickness: 1.0)
        
        volumeRenderableSeries.style.strokeStyle = SCISolidPenStyle(color: UIColor.white, withThickness: 1.0)
        volumeRenderableSeries.style.fillBrushStyle = SCISolidBrushStyle(color: UIColor.white)
        
        let volumeYAxis = SCINumericAxis()
        volumeYAxis.axisId = AxisIds.volumeYAxisId
        volumeYAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.0), max: SCIGeneric(0.5))
        volumeYAxis.isVisible = false
        volumeYAxis.autoRange = .always
        volumeYAxis.visibleRange = SCIDoubleRange(min: SCIGeneric(5), max: SCIGeneric(5))
        mainPaneChartSurface.yAxes.add(volumeYAxis)
        volumeRenderableSeries.yAxisId = AxisIds.volumeYAxisId
        
        mainPaneChartSurface.renderableSeries.add(volumeRenderableSeries)
        mainPaneChartSurface.renderableSeries.add(ohlcRenderableSeries)
        mainPaneChartSurface.renderableSeries.add(averageHighRenderableSeries)
        mainPaneChartSurface.renderableSeries.add(averageLowRenderableSeries)
        
        sizeAxisAreaSync.attachSurface(mainPaneChartSurface)
        
        mainPaneChartSurface.chartModifiers.add(zoomExtendsSync)
        mainPaneChartSurface.chartModifiers.add(pinchZoomModifierSync)
        mainPaneChartSurface.chartModifiers.add(zoomPanSync)
        
        mainPaneChartSurface.chartModifiers.add(creationDownArrowModfier)
        mainPaneChartSurface.chartModifiers.add(creationUpArrowModfier)
        mainPaneChartSurface.chartModifiers.add(creationTextModfier)
        mainPaneChartSurface.chartModifiers.add(creationLineModfier)
    }
    
    private func configureRsiSubSurface() {
        subPaneRsiChartSurface.xAxes.add(SCICategoryDateTimeAxis())
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        subPaneRsiChartSurface.yAxes.add(yAxis)
        
        rsiRenderableSeries.strokeStyle = SCISolidPenStyle(color: UIColor.strokeRSIColor(), withThickness: 1.0)
        subPaneRsiChartSurface.renderableSeries.add(rsiRenderableSeries)
        
        sizeAxisAreaSync.attachSurface(subPaneRsiChartSurface)
        subPaneRsiChartSurface.chartModifiers.add(zoomExtendsSync)
        subPaneRsiChartSurface.chartModifiers.add(pinchZoomModifierSync)
        subPaneRsiChartSurface.chartModifiers.add(zoomPanSync)
        
        subPaneRsiChartSurface.chartModifiers.add(creationDownArrowModfier)
        subPaneRsiChartSurface.chartModifiers.add(creationUpArrowModfier)
        subPaneRsiChartSurface.chartModifiers.add(creationTextModfier)
        subPaneRsiChartSurface.chartModifiers.add(creationLineModfier)
    }
    
    private func configureMcadSubSurface() {
        subPaneMcadChartSurface.xAxes.add(SCICategoryDateTimeAxis())
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        subPaneMcadChartSurface.yAxes.add(yAxis)
        
        mcadRenderableSeries.style.strokeStyle = SCISolidPenStyle(color: UIColor.strokeMcadColor(), withThickness: 1.0)
        mcadRenderableSeries.style.strokeY1Style = SCISolidPenStyle(color: UIColor.strokeY1McadColor(), withThickness: 1.0)
        mcadRenderableSeries.style.fillBrushStyle = SCISolidBrushStyle(color: UIColor.clear)
        mcadRenderableSeries.style.fillY1BrushStyle = SCISolidBrushStyle(color: UIColor.clear)
        subPaneMcadChartSurface.renderableSeries.add(mcadRenderableSeries)
        
        histogramRenderableSeries.style.strokeStyle = SCISolidPenStyle(color: UIColor.white, withThickness: 1.0)
        histogramRenderableSeries.style.fillBrushStyle = SCISolidBrushStyle(color: UIColor.white)
        subPaneMcadChartSurface.renderableSeries.add(histogramRenderableSeries)
        
        sizeAxisAreaSync.attachSurface(subPaneMcadChartSurface)
        subPaneMcadChartSurface.chartModifiers.add(zoomExtendsSync)
        subPaneMcadChartSurface.chartModifiers.add(pinchZoomModifierSync)
        subPaneMcadChartSurface.chartModifiers.add(zoomPanSync)
        
        subPaneMcadChartSurface.chartModifiers.add(creationDownArrowModfier)
        subPaneMcadChartSurface.chartModifiers.add(creationUpArrowModfier)
        subPaneMcadChartSurface.chartModifiers.add(creationTextModfier)
        subPaneMcadChartSurface.chartModifiers.add(creationLineModfier)
        
    }
    
    private func addAxisMarkerAnnotation(surface:SCIChartSurface, yID:String, color: UIColor, valueFormat:String, value:SCIGenericType){
        let axisMarker = SCIAxisMarkerAnnotation()
        axisMarker.yAxisId = yID;
        axisMarker.style.margin = 5;
        
        let textFormatting = SCITextFormattingStyle();
        textFormatting.color = UIColor.white;
        textFormatting.fontSize = 10;
        axisMarker.style.textStyle = textFormatting;
        axisMarker.formattedValue = String.init(format: valueFormat, SCIGenericDouble(value));
        axisMarker.coordinateMode = .absolute
        axisMarker.style.backgroundColor = color;
        axisMarker.position = value;
        
        surface.annotations.add(axisMarker);
    }
}
