//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2023. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// DepthChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class DepthChartView: SCDDoubleChartPaneViewController {
    
    let buyHitTestInfo = SCIHitTestInfo()
    let sellHitTestInfo = SCIHitTestInfo()
    
    private var hitSurface = SCIChartSurface()
    var reversedXvalue = SCIDoubleValues()
    var reversedYvalue = SCIDoubleValues()
    var xValues = SCIDoubleValues()
    var yValues = SCIDoubleValues()
    var sellXPoint : Double = 0.0
    var sellYPoint : Double = 0.0
    let xSellLineAnnotation = SCIVerticalLineAnnotation()
    let xbuyLineAnnotation = SCIVerticalLineAnnotation()
    let ySellLineAnnotation = SCILineAnnotation()
    let ybuyLineAnnotation = SCILineAnnotation()
    let buyLabel = SCITextAnnotation()
    let sellLabel = SCITextAnnotation()
    
    
    override func initExample() {
        initChartfirstSurfaceView(surface:firstSurface)
        initChartSecondSurfaceView(surface:secondSurface)
        
    }
    
    fileprivate func initChartfirstSurfaceView(surface: SCIChartSurface) {
        let SCDPriceSeries = SCDDataManager.getPriceDataIndu()
        let size = Double(SCDPriceSeries.count)
        
        let xAxis = SCICategoryDateAxis()
        xAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        xAxis.visibleRange = SCIDoubleRange(min: size - 30, max: size)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        
        let dataSeries = SCIOhlcDataSeries(xType: .date, yType: .double)
        dataSeries.append(x: SCDPriceSeries.dateData, open: SCDPriceSeries.openData, high: SCDPriceSeries.highData, low: SCDPriceSeries.lowData, close: SCDPriceSeries.closeData)
        
        let rSeries = SCIFastCandlestickRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.fillDownBrushStyle = SCISolidBrushStyle(color: .red)
        rSeries.fillUpBrushStyle = SCISolidBrushStyle(color: 0x7767BDAF)
        rSeries.strokeDownStyle = SCISolidPenStyle(color: 0xFFDC7969, thickness: 1.0)
        rSeries.fillDownBrushStyle = SCISolidBrushStyle(color: 0x77DC7969)
        
        
        SCIUpdateSuspender.usingWith(surface) {
            surface.xAxes.add(xAxis)
            surface.yAxes.add(yAxis)
            surface.renderableSeries.add(rSeries)
            surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
            
            SCIAnimations.wave(rSeries, duration: 1.0, andEasingFunction: SCICubicEase())
        }
    }
    
    fileprivate func initChartSecondSurfaceView(surface: SCIChartSurface) {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        yAxis.axisAlignment = .right
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        
        let asksdataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        let bidsdataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        
        let asksSeries  = SCDDataManager.getInitialDataSeries("Asks_Initial_Data.csv")
        let bidsSeries  = SCDDataManager.getInitialDataSeries("Bids_Initial_Data.csv")
        var sumOfValues = 0.0
        for i in 0 ..< asksSeries.count {
            xValues.add(asksSeries[i].itemsArray[0])
            sumOfValues += (asksSeries[i].itemsArray[1])
            yValues.add(sumOfValues)
        }
        asksdataSeries.append(x: xValues, y: yValues)
        let xData = SCIDoubleValues()
        let yData = SCIDoubleValues()
        for i in 0 ..< bidsSeries.count {
            xData.add(bidsSeries[i].itemsArray[0])
            yData.add(bidsSeries[i].itemsArray[1])
        }
        let values = yData.itemsArray
        var totalValues = 0.0
        for (item) in values.reversed() {
            totalValues += item
            reversedYvalue.add(totalValues)
        }
        let bidxValues = xData.itemsArray
        for (item) in bidxValues.reversed() {
            reversedXvalue.add(item)
        }
        bidsdataSeries.acceptsUnsortedData = true
        bidsdataSeries.append(x: reversedXvalue, y: reversedYvalue)
        let renderAsksSeries = SCIFastLineRenderableSeries()
        renderAsksSeries.dataSeries = asksdataSeries
        renderAsksSeries.strokeStyle = SCISolidPenStyle(color: 0x77e97064, thickness: 2.0)
        let renderBidsSeries = SCIFastLineRenderableSeries()
        renderBidsSeries.dataSeries = bidsdataSeries
        renderBidsSeries.strokeStyle = SCISolidPenStyle(color: 0xFF67BDAF, thickness: 2.0)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.hitSurface = surface
            self.hitSurface.addGestureRecognizer(SCITapGestureRecognizer(target: self, action: #selector(self.handleSingleTap)))
            surface.xAxes.add(xAxis)
            surface.yAxes.add(yAxis)
            surface.renderableSeries.add(renderAsksSeries)
            surface.renderableSeries.add(renderBidsSeries)
            SCIAnimations.sweep(renderAsksSeries, duration: 1.0, easingFunction: SCICubicEase())
            SCIAnimations.sweep(renderBidsSeries, duration: 1.0, easingFunction: SCICubicEase())
        }
    }
    
    fileprivate func createLabelWith(text: String?, labelPlacement: SCILabelPlacement) -> SCIAnnotationLabel {
        let annotationLabel = SCIAnnotationLabel()
        if (text != nil) {
            annotationLabel.text = text!
        }
        annotationLabel.labelPlacement = labelPlacement
        return annotationLabel
    }
    
    @objc fileprivate func handleSingleTap(_ recognizer: SCITapGestureRecognizer) {
        let location = recognizer.location(in: recognizer.view!)
        let hitTestPoint = self.hitSurface.translate(location, hitTestable: self.hitSurface.renderableSeriesArea)
        let seriesCollection = self.hitSurface.renderableSeries
        for i in 0 ..< seriesCollection.count {
            let rSeries = seriesCollection[i]
            if (i == 0) {
                rSeries.verticalSliceHitTest(sellHitTestInfo, at: hitTestPoint)
            } else {
                rSeries.verticalSliceHitTest(buyHitTestInfo, at: hitTestPoint)
            }
        }
            let midValueLine = (xValues.count + reversedXvalue.count)/2
            var buyxValues = [Double]()
            var sellxValues = [Double]()
            for i in 0 ..< xValues.count {
                buyxValues.append(xValues.itemsArray[i])
            }
            for i in 0 ..< reversedXvalue.count {
                sellxValues.append(reversedXvalue.itemsArray[i])
            }
            let sumOfxValues = buyxValues + sellxValues
            var midpoint = 0.0
            for i in 0 ..< sumOfxValues.count {
                if (i == midValueLine) {
                    midpoint = sumOfxValues[i]
                }
            }
            let middleLine = SCIVerticalLineAnnotation()
            middleLine.set(x1: midpoint)
            middleLine.set(y1: 0)
            middleLine.verticalAlignment = .fill;
            middleLine.stroke = SCISolidPenStyle(color: .lightGray, thickness: 2)
            var buyValue = 0.0
            var buyYvalue = 0.0
            if (buyHitTestInfo.isHit) {
                let item = buyHitTestInfo.dataSeriesIndex
                for i in 0 ..< reversedYvalue.count {
                    if (i == item) {
                        buyYvalue = reversedYvalue.itemsArray[i]
                    }
                    for i in 0 ..< reversedXvalue.count {
                        if (i == item) {
                            buyValue = reversedXvalue.itemsArray[i]
                        }
                    }
                }
                xbuyLineAnnotation.set(x1: buyValue)
                xbuyLineAnnotation.verticalAlignment = .fill;
                xbuyLineAnnotation.stroke = SCISolidPenStyle(color: .green, thickness: 2)
                xbuyLineAnnotation.annotationLabels.add(self.createLabelWith(text: nil, labelPlacement: .axis))
                
                let sellValue = midpoint  + (midpoint - buyValue)
                xSellLineAnnotation.set(x1: sellValue)
                xSellLineAnnotation.verticalAlignment = .fill;
                xSellLineAnnotation.stroke = SCISolidPenStyle(color: .red, thickness: 2)
                xSellLineAnnotation.annotationLabels.add(self.createLabelWith(text: nil, labelPlacement: .axis))
                
                ybuyLineAnnotation.set(x1: buyValue)
                ybuyLineAnnotation.set(x2: midpoint)
                ybuyLineAnnotation.set(y1: buyYvalue)
                ybuyLineAnnotation.set(y2: buyYvalue)
                ybuyLineAnnotation.stroke = SCISolidPenStyle(color: .green, thickness: 2)
                var sellYvalue = 0.0
                for i in 0 ..< yValues.count {
                    if (i == item) {
                        sellYvalue = yValues.itemsArray[i]
                    }
                }
                ySellLineAnnotation.set(x1: midpoint)
                ySellLineAnnotation.set(x2: sellValue)
                ySellLineAnnotation.set(y1: sellYvalue)
                ySellLineAnnotation.set(y2: sellYvalue)
                ySellLineAnnotation.stroke = SCISolidPenStyle(color: .red, thickness: 2)
                
                buyLabel.set(x1: midpoint)
                buyLabel.set(y1: buyYvalue)
                buyLabel.horizontalAnchorPoint = .right
                buyLabel.text = String(format: "%.2f", buyYvalue)
                buyLabel.fontStyle = SCIFontStyle(fontSize: 8, andTextColor: .white)
                
                sellLabel.set(x1: midpoint)
                sellLabel.set(y1: sellYvalue)
                sellLabel.horizontalAnchorPoint = .left
                sellLabel.text = String(format: "%.2f", sellYvalue)
                sellLabel.fontStyle = SCIFontStyle(fontSize: 8, andTextColor: .white)
                
                self.hitSurface.annotations = SCIAnnotationCollection.init(collection: [xbuyLineAnnotation,middleLine,xSellLineAnnotation,ybuyLineAnnotation,ySellLineAnnotation,buyLabel,sellLabel])
            }
            if(sellHitTestInfo.isHit) {
                let index = sellHitTestInfo.dataSeriesIndex
                for i in 0 ..< yValues.count {
                    if (i == index) {
                        sellYPoint = yValues.itemsArray[i]
                    }
                    for i in 0 ..< xValues.count {
                        if (i == index) {
                            sellXPoint = xValues.itemsArray[i]
                        }
                    }
                }
                xSellLineAnnotation.set(x1: sellXPoint)
                xSellLineAnnotation.verticalAlignment = .fill;
                xSellLineAnnotation.stroke = SCISolidPenStyle(color: .red, thickness: 2)
                xSellLineAnnotation.annotationLabels.add(self.createLabelWith(text: nil, labelPlacement: .axis))
                
                let buyValue = midpoint - (sellXPoint - midpoint)
                xbuyLineAnnotation.set(x1: buyValue)
                xbuyLineAnnotation.verticalAlignment = .fill;
                xbuyLineAnnotation.stroke = SCISolidPenStyle(color: .green, thickness: 2)
                xbuyLineAnnotation.annotationLabels.add(self.createLabelWith(text: nil, labelPlacement: .axis))
                var buyYvalue = 0.0
                for i in 0 ..< reversedYvalue.count {
                    if (i == index) {
                        buyYvalue = reversedYvalue.itemsArray[i]
                    }
                }
                ySellLineAnnotation.set(x1: midpoint)
                ySellLineAnnotation.set(x2: sellXPoint)
                ySellLineAnnotation.set(y1: sellYPoint)
                ySellLineAnnotation.set(y2: sellYPoint)
                ySellLineAnnotation.stroke = SCISolidPenStyle(color: .red, thickness: 2)
                
                ybuyLineAnnotation.set(x1: buyValue)
                ybuyLineAnnotation.set(x2: midpoint)
                ybuyLineAnnotation.set(y1: buyYvalue)
                ybuyLineAnnotation.set(y2: buyYvalue)
                ybuyLineAnnotation.stroke = SCISolidPenStyle(color: .green, thickness: 2)
                
                buyLabel.set(x1: midpoint)
                buyLabel.set(y1: buyYvalue)
                buyLabel.text = String(format: "%.2f", buyYvalue)
                buyLabel.horizontalAnchorPoint = .right
                buyLabel.fontStyle = SCIFontStyle(fontSize: 8, andTextColor: .white)
                
                sellLabel.set(x1: midpoint)
                sellLabel.set(y1: sellYPoint)
                sellLabel.text = String(format: "%.2f", sellYPoint)
                sellLabel.horizontalAnchorPoint = .left
                sellLabel.fontStyle = SCIFontStyle(fontSize: 8, andTextColor: .white)
                
                self.hitSurface.annotations = SCIAnnotationCollection.init(collection: [xSellLineAnnotation,middleLine,xbuyLineAnnotation,ybuyLineAnnotation,ySellLineAnnotation,buyLabel,sellLabel])
            }
        }
    
    }
