//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RolloverCustomizationChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

fileprivate class CustomSeriesInfo: SCIXySeriesInfo {
    override func createDataSeriesView() -> SCITooltipDataView! {
        let view : CustomTooltipViewSwift = CustomTooltipViewSwift.createInstance() as! CustomTooltipViewSwift
        view.setData(self)
        
        return view
    }
}

fileprivate class CustomLineSeries: SCIFastLineRenderableSeries {
    override func toSeriesInfo(withHitTest info: SCIHitTestInfo) -> SCISeriesInfo! {
        return CustomSeriesInfo(series: self, hitTest: info)
    }
}

class RolloverCustomizationChartView: SingleChartLayout {
    
    private let PointsCount: Int32 = 200
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        let yAxis = SCINumericAxis()
        
        let randomWalkGenerator = RandomWalkGenerator()
        let data1 = randomWalkGenerator?.getRandomWalkSeries(PointsCount)
        randomWalkGenerator?.reset()
        let data2 = randomWalkGenerator?.getRandomWalkSeries(PointsCount)
        
        let ds1 = SCIXyDataSeries(xType: .double, yType: .double)
        ds1.seriesName = "Series #1"
        let ds2 = SCIXyDataSeries(xType: .double, yType: .double)
        ds2.seriesName = "Series #2"
        
        ds1.appendRangeX(data1!.xValues, y: data1!.yValues, count: data1!.size)
        ds2.appendRangeX(data2!.xValues, y: data2!.yValues, count: data2!.size)
        
        let line1 = CustomLineSeries()
        line1.dataSeries = ds1
        line1.strokeStyle = SCISolidPenStyle(colorCode: 0xff6495ed, withThickness: 2)
        
        let line2 = CustomLineSeries()
        line2.dataSeries = ds2
        line2.strokeStyle = SCISolidPenStyle(colorCode: 0xffe2460c, withThickness: 2)
        
        let pointMarker = SCIEllipsePointMarker()
        pointMarker.strokeStyle = SCISolidPenStyle(color: UIColor.gray, withThickness: 0.5)
        pointMarker.width = 10
        pointMarker.height = 10
        
        let rolloverModifier = SCIRolloverModifier()
        rolloverModifier.style.contentPadding = 0
        rolloverModifier.style.colorMode = .default
        rolloverModifier.style.tooltipColor = UIColor.fromARGBColorCode(0xffe2460c)
        rolloverModifier.style.tooltipOpacity = 0.8
        rolloverModifier.style.tooltipBorderWidth = 1
        rolloverModifier.style.tooltipBorderColor = UIColor.fromARGBColorCode(0xff6495ed)
        rolloverModifier.style.axisTooltipColor = UIColor.fromARGBColorCode(0xff6495ed)
        rolloverModifier.style.pointMarker = pointMarker
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(line1)
            self.surface.renderableSeries.add(line2)
            self.surface.chartModifiers.add(rolloverModifier)
            
            line1.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            line2.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
