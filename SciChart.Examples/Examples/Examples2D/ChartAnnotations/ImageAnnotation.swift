//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AnnotationsAreEasyView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart.Protected.SCILabelProviderBase

class DistributionData {
    var arrCarsData: [[String: Any]] = [[:]]
    
    static let shared = DistributionData()
    
    private init() {
        
        arrCarsData = [
            ["country": "China", "cars_sold": 30094767, "icon": "cn"],
            ["country": "United States", "cars_sold": 15604278, "icon": "us"],
            ["country": "Japan", "cars_sold": 4779639, "icon": "jp"],
            ["country": "India", "cars_sold": 4108263, "icon": "in"],
            ["country": "Germany", "cars_sold": 2845764, "icon": "de"],
            ["country": "Brazil", "cars_sold": 2309243, "icon": "br"],
            ["country": "United Kingdom", "cars_sold": 1905522, "icon": "gb"],
            ["country": "France", "cars_sold": 1776921, "icon": "fr"],
            ["country": "Canada", "cars_sold": 1664327, "icon": "ca"],
            ["country": "Italy", "cars_sold": 1568623, "icon": "ir"]
        ]
    }
}

class ImageAnnotation: SCDImageAnnotationViewController {
    
    override var associatedType: AnyClass { return SCIChartSurface.self }
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.08, max: 0.08)
        xAxis.axisAlignment = .left
#if os(OSX)
        xAxis.axisTickLabelStyle = SCIAxisTickLabelStyle(alignment: .right, andMargins: NSEdgeInsetsZero)
#elseif os(iOS)
        xAxis.axisTickLabelStyle = SCIAxisTickLabelStyle(alignment: .right, andMargins: .zero)
#endif
        xAxis.isVisible = false
        xAxis.visibleRange = SCIDoubleRange(min: -1.5, max: 10)
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0, max: 0.2)
        yAxis.axisAlignment = .bottom
        yAxis.flipCoordinates = true
        
        let ds1 = SCIXyDataSeries(xType: .byte, yType: .double)
       
        var arrAnno = [ISCIAnnotation]()
        
        let distributionData = DistributionData.shared
        for i in 0 ..< distributionData.arrCarsData.count {
            let carData = distributionData.arrCarsData[i]
            let yValue = carData["cars_sold"]
            if let yValue = yValue as? Int {
                ds1.append(x: i, y:  yValue)
                
                ///Adding image annotation for each bar
                let imageAnno = SCIImageAnnotation()
                let imgName = carData["icon"] as? String ?? ""
                if let image = SCIImage(named: imgName) {
                    imageAnno.image = image
                }
                imageAnno.desiredSize = CGSize.init(width: 20, height: 20)
                imageAnno.contentMode = .aspectFit
                imageAnno.set(x1: i)
                imageAnno.set(y1: yValue)
                imageAnno.annotationPosition = [.left, .centerVertical]
                
                arrAnno.append(imageAnno)
            }
        }
        
        let rSeries = self.getRenderableSeriesWith(dataSeries: ds1, color: 0xff1f6f6f)
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(rSeries)
            
            let titleAnnotation = SCITextAnnotation()
            titleAnnotation.set(x1: -1.5)
            titleAnnotation.set(y1: 8000000)
            titleAnnotation.text = "Top 10 car markets"
            titleAnnotation.fontStyle = SCIFontStyle(fontDescriptor: SCIFontDescriptor(name: "ArialRoundedMTBold", size: 22.0), andTextColor: .white)
            
            let descriptionAnnotation = SCITextAnnotation()
            descriptionAnnotation.set(x1: 5.5)
            descriptionAnnotation.set(y1: 9000000)
            descriptionAnnotation.text = "The image annotation can be placed\nin front or behind the grid lines and\ncan either be fixed or\nmoved along with the chart."
            descriptionAnnotation.fontStyle = SCIFontStyle(fontDescriptor: SCIFontDescriptor(name: "ArialRoundedMTBold", size: 16.0), andTextColor: .white)
            
            self.imageAnnotation = SCIImageAnnotation()
            
            if let image = SCIImage(named: "image.background.moving") {
                self.imageAnnotation.image = image
            }
            self.imageAnnotation.annotationType = .background
            self.imageAnnotation.alpha = 0.4
            self.imageAnnotation.annotationSurface = .aboveGrid
            self.imageAnnotation.contentMode = self.imageAnnotationContentMode;
            
            arrAnno.append(titleAnnotation)
            arrAnno.append(descriptionAnnotation)
            arrAnno.append(self.imageAnnotation)

            self.surface.annotations = SCIAnnotationCollection(collection: arrAnno)
            self.surface.chartModifiers.add(SCDExampleBaseViewController.createDefaultModifiers())
        }
    }
    
    fileprivate func getRenderableSeriesWith(dataSeries: SCIXyDataSeries, color: uint) -> SCIFastColumnRenderableSeries {
        let rSeries = SCIFastColumnRenderableSeries()
        rSeries.dataSeries = dataSeries
        rSeries.fillBrushStyle = SCISolidBrushStyle(color: color)
        rSeries.strokeStyle = SCISolidPenStyle(color: .black, thickness: 0.5)
        
        return rSeries
    }
}
