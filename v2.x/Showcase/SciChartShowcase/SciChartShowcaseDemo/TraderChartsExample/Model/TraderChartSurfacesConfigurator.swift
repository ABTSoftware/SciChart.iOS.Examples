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
    public static let customTextAnnotationType: SCIAnnotationCreationType = SCIAnnotationCreationType("customTextAnnotationType")
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
        
        if annotationType == .customTextAnnotationType {
            let textAnnotation = TextAnnotation()
            return textAnnotation
        }
        
        return annotation
        
    }
    
}

class TextAnnotation: SCITextAnnotation {
    
    var keyboardEventHandler : ((NSNotification, UITextView) -> ())?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardNotification(_ sender: NSNotification) {
        if let handler = keyboardEventHandler {
            if textView.isFirstResponder {
                handler(sender, textView)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
    
    var textAnnotationsKeyboardEventsHandler : ((NSNotification, UITextView) -> ())?
    
    private weak var mainPaneChartSurface: SCIChartSurface!
    private weak var subPaneRsiChartSurface: SCIChartSurface!
    private weak var subPaneMcadChartSurface: SCIChartSurface!
    
    private let sizeAxisAreaSync = SCIAxisAreaSizeSynchronization()
    private let defaultModifiers : SCIChartModifierCollection = SCIChartModifierCollection(childModifiers: [SCIMultiSurfaceModifier(modifierType: SCIPinchZoomModifier.self), SCIMultiSurfaceModifier(modifierType: SCIZoomExtentsModifier.self), SCIMultiSurfaceModifier(modifierType: SCIZoomPanModifier.self)])
  
    init(with mainChartSurface: SCIChartSurface, _ subRsiChartSurface: SCIChartSurface, _ subMcadChartSurface: SCIChartSurface) {
        mainPaneChartSurface = mainChartSurface
        subPaneRsiChartSurface = subRsiChartSurface
        subPaneMcadChartSurface = subMcadChartSurface
        sizeAxisAreaSync.syncMode = .right
        
        configureMainSurface()
        configureRsiSubSurface()
        configureMcadSubSurface()

        enableDefaultStateModifiers()
    }
    
    func enableDefaultStateModifiers() {
        mainPaneChartSurface.chartModifiers = defaultModifiers
        subPaneMcadChartSurface.chartModifiers = defaultModifiers
        subPaneRsiChartSurface.chartModifiers = defaultModifiers
    }
    
    func enableCreationUpAnnotation() {
        mainPaneChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createUpCreationModifier()])
        subPaneRsiChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createUpCreationModifier()])
        subPaneMcadChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createUpCreationModifier()])
    }
    
    func enableCreationDownAnnotation() {
        mainPaneChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createDownCreationModifier()])
        subPaneRsiChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createDownCreationModifier()])
        subPaneMcadChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createDownCreationModifier()])
    }
    
    func enableCreationLineAnnotation() {
        mainPaneChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createLineCreationModifier()])
        subPaneRsiChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createLineCreationModifier()])
        subPaneMcadChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createLineCreationModifier()])
    }
    
    func enableCreationTextAnnotation() {
        mainPaneChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createTextCreationModifier()])
        subPaneRsiChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createTextCreationModifier()])
        subPaneMcadChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [createTextCreationModifier()])
    }
    
    func setupSurfacesWithTraderModel(with traderModel: TraderViewModel) {
        
        mainPaneChartSurface.annotations.clear()
        subPaneMcadChartSurface.annotations.clear()
        subPaneRsiChartSurface.annotations.clear()
        
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
    
    private func createLineCreationModifier() -> SCIAnnotationCreationModifier {
        let creationLineModfier = SCIAnnotationCreationModifier(annotationType: .lineAnnotationType)
        let handler = { [unowned self] ( annotation : SCIAnnotationProtocol, type : SCIAnnotationCreationType) -> Void in
            self.enableDefaultStateModifiers()
        };
        
        creationLineModfier.creationHanlder = handler
        return creationLineModfier
    }
    
    private func createTextCreationModifier() -> SCIAnnotationCreationModifier {
        let creationModfier = SCIAnnotationCreationModifier(annotationType: .customTextAnnotationType)
        creationModfier.annotationsFactory = TraderAnnotationFactory()
        let handler = { [unowned self] ( annotation : SCIAnnotationProtocol, type : SCIAnnotationCreationType) -> Void in
            if let textAnnotation = annotation as? TextAnnotation {
                textAnnotation.keyboardEventHandler = self.textAnnotationsKeyboardEventsHandler
                textAnnotation.text = "TYPE TEXT"
                textAnnotation.style.textColor = .lightText
                textAnnotation.isSelected = true
                textAnnotation.draw()
                
            }
            self.enableDefaultStateModifiers()
        };
        
        creationModfier.creationHanlder = handler
        return creationModfier
    }
    
    private func createUpCreationModifier() -> SCIAnnotationCreationModifier {
        let creationModfier = SCIAnnotationCreationModifier(annotationType: .upArrowAnnotationType)
        let handler = { [unowned self] ( annotation : SCIAnnotationProtocol, type : SCIAnnotationCreationType) -> Void in
            self.enableDefaultStateModifiers()
        };
        
        creationModfier.creationHanlder = handler
        creationModfier.annotationsFactory = TraderAnnotationFactory()
        return creationModfier
    }
    
    private func createDownCreationModifier() -> SCIAnnotationCreationModifier {
        let creationModfier = SCIAnnotationCreationModifier(annotationType: .downArrowAnnotationType)
        let handler = { [unowned self] ( annotation : SCIAnnotationProtocol, type : SCIAnnotationCreationType) -> Void in
            self.enableDefaultStateModifiers()
        };
        
        creationModfier.creationHanlder = handler
        creationModfier.annotationsFactory = TraderAnnotationFactory()
        return creationModfier
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
        
    }
    
    private func configureRsiSubSurface() {
        subPaneRsiChartSurface.xAxes.add(SCICategoryDateTimeAxis())
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        subPaneRsiChartSurface.yAxes.add(yAxis)
        
        rsiRenderableSeries.strokeStyle = SCISolidPenStyle(color: UIColor.strokeRSIColor(), withThickness: 1.0)
        subPaneRsiChartSurface.renderableSeries.add(rsiRenderableSeries)
        
        sizeAxisAreaSync.attachSurface(subPaneRsiChartSurface)

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
