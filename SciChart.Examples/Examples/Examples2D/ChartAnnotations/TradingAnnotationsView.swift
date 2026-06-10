//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2026. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TradingAnnotationsView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class TradingAnnotationsView: SCDTradingAnnotationsChartViewController{
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        let SCDPriceSeries = SCDDataManager.getPriceDataIndu()
        
        let xAxis = SCICategoryDateAxis()
        xAxis.growBy = SCIDoubleRange(min: 0, max: 0.1)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        
        let dataSeries = SCIOhlcDataSeries(xType: .date, yType: .double)
        dataSeries.append(x: SCDPriceSeries.dateData, open: SCDPriceSeries.openData, high: SCDPriceSeries.highData, low: SCDPriceSeries.lowData, close: SCDPriceSeries.closeData)
        
        let rSeries = SCIFastCandlestickRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.strokeUpStyle = SCISolidPenStyle(color: 0xDD67BDAF, thickness: 1.0)
        rSeries.fillUpBrushStyle = SCISolidBrushStyle(color: 0x7767BDAF)
        rSeries.strokeDownStyle = SCISolidPenStyle(color: 0xDDDC7969, thickness: 1.0)
        rSeries.fillDownBrushStyle = SCISolidBrushStyle(color: 0x77DC7969)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            
            /// Create Xabcd annotation with predefine points
            let xAbcdAnn = SCIXabcdAnnotation()
            xAbcdAnn.setBasePointWithX(NSNumber(value: 64), y: NSNumber(value: 12300))
            xAbcdAnn.setBasePointWithX(NSNumber(value: 70), y: NSNumber(value: 12000))
            xAbcdAnn.setBasePointWithX(NSNumber(value: 185), y: NSNumber(value: 12290))
            xAbcdAnn.setBasePointWithX(NSNumber(value: 260), y: NSNumber(value: 12290))
            xAbcdAnn.setBasePointWithX(NSNumber(value: 255), y: NSNumber(value: 12000))
            xAbcdAnn.fillBrush = SCISolidBrushStyle(color: 0x55AAAA00)
            xAbcdAnn.stroke = SCISolidPenStyle(color: 0xFFe97064, thickness: 2)
            xAbcdAnn.isEditable = true
            xAbcdAnn.showRatios = true
            
            /// Create Pitchfork annotation with predefine points
            let pitchfork = SCIPitchforkAnnotation()
            pitchfork.setBasePointWithX(NSNumber(value: 84), y: NSNumber(value: 11700)) // pivot
            pitchfork.setBasePointWithX(NSNumber(value: 135), y: NSNumber(value: 11200)) // upper
            pitchfork.setBasePointWithX(NSNumber(value: 150), y: NSNumber(value: 11800)) // lower
            pitchfork.halfWidthZoneFill = SCISolidBrushStyle(color: 0x401E90FF)
            pitchfork.fullWidthZoneFill  = SCISolidBrushStyle(color: 0x4000AA00)
            pitchfork.isEditable = true
            
            /// Create Pitchfork annotation with user interaction
            self.pitchforkCreationModifier = SCIPitchforkCreationModifier()
            self.pitchforkCreationModifier.halfWidthZoneFill = SCISolidBrushStyle(color: 0x401F9FFF)
            self.pitchforkCreationModifier.fullWidthZoneFill  = SCISolidBrushStyle(color: 0x40F0FA00)
            self.pitchforkCreationModifier.tineStroke = SCISolidPenStyle(color: 0xFF007064, thickness: 2)
            self.pitchforkCreationModifier.mainStroke = SCISolidPenStyle(color: 0xFF007064, thickness: 2)
            
            /// Callback triggered when all points are placed
            /// Gives access to the completed annotation object
            self.pitchforkCreationModifier.annotationCreationCompletionListener = { [weak self] createdAnnotation, type in
                guard self != nil else { return }
                
                print("PITCHFORK annotation created: \(createdAnnotation), type: \(SCIAnnotationTypeName(type))")
                
                if let annotation = createdAnnotation as? SCIPitchforkAnnotation {
                    /// Get data points
                    let points = annotation.getBaseDataValues()
                    print("Point A: \(points[0])")
                    print("Point B: \(points[1])")
                    print("Point C: \(points[2])")
                }
            }
            
            /// Create Xabcd annotation with user interaction
            self.xabcdCreationModifier = SCIXabcdCreationModifier()
            self.xabcdCreationModifier.annotationStroke = SCISolidPenStyle(color: 0xFFE97064, thickness: 2)
            self.xabcdCreationModifier.annotationFill = SCISolidBrushStyle(color: 0x55AAAA00)
            
            /// Callback triggered when all points (X, A, B, C, D) are placed
            /// Gives access to the completed annotation object
            self.xabcdCreationModifier.annotationCreationCompletionListener  = { [weak self] createdAnnotation, type in
                guard self != nil else { return }
                
                print("Annotation created: \(createdAnnotation), type: \(SCIAnnotationTypeName(type))")
                
                guard let xabcd = createdAnnotation as? SCIXabcdAnnotation else { return }
                let arrPoints = xabcd.getBaseDataValues()
                
                /// Get data points
                print("XABCD point X: \(arrPoints[0].x), \(arrPoints[0].y)")
                print("XABCD point A: \(arrPoints[1].x), \(arrPoints[1].y)")
                print("XABCD point B: \(arrPoints[2].x), \(arrPoints[2].y)")
                print("XABCD point C: \(arrPoints[3].x), \(arrPoints[3].y)")
                print("XABCD point D: \(arrPoints[4].x), \(arrPoints[4].y)")
            }
            
            self.surface.annotations.add(items: xAbcdAnn, pitchfork)
            self.surface.chartModifiers.add(items: self.pitchforkCreationModifier)
        }
        
        addInstructionForMarkers()
    }
    
    private func addInstructionForMarkers() {
        instructionAnnotation.set(x1: 5)
        instructionAnnotation.set(y1: 13000)
        
        instructionAnnotation.verticalAnchorPoint = .top
        instructionAnnotation.fontStyle = SCIFontStyle(fontSize: 15, andTextColorCode: 0xFFFFFFFF)
        
        surface.annotations.add(instructionAnnotation)
    }
}
