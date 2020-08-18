//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// AnimationSandboxView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit

class AnimationSandboxView: AnimationsSandboxLayout, UIPickerViewDelegate, UIPickerViewDataSource {

    static let pointsCount = 10
    static let offset: Float = 500.0
    
    enum EasingFunctions: String, CaseIterable {
        case None = "None"
        case Quadratic = "Quadratic"
        case Cubic = "Cubic"
        case Elastic = "Elastic"
        func getFunction() -> ISCIEasingFunction? {
            switch self {
            case .None:
                return nil
            case .Quadratic:
                return SCIQuadraticEase()
            case .Cubic:
                return SCICubicEase()
            case .Elastic:
                return SCIElasticEase()
            }
        }
    }
    
    enum SeriesTypes: String, CaseIterable {
        case Column = "Column"
        case Line = "Line"
        case Impulse = "Impulse"
        case Mountain = "Mountain"
        case XyScatter = "XyScatter"
        case ErrorBars = "ErrorBars"
        case FixedErrorBars = "Fixed ErrorBars"
        case Bubble = "Bubble"
        case Band = "Band"
        case Ohlc = "Ohlc"
        case Candlestick = "Candlestick"
        case SplineLine = "SpineLine"
        case SplineMountain = "SpineMountain"
        case SplineBand = "SpineBand"
    }
    
    weak var renderableSeries: ISCIRenderableSeries?
    var easingFunction: ISCIEasingFunction?
    
    override func commonInit() {
        let picker = UIPickerView()
        picker.delegate = self
        selectSeriesTextField.inputView = picker
        selectSeriesTextField.text = SeriesTypes.Column.rawValue
        selectSeries(seriesType: SeriesTypes.Column)

        scale = { [weak self] in
            let animator = SCIAnimations.createScaleAnimator(for: self!.renderableSeries!)
            self?.animate(animator: animator)
        }
        wave = { [weak self] in
            let animator = SCIAnimations.createWaveAnimator(for: self!.renderableSeries!)
            self?.animate(animator: animator)
        }
        sweep = { [weak self] in
            let animator = SCIAnimations.createSweepAnimator(for: self!.renderableSeries!)
            self?.animate(animator: animator)
        }
        translateX = { [weak self] in
            let animator = SCIAnimations.createTranslateXAnimator(for: self!.renderableSeries!, withOffset: -AnimationSandboxView.offset)
            self?.animate(animator: animator)
        }
        translateY = { [weak self] in
            let animator = SCIAnimations.createTranslateYAnimator(for: self!.renderableSeries!, withOffset: -AnimationSandboxView.offset)
            self?.animate(animator: animator)
        }
    }
    
    fileprivate func animate(animator: SCIValueAnimator?) {
        animator?.easingFunction = easingFunction
        animator?.cancel()
        animator?.start(withDuration: 2.0)
    }
    
    override func initExample() {
        let xAxis = SCINumericAxis()
        xAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        xAxis.autoRange = .always
        let yAxis = SCINumericAxis()
        yAxis.growBy = SCIDoubleRange(min: 0.1, max: 0.1)
        yAxis.autoRange = .always
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.xAxes.add(xAxis)
            self.surface.yAxes.add(yAxis)
            self.surface.renderableSeries.add(self.initXySeries(series: SCIFastColumnRenderableSeries()))
        }
    }
    
    fileprivate func selectSeries(seriesType: SeriesTypes) {
        let rSeries: ISCIRenderableSeries
        switch seriesType {
        case SeriesTypes.Column:
            rSeries = initXySeries(series: SCIFastColumnRenderableSeries())
            break;
        case SeriesTypes.Line:
            rSeries = initXySeries(series: SCIFastLineRenderableSeries())
            break
        case SeriesTypes.Impulse:
            let series = SCIFastImpulseRenderableSeries()
            series.pointMarker = SCIEllipsePointMarker()
            series.pointMarker?.size = CGSize(width: 10, height: 10)
            series.pointMarker?.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, thickness: 1.0)
            series.pointMarker?.fillStyle = SCISolidBrushStyle(colorCode: 0xFF4682B4)
            series.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, thickness: 1.0)
            rSeries = initXySeries(series: series)
            break
        case SeriesTypes.Mountain:
            rSeries = initXySeries(series: SCIFastMountainRenderableSeries())
            break
        case SeriesTypes.XyScatter:
            let series = SCIXyScatterRenderableSeries()
            series.pointMarker = SCIEllipsePointMarker()
            series.pointMarker?.size = CGSize(width: 10, height: 10)
            series.pointMarker?.strokeStyle = SCISolidPenStyle(colorCode: 0xFF4682B4, thickness: 1.0)
            series.pointMarker?.fillStyle = SCISolidBrushStyle(colorCode: 0xFF4682B4)
            rSeries = initXySeries(series: series)
            break
        case SeriesTypes.ErrorBars:
            rSeries = initHlSeries(series: SCIFastErrorBarsRenderableSeries())
            break
        case SeriesTypes.FixedErrorBars:
            rSeries = initFixedErrorBars(series: SCIFastFixedErrorBarsRenderableSeries())
            break
        case SeriesTypes.Bubble:
            let series = SCIFastBubbleRenderableSeries()
            series.autoZRange = false
            series.zScaleFactor = 25
            rSeries = initXyzSeries(series: series)
            break
        case .Band:
            rSeries = initXyySeries(series: SCIFastBandRenderableSeries())
            break
        case .Ohlc:
            rSeries = initOhlcSeries(series: SCIFastOhlcRenderableSeries())
            break
        case .Candlestick:
            rSeries = initOhlcSeries(series: SCIFastCandlestickRenderableSeries())
            break
        case SeriesTypes.SplineLine:
            rSeries = initXySeries(series: SCISplineLineRenderableSeries())
            break
        case SeriesTypes.SplineMountain:
            rSeries = initXySeries(series: SCISplineMountainRenderableSeries())
            break
        case .SplineBand:
            rSeries = initXyySeries(series: SCISplineBandRenderableSeries())
            break
        }
        
        SCIUpdateSuspender.usingWith(surface) {
            self.surface.renderableSeries.remove(at: 0)
            self.surface.renderableSeries.add(rSeries)
        }
        renderableSeries = rSeries
    }
    
    fileprivate func initXySeries(series: SCIXyRenderableSeriesBase) -> ISCIRenderableSeries {
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        
        let randomWalk = getRandomWalk(valueShift: 0.0)
        for i in 0 ..< AnimationSandboxView.pointsCount {
            dataSeries.append(x: i, y: randomWalk[i])
        }
        
        series.dataSeries = dataSeries
        return series;
    }
    
    fileprivate func initXyySeries(series: SCIXyyRenderableSeriesBase) -> ISCIRenderableSeries {
        let dataSeries = SCIXyyDataSeries(xType: .double, yType: .double)
        
        let randomWalkY = getRandomWalk(valueShift: 1.0)
        let randomWalkY1 = getRandomWalk(valueShift: -1.0)
        for i in 0 ..< AnimationSandboxView.pointsCount {
            dataSeries.append(x: i, y: randomWalkY[i], y1: randomWalkY1[i])
        }
        
        series.dataSeries = dataSeries
        return series;
    }
    
    fileprivate func initXyzSeries(series: SCIXyzRenderableSeriesBase) -> ISCIRenderableSeries {
        let dataSeries = SCIXyzDataSeries(xType: .double, yType: .double, zType: .double)
        
        let randomWalkY = getRandomWalk(valueShift: 0.0)
        let randomWalkZ = getRandomWalk(valueShift: 0.0)
        for i in 0 ..< AnimationSandboxView.pointsCount {
            dataSeries.append(x: i, y: randomWalkY[i], z: randomWalkZ[i])
        }
        
        series.dataSeries = dataSeries
        return series;
    }
    
    fileprivate func initFixedErrorBars(series: SCIFastFixedErrorBarsRenderableSeries) -> ISCIRenderableSeries {
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        
        let randomWalk = getRandomWalk(valueShift: 0.0)
        for i in 0 ..< AnimationSandboxView.pointsCount {
            dataSeries.append(x: i, y: randomWalk[i])
        }
        
        series.dataSeries = dataSeries
        return series;
    }

    fileprivate func initHlSeries(series: SCIHlRenderableSeriesBase) -> ISCIRenderableSeries {
        let dataSeries = SCIHlDataSeries(xType: .double, yType: .double)
        
        let randomWalk = getRandomWalk(valueShift: 0.0)
        for i in 0 ..< AnimationSandboxView.pointsCount {
            dataSeries.append(x: i, y: randomWalk[i], high: randomWalk[i] + randf(0, 1) + 0.5, low: randomWalk[i] + randf(0, 1) - 0.5)
        }
        
        series.dataSeries = dataSeries
        return series;
    }
    
    fileprivate func initOhlcSeries(series: SCIOhlcRenderableSeriesBase) -> ISCIRenderableSeries {
        let dataSeries = SCIOhlcDataSeries(xType: .double, yType: .double)
        
        let randomWalk = getRandomWalk(valueShift: 0.0)
        for i in 0 ..< AnimationSandboxView.pointsCount {
            dataSeries.append(x: i, open: randomWalk[i] + randf(0, 1), high: randomWalk[i] + randf(0, 1) + 0.5, low: randomWalk[i] + randf(0, 1) - 0.5, close: randomWalk[i] + randf(0, 1))
        }
        
        series.dataSeries = dataSeries
        return series;
    }
    
    fileprivate func getRandomWalk(valueShift: Double) -> [Double] {
        var randomWalk = 1.0
        var yBuffer = Array<Double>(repeating: 0, count: AnimationSandboxView.pointsCount)

        for i in 0 ..< AnimationSandboxView.pointsCount {
            randomWalk += randf(0, 1) - 0.498
            yBuffer[i] = randomWalk + valueShift;
        }
    
        return yBuffer
    }
    
    // MARK: - UIPickedView - Delegate and DataSource
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? EasingFunctions.allCases.count : SeriesTypes.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return component == 0 ? EasingFunctions.allCases[row].rawValue : SeriesTypes.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0) {
            self.easingFunction = EasingFunctions.allCases[row].getFunction()
        } else {
            let selectedType = SeriesTypes.allCases[row]
            selectSeriesTextField.text = selectedType.rawValue
            selectSeries(seriesType: selectedType)
        }
        self.view.endEditing(true)
    }
}
