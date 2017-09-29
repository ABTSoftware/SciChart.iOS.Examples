//
//  TraderChartSurfacesConfigurator.swift
//  SciChartShowcaseDemo
//
//  Created by Gkol on 7/31/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

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
    private var themeKey: String = SCIChart_SciChartv4DarkStyleKey
    
    private let sizeAxisAreaSync = SCIAxisAreaSizeSynchronization()
    private let axisRangeSync = SCIAxisRangeSynchronization()
    
    private var averageLowAxisMarker: SCIAxisMarkerAnnotation?
    private var averageHighAxisMarker: SCIAxisMarkerAnnotation?
    private var rsiAxisMarker: SCIAxisMarkerAnnotation?
    private var mcadAxisMarker: SCIAxisMarkerAnnotation?
    private var mcadY1AxisMarker: SCIAxisMarkerAnnotation?
    private var visibleRange: SCIRangeProtocol?
  
    init(with mainChartSurface: SCIChartSurface, _ subRsiChartSurface: SCIChartSurface, _ subMcadChartSurface: SCIChartSurface) {
        mainPaneChartSurface = mainChartSurface
        subPaneRsiChartSurface = subRsiChartSurface
        subPaneMcadChartSurface = subMcadChartSurface
        sizeAxisAreaSync.syncMode = .right
        
        configureMainSurface()
        configureRsiSubSurface()
        configureMcadSubSurface()

        enableDefaultStateModifiers()
        
        SCIThemeManager.addTheme(byThemeKey: SCIChart_SciChartv4DarkStyleKey)
        SCIThemeManager.addTheme(byThemeKey: SCIChart_Bright_SparkStyleKey)
        
    }
    
    func saveCurrentVisibleRange() {

        let visibleRangeCurrent = mainPaneChartSurface.xAxes[0].visibleRange!
        
        var minIndex = SCIGenericInt(visibleRangeCurrent.min)
        var maxIndex = SCIGenericInt(visibleRangeCurrent.max)
        
        if (minIndex >= 0 || maxIndex < ohlcRenderableSeries.dataSeries.xValues().count()) {
            if (minIndex <= 0 && maxIndex < ohlcRenderableSeries.dataSeries.xValues().count()) {
                minIndex = 0
                
            }
            else if (minIndex >= 0 && maxIndex >= ohlcRenderableSeries.dataSeries.xValues().count()) {
                maxIndex = ohlcRenderableSeries.dataSeries.xValues().count()-1
            }
            
            let minDate = SCIGenericDate(ohlcRenderableSeries.dataSeries.xValues().value(at: minIndex))!
            let maxDate = SCIGenericDate(ohlcRenderableSeries.dataSeries.xValues().value(at: maxIndex))!
            visibleRange = SCIDateRange(dateMin: minDate, max: maxDate)
        }
        else {
            visibleRange = nil
        }
  
    }
    
    func tryToSetLastVisibleRange() {
        if let lastVisibleRange = visibleRange {
            
            let minDate = SCIGenericDate(ohlcRenderableSeries.dataSeries.xValues().value(at: 0))!
            let maxDate = SCIGenericDate(ohlcRenderableSeries.dataSeries.xValues().value(at: ohlcRenderableSeries.dataSeries.xValues().count()-1))!
            
            if minDate.compare(SCIGenericDate(lastVisibleRange.min)) == ComparisonResult.orderedAscending &&
               maxDate.compare(SCIGenericDate(lastVisibleRange.max)) == ComparisonResult.orderedDescending {
                
                var minIndex = ohlcRenderableSeries.dataSeries.xValues().index(of: lastVisibleRange.min, isSorted: true, searchMode: .nearest)
                var maxIndex = ohlcRenderableSeries.dataSeries.xValues().index(of: lastVisibleRange.max, isSorted: true, searchMode: .nearest)
                
                if minIndex == maxIndex && ohlcRenderableSeries.dataSeries.xValues().count() > 1 {
                    
                    if minIndex == 0 {
                        maxIndex = 1
                    }
                    if maxIndex == ohlcRenderableSeries.dataSeries.xValues().count()-1 {
                        minIndex = ohlcRenderableSeries.dataSeries.xValues().count()-2
                    }
                    
                    minIndex = minIndex-1
                    
                }
                
                let indexVisibleRange = SCIDoubleRange(min: SCIGeneric(Double(minIndex)), max: SCIGeneric(Double(maxIndex)))
                mainPaneChartSurface.xAxes[0].visibleRange = indexVisibleRange
                
            }
            else {
                mainPaneChartSurface.zoomExtents()
            }
        }
        else {
            mainPaneChartSurface.zoomExtents()
        }
        visibleRange = nil
    }
    
    func changeTheme() {
        if themeKey == SCIChart_SciChartv4DarkStyleKey {
            themeKey = SCIChart_Bright_SparkStyleKey
        }
        else {
            themeKey = SCIChart_SciChartv4DarkStyleKey
        }
        
        applyTheme(themeKey)
    }

    func currentTheme() -> String {
        return themeKey
    }
    
    func enableDefaultStateModifiers() {
        mainPaneChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
        subPaneMcadChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
        subPaneRsiChartSurface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), SCIZoomExtentsModifier(), SCIZoomPanModifier()])
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
        
//        mainPaneChartSurface.zoomExtents()
//        subPaneMcadChartSurface.zoomExtents()
//        subPaneRsiChartSurface.zoomExtents()
        
        averageLowAxisMarker = addAxisMarkerAnnotation(yID: mainPaneChartSurface.yAxes[0].axisId,
                                                       valueFormat: "$%.1f",
                                                       value: averageLowRenderableSeries.dataSeries.yValues().value(at: averageLowRenderableSeries.dataSeries.count()-1))
        mainPaneChartSurface.annotations.add(averageLowAxisMarker)
        
        averageHighAxisMarker = addAxisMarkerAnnotation(yID: mainPaneChartSurface.yAxes[0].axisId,
                                                        valueFormat: "$%.1f",
                                                        value: averageHighRenderableSeries.dataSeries.yValues().value(at: averageHighRenderableSeries.dataSeries.count()-1))
        mainPaneChartSurface.annotations.add(averageHighAxisMarker)

        rsiAxisMarker = addAxisMarkerAnnotation(yID: subPaneRsiChartSurface.yAxes[0].axisId,
                                                valueFormat: "$%.1f",
                                                value: rsiRenderableSeries.dataSeries.yValues().value(at: rsiRenderableSeries.dataSeries.count()-1))
        subPaneRsiChartSurface.annotations.add(rsiAxisMarker)

        mcadAxisMarker = addAxisMarkerAnnotation(yID: subPaneMcadChartSurface.yAxes[0].axisId,
                                                 valueFormat: "$%.1f",
                                                 value: traderModel.mcad.yValues().value(at: traderModel.mcad.count()-1))
        subPaneMcadChartSurface.annotations.add(mcadAxisMarker)
        
        mcadY1AxisMarker = addAxisMarkerAnnotation(yID: subPaneMcadChartSurface.yAxes[0].axisId,
                                                   valueFormat: "$%.1f",
                                                   value: traderModel.mcad.y1Values().value(at: traderModel.mcad.count()-1))
        subPaneMcadChartSurface.annotations.add(mcadY1AxisMarker)
        
        applyTheme(SCIChart_SciChartv4DarkStyleKey)
        
    }
    
    func setupOnlyIndicators(_ indicators:[TraderIndicators]) {
        averageHighRenderableSeries.isVisible = indicators.contains(.movingAverage100)
        averageLowRenderableSeries.isVisible = indicators.contains(.movingAverage50)
        mainPaneChartSurface.zoomExtents()
        subPaneMcadChartSurface.zoomExtents()
        subPaneRsiChartSurface.zoomExtents()
    }
    
    private func applyTheme(_ themeKey: String) {
        
        if let colorProvider = SCIThemeManager.themeProvider(with: themeKey) {
            colorProvider.tickTextStyle.fontSize = 8
        
            mainPaneChartSurface.applyThemeProvider(colorProvider)
            subPaneMcadChartSurface.applyThemeProvider(colorProvider)
            subPaneRsiChartSurface.applyThemeProvider(colorProvider)
            
            mainPaneChartSurface.xAxes[0].style.majorGridLineBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            subPaneMcadChartSurface.xAxes[0].style.majorGridLineBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            subPaneRsiChartSurface.xAxes[0].style.majorGridLineBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            
            mainPaneChartSurface.yAxes[0].style.majorGridLineBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            subPaneMcadChartSurface.yAxes[0].style.majorGridLineBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            subPaneRsiChartSurface.yAxes[0].style.majorGridLineBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            
            mainPaneChartSurface.xAxes[0].style.majorTickBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            subPaneMcadChartSurface.xAxes[0].style.majorTickBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            subPaneRsiChartSurface.xAxes[0].style.majorTickBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            
            mainPaneChartSurface.yAxes[0].style.majorTickBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            subPaneMcadChartSurface.yAxes[0].style.majorTickBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
            subPaneRsiChartSurface.yAxes[0].style.majorTickBrush = SCISolidPenStyle(color: colorProvider.majorGridLinesStyle.color, withThickness: 0.5)
        }

        averageLowRenderableSeries.strokeStyle = SCISolidPenStyle(color: UIColor.strokeAverageLowColor(), withThickness: 1.0)
        averageHighRenderableSeries.strokeStyle = SCISolidPenStyle(color: UIColor.strokeAverageHighColor(), withThickness: 1.0)
        
        rsiAxisMarker?.style.backgroundColor = UIColor.strokeRSIColor()
        averageLowAxisMarker?.style.backgroundColor = UIColor.strokeAverageLowColor()
        averageHighAxisMarker?.style.backgroundColor = UIColor.strokeAverageHighColor()
        mcadAxisMarker?.style.backgroundColor = UIColor.strokeMcadColor()
        mcadY1AxisMarker?.style.backgroundColor = UIColor.strokeY1McadColor()

        rsiAxisMarker?.style.textColor = .black
        averageLowAxisMarker?.style.textColor = .black
        averageHighAxisMarker?.style.textColor = .black
        mcadAxisMarker?.style.textColor = .black
        mcadY1AxisMarker?.style.textColor = .black

        volumeRenderableSeries.style.strokeStyle = nil
        volumeRenderableSeries.style.fillBrushStyle = SCISolidBrushStyle(color: UIColor.traderColumnColor())
        histogramRenderableSeries.style.strokeStyle = nil
        histogramRenderableSeries.style.fillBrushStyle = SCISolidBrushStyle(color: UIColor.traderColumnColor())
        
        mainPaneChartSurface.xAxes[0].style.drawMinorGridLines = false
        subPaneMcadChartSurface.xAxes[0].style.drawMinorGridLines = false
        subPaneRsiChartSurface.xAxes[0].style.drawMinorGridLines = false
        
        mainPaneChartSurface.yAxes[0].style.drawMinorGridLines = false
        subPaneMcadChartSurface.yAxes[0].style.drawMinorGridLines = false
        subPaneRsiChartSurface.yAxes[0].style.drawMinorGridLines = false
        
        mainPaneChartSurface.yAxes[0].style.drawMinorTicks = false
        subPaneMcadChartSurface.yAxes[0].style.drawMinorTicks = false
        subPaneRsiChartSurface.yAxes[0].style.drawMinorTicks = false

        mainPaneChartSurface.renderableSeriesAreaBorder = SCISolidPenStyle(color: .clear, withThickness: 0.0)
        subPaneMcadChartSurface.renderableSeriesAreaBorder = SCISolidPenStyle(color: .clear, withThickness: 0.0)
        subPaneRsiChartSurface.renderableSeriesAreaBorder = SCISolidPenStyle(color: .clear, withThickness: 0.0)

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
                textAnnotation.style.viewSetup = {[unowned textAnnotation] view in
                    
                    if let textView = view {
                        
                        let bindingArea = textAnnotation.getBindingArea()
                        let annotationFrame = textView.frame
                        
                        if  !bindingArea.contains(annotationFrame.origin) &&
                            !bindingArea.contains(CGPoint(x: annotationFrame.origin.x + annotationFrame.size.width, y: annotationFrame.origin.y)) &&
                            !bindingArea.contains(CGPoint(x: annotationFrame.origin.x, y: annotationFrame.origin.y + annotationFrame.size.height)) &&
                            !bindingArea.contains(CGPoint(x: annotationFrame.origin.x + annotationFrame.size.width, y: annotationFrame.origin.y + annotationFrame.size.height)) {
                            textView.isHidden = true
                        }
                        else {
                            textView.isHidden = false
                            if (annotationFrame.origin.x + annotationFrame.size.width) > (bindingArea.size.width + bindingArea.origin.x) ||
                                annotationFrame.origin.x < bindingArea.origin.x ||
                                annotationFrame.origin.y < bindingArea.origin.y ||
                                (annotationFrame.origin.y + annotationFrame.size.height) > (bindingArea.size.height + bindingArea.origin.y)
                            {
                                
                                var maskFrame = CGRect()
                                let layerShape = CAShapeLayer()
                                
                                let differenceX = (annotationFrame.origin.x + annotationFrame.size.width) - (bindingArea.size.width+bindingArea.origin.x)
                                let differenceY = (annotationFrame.origin.y + annotationFrame.size.height) - (bindingArea.size.height+bindingArea.origin.y)
                                
                                maskFrame = CGRect(x: annotationFrame.origin.x - bindingArea.origin.x < 0 ? abs(annotationFrame.origin.x - bindingArea.origin.x) : 0,
                                                   y: annotationFrame.origin.y - bindingArea.origin.y < 0 ? abs(annotationFrame.origin.y - bindingArea.origin.y) : 0,
                                                   width: annotationFrame.size.width - differenceX,
                                                   height: annotationFrame.size.height - differenceY)
                                
                                let path = CGPath(rect: maskFrame, transform: nil)
                                layerShape.path = path
                                
                                textView.layer.mask = layerShape
                                
                            }
                            else {
                                textView.layer.mask = nil
                            }   
                        }   
                    }
                }
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
 
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.style.recommendedSize = 26
        mainPaneChartSurface.xAxes.add(xAxis)
        axisRangeSync.attachAxis(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        mainPaneChartSurface.yAxes.add(yAxis)
   
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
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.style.recommendedSize = 26
        subPaneRsiChartSurface.xAxes.add(xAxis)
        axisRangeSync.attachAxis(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        subPaneRsiChartSurface.yAxes.add(yAxis)

        subPaneRsiChartSurface.renderableSeries.add(rsiRenderableSeries)
        
        sizeAxisAreaSync.attachSurface(subPaneRsiChartSurface)

    }
    
    private func configureMcadSubSurface() {
        let xAxis = SCICategoryDateTimeAxis()
        xAxis.style.recommendedSize = 26
        subPaneMcadChartSurface.xAxes.add(xAxis)
        axisRangeSync.attachAxis(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .always
        subPaneMcadChartSurface.yAxes.add(yAxis)
        subPaneMcadChartSurface.renderableSeries.add(histogramRenderableSeries)
        subPaneMcadChartSurface.renderableSeries.add(mcadRenderableSeries)

        sizeAxisAreaSync.attachSurface(subPaneMcadChartSurface)
    }
    
    private func addAxisMarkerAnnotation(yID:String, valueFormat:String, value:SCIGenericType) -> SCIAxisMarkerAnnotation {
        let axisMarker = SCIAxisMarkerAnnotation()
        axisMarker.yAxisId = yID;
        axisMarker.style.margin = 5;
        axisMarker.formattedValue = String.init(format: valueFormat, SCIGenericDouble(value));
        axisMarker.coordinateMode = .absolute
        axisMarker.position = value;
        return axisMarker
    }
}
