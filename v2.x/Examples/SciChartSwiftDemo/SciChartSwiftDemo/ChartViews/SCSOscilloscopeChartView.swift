//
//  SCSOscilloscopeChartView.swift
//  SciChartSwiftDemo
//
//  Created by Yaroslav Pelyukh on 4/19/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

enum DataSource {
    case Fourier
    case Lisajous
}

class SCSOscilloscopeChartView: SCSBaseChartView {
    var sciChartView :SCIChartSurfaceView!
    var surface: SCIChartSurface!
    
    var _isDigital = false
    var _dataSource: DataSource = .Fourier
    
    var _displayLink:CADisplayLink!
    
    var _phase0: Double = 0.0;
    var _phase1: Double = 0.0;
    var _phaseIncrement: Double = Double.pi * 0.1;
    
    var _dataSeries1: SCIXyDataSeries = SCIXyDataSeries.init(xType: .double, yType: .double, seriesType: .defaultType)
    var _dataSeries2: SCIXyDataSeries = SCIXyDataSeries.init(xType: .double, yType: .double, seriesType: .defaultType)
    
    let _renderSeries: SCIFastLineRenderableSeries = SCIFastLineRenderableSeries()
    
    var alertView: UIAlertController!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if(_displayLink == nil){
            _displayLink = CADisplayLink.init(target: self, selector: #selector(SCSOscilloscopeChartView.updateOscilloscopeData))
            _displayLink.add(to: RunLoop.main, forMode: .defaultRunLoopMode)
        } else {
            _displayLink.invalidate()
            _displayLink = nil;
        }
    }
    
    override func completeConfiguration() {
        _dataSeries1.acceptUnsortedData = true
        _dataSeries2.acceptUnsortedData = true
        
        weak var wSelf = self
        alertView = UIAlertController(title: "Data Source", message: "Select data source or make line digital", preferredStyle: .actionSheet)
        var action = UIAlertAction(title: "Fourier", style: .default, handler: {(action: UIAlertAction) -> Void in
            wSelf?._dataSource = .Fourier
        })
        alertView.addAction(action)
        action = UIAlertAction(title: "Lisajous", style: .default, handler: {(action: UIAlertAction) -> Void in
            wSelf?._dataSource = .Lisajous
        })
        alertView.addAction(action)
        action = UIAlertAction(title: "Make line digital", style: .default, handler: {(action: UIAlertAction) -> Void in
            wSelf?._isDigital = !(wSelf!._isDigital)
            wSelf?._renderSeries.style.isDigitalLine = wSelf!._isDigital
        })
        alertView.addAction(action)
        
        configureChartSurfaceViewsLayout()
        configureChartSurface()
    }
    
    // MARK: Private Functions
    
    func configureChartSurfaceViewsLayout() {
        
        //  Initializing top scichart view
        sciChartView = SCIChartSurfaceView()
        sciChartView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView)
        
        weak var wSelf = self
        let panel = (Bundle.main.loadNibNamed("OscilloscopeChartPanel", owner: self, options: nil)!.first! as! OscilloscopeChartPanel)
        panel.translatesAutoresizingMaskIntoConstraints = false
        
        //Subscribing to the control view events
        panel.rotateCallback = {(sender:UIButton?) -> Void in
            wSelf!.rotate(sender: nil)
        }
        panel.flipVerticallyCallback = {(sender:UIButton?) -> Void in
            wSelf!.flipVertically(sender: nil)
        }
        panel.flipHorizontallyCallback = {(sender:UIButton?) -> Void in
            wSelf!.flipHorizontally(sender: nil)
        }
        panel.changeSourceCallback = {(sender:UIButton?) -> Void in
            wSelf!.changeDataSource(sender: sender)
        }
        self.addSubview(panel)
        
        
        let layoutDictionary: [String : UIView] = ["Panel" : panel, "SciChart1" : sciChartView]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart1]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[Panel]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[Panel(42)]-(0)-[SciChart1]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
    }
    
    func rotate(sender:UIButton?){
        var xAlignment: Int = Int(surface.xAxes.item(at: 0).axisAlignment.rawValue)
        xAlignment+=1
        if (xAlignment > 4) {
            xAlignment = 1;
        }
        surface.xAxes.item(at: 0).axisAlignment = SCIAxisAlignment(rawValue: Int32(xAlignment))!
        
        var yAlignment: Int = Int(surface.yAxes.item(at: 0).axisAlignment.rawValue)
        yAlignment+=1
        if (yAlignment > 4) {
            yAlignment = 1;
        }
        surface.yAxes.item(at: 0).axisAlignment = SCIAxisAlignment(rawValue: Int32(yAlignment))!
    }
    
    func flipHorizontally(sender:UIButton?){
        let flip = surface.xAxes.item(at: 0).flipCoordinates
        surface.xAxes.item(at: 0).flipCoordinates = !flip
    }
    
    func flipVertically(sender:UIButton?){
        let flip = surface.yAxes.item(at: 0).flipCoordinates
        surface.yAxes.item(at: 0).flipCoordinates = !flip
    }
    
    func changeDataSource(sender:UIButton?){
        alertView.popoverPresentationController?.sourceRect = sender!.bounds;
        alertView.popoverPresentationController?.sourceView = sender!;
        let vc = getCurrentCV()
        vc.present(alertView, animated: true, completion: nil)
    }
    
    func getCurrentCV()->UIViewController{
        var topVC = UIApplication.shared.delegate?.window??.rootViewController!
        while ((topVC!.presentedViewController) != nil)
        {
            topVC = topVC!.presentedViewController;
        }
        return topVC!;
    }
    
    func configureChartSurface(){
        surface = SCIChartSurface.init(view: sciChartView)
        
        let xAxis = SCINumericAxis()
        xAxis.autoRange = .never
        xAxis.axisTitle = "Time (ms)"
        xAxis.visibleRange = SCIDoubleRange.init(min: SCIGeneric(2.5), max: SCIGeneric(4.5))
        surface.xAxes.add(xAxis)
        
        let yAxis = SCINumericAxis()
        yAxis.autoRange = .never
        yAxis.axisTitle = "Voltage (mV)"
        yAxis.visibleRange = SCIDoubleRange.init(min: SCIGeneric(-12.5), max: SCIGeneric(12.5))
        surface.yAxes.add(yAxis)
        
        surface.renderableSeries.add(_renderSeries)
    }
    
    func updateOscilloscopeData(displayLink:CADisplayLink){
        switch (_dataSource) {
        case .Lisajous:
            _dataSeries1.clear()
            SCSDataManager.getLissajousCurve(dataSeries: _dataSeries1, alpha: 0.12, beta: _phase1, delta: _phase0, count: 2500)
            _renderSeries.dataSeries = _dataSeries1
            break;
        case .Fourier:
            _dataSeries2.clear()
            SCSDataManager.setFourierDataInto(_dataSeries2, amplitude: 2.0, phaseShift: _phase0, count: 1000)
            _renderSeries.dataSeries = _dataSeries2
            break;
        }
        _phase0 += _phaseIncrement;
        _phase1 += _phaseIncrement * 0.005;
    }
    
}
