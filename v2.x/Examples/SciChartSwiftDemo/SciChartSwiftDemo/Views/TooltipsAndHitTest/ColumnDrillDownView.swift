//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ColumnDrillDownView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

// MARK: Custom modifier

class ColumnHitTest: SCIGestureModifier {
    
    var tapedAtIndex: SCIActionBlock_Pint! = nil
    var doubleTaped: SCIActionBlock! = nil
    
    var _location = CGPoint.zero  // position of tap gesture
    var _index : Int32 = 0
    
    override func onTapGesture (_ gesture: UITapGestureRecognizer!, at view: UIView!) -> Bool {
        let location : CGPoint = gesture.location(in: view)
        let rs : SCIRenderSurfaceProtocol = self.parentSurface.renderSurface!
        if (!rs.isPoint(withinBounds: location)) { return false }
        if (gesture.state == .ended) {
            // save location of touch
            _location = location
            let parent: SCIChartSurfaceProtocol = self.parentSurface
            let series = parent.renderableSeries as SCIRenderableSeriesCollection
            let surface = parent.renderSurface!
            let actualLocation = surface.point(inChartFrame: _location)
            
            let count : Int32 = series.count()
            // check every renderable series for hit
            for i in 0..<count {
                let rSeries: SCIRenderableSeriesProtocol = series.item(at:UInt32(i))!
                let data: SCIRenderPassDataProtocol = rSeries.currentRenderPassData
                let hitTest: SCIHitTestProviderProtocol = rSeries.hitTestProvider() // get hit test tools
                
                // hit test verticaly: check if vertical projection through touch location crosses chart
                let hitTestResult : SCIHitTestInfo = hitTest.hitTestVerticalAt(x: Double(actualLocation.x), y: Double(actualLocation.y), radius: 5, onData: data)
                if (hitTestResult.match).boolValue {
                    // if hit is registered on series
                    // get values at closest point to hit test position
                    _index = hitTestResult.index
                    if tapedAtIndex != nil {
                        tapedAtIndex(_index)
                    }
                }
            }
        }
        return true
    }
    
    override func onDoubleTapGesture (_ gesture: UITapGestureRecognizer!, at view: UIView!) -> Bool {
        let location: CGPoint = gesture.location(in: view)
        let rs: SCIRenderSurfaceProtocol = self.parentSurface.renderSurface!
        if (!rs.isPoint(withinBounds: location)) { return false }
        if doubleTaped != nil {
            doubleTaped()
        }
        return true
    }
}

// MARK: Palette provider

class ColumnDrillDownPalette: SCIPaletteProvider {
    var styles = [SCIStyleProtocol?]()
    
    func addStyle(_ style: SCIStyleProtocol) {
        styles.append(style)
    }
    
    override func styleFor(x: Double, y: Double, index: Int32) -> SCIStyleProtocol! {
        if (index > Int32(styles.count)) {
            return nil
        }
        return styles[Int(index)]
    }
}

// MARK: Example view

class ColumnDrillDownView: SingleChartLayout {
    
    var _totalData: SCIXyDataSeries! = nil
    
    var _firstColumn: SCIFastColumnRenderableSeries! = nil
    var _secondColumn: SCIFastColumnRenderableSeries! = nil
    var _thirdColumn: SCIFastColumnRenderableSeries! = nil
    var _totalColumn: SCIFastColumnRenderableSeries! = nil
    
    var _isShowingTotal = false
    
    override func initExample() {
        let xAxis = SCICategoryNumericAxis()
        xAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: SCIGeneric(0.1), max: SCIGeneric(0.1))
        
        _totalData = SCIXyDataSeries(xType: .int32, yType: .int32)

        _firstColumn = SCIFastColumnRenderableSeries()
        _firstColumn.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFF00FFFF, finish: 0xA000FFFF, direction: .vertical)
        _firstColumn.strokeStyle = nil
        _firstColumn.dataSeries = getDataSeries()
        
        _secondColumn = SCIFastColumnRenderableSeries()
        _secondColumn.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFF00FF00, finish: 0xA000FF00, direction: .vertical)
        _secondColumn.strokeStyle = nil
        _secondColumn.dataSeries = getDataSeries()
        
        _thirdColumn = SCIFastColumnRenderableSeries()
        _thirdColumn.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFFFF0000, finish: 0xA0FF0000, direction: .vertical)
        _thirdColumn.strokeStyle = nil
        _thirdColumn.dataSeries = getDataSeries()

        let palette = ColumnDrillDownPalette()
        palette.addStyle(_firstColumn.style)
        palette.addStyle(_secondColumn.style)
        palette.addStyle(_thirdColumn.style)
        
        _totalColumn = SCIFastColumnRenderableSeries()
        _totalColumn.fillBrushStyle = SCILinearGradientBrushStyle(colorCodeStart: 0xFF505050, finish: 0xA550005, direction: .vertical)
        _totalColumn.strokeStyle = nil
        _totalColumn.dataSeries = _totalData
        _totalColumn.paletteProvider = palette

        let drillDownModifier = ColumnHitTest()
        weak var wSelf = self
        drillDownModifier.doubleTaped = { wSelf?.showSeries((wSelf?._totalColumn)!, isTotal: true) }
        drillDownModifier.tapedAtIndex = { (index ) in wSelf?.showDetailedChart(index) }
        
        SCIUpdateSuspender.usingWithSuspendable(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.chartModifiers = SCIChartModifierCollection(childModifiers: [SCIPinchZoomModifier(), drillDownModifier])
            
            let animation = SCIWaveRenderableSeriesAnimation(duration: 3, curveAnimation: .easeOut)
            animation.repeatable = true
            
            self._firstColumn.addAnimation(animation)
            self._secondColumn.addAnimation(animation)
            self._thirdColumn.addAnimation(animation)
            self._totalColumn.addAnimation(animation)
            
            self.showSeries(self._totalColumn, isTotal: true)
        }
    }
    
    fileprivate func getDataSeries() -> SCIXyDataSeries! {
        let dataSeries = SCIXyDataSeries(xType: .int32, yType: .int32)
        
        var total: UInt32 = 0
        let count = arc4random_uniform(5) + 3
        for i in 0..<count {
            let value = arc4random_uniform(5 + i) + 1
            total += value
            dataSeries.appendX(SCIGeneric(i), y: SCIGeneric(value))
        }
        _totalData.appendX(SCIGeneric(3), y: SCIGeneric(total))
        
        return dataSeries
    }
    
    fileprivate func showDetailedChart(_ index: Int32) {
        if (!_isShowingTotal) { return }
        if index == 0 {
            showSeries(_firstColumn, isTotal: false)
        } else if index == 1 {
            showSeries(_secondColumn, isTotal: false)
        } else if index == 2 {
            showSeries(_thirdColumn, isTotal: false)
        }
    }
    
    fileprivate func showSeries(_ series: SCIRenderableSeriesProtocol, isTotal: Bool) {
        _isShowingTotal = isTotal
        surface.renderableSeries.clear()
        surface.renderableSeries.add(series)
        
        surface.viewportManager.zoomExtents()
    }
}
