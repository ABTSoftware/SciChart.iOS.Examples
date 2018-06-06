//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CursorCustomizationChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

class CustomCursorViewSwift: SCIXySeriesDataView {
    
    @IBOutlet weak var seriesName: UILabel!
    
    static override func createInstance() -> SCITooltipDataView! {
        let view : CustomCursorViewSwift = (Bundle.main.loadNibNamed("CustomCursorViewSwift", owner: nil, options: nil)![0] as? CustomCursorViewSwift)!
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }
    
    func setData(_ data: SCIXySeriesInfo!) {
        seriesName.text = String(format: "%@ - X: %@; Y: %@", data.seriesName(), data.formatXCursorValue(data.xValue()), data.formatXCursorValue(data.yValue()))
    }
}

fileprivate class CustomSeriesInfo: SCIXySeriesInfo {
    override func createDataSeriesView() -> SCITooltipDataView! {
        let view : CustomCursorViewSwift = CustomCursorViewSwift.createInstance() as! CustomCursorViewSwift
        view.setData(self)
        
        return view
    }
}

fileprivate class CustomLineSeries: SCIFastLineRenderableSeries {
    override func toSeriesInfo(withHitTest info: SCIHitTestInfo) -> SCISeriesInfo! {
        return CustomSeriesInfo(series: self, hitTest: info)
    }
}

class CursorCustomizationChartView: SingleChartLayout {
    
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

        let cursorModifier = SCICursorModifier()
        cursorModifier.style.contentPadding = 0
        cursorModifier.style.colorMode = .default
        cursorModifier.style.tooltipColor = UIColor.fromARGBColorCode(0xff6495ed)
        cursorModifier.style.tooltipOpacity = 0.8
        cursorModifier.style.tooltipBorderWidth = 1
        cursorModifier.style.tooltipBorderColor = UIColor.fromARGBColorCode(0xffe2460c)
        cursorModifier.style.cursorPen = SCISolidPenStyle(color: UIColor.fromARGBColorCode(0xffe2460c), withThickness: 0.5)
        cursorModifier.style.axisVerticalTooltipColor = UIColor.fromARGBColorCode(0xffe2460c)
        cursorModifier.style.axisHorizontalTooltipColor = UIColor.fromARGBColorCode(0xffe2460c)
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(line1)
            self.surface.renderableSeries.add(line2)
            self.surface.chartModifiers.add(cursorModifier)
            
            line1.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
            line2.addAnimation(SCISweepRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut))
        }
    }
}
