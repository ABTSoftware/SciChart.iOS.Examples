//
//  SCSCustomModifierView.swift
//  SciChartSwiftDemo
//
//  Created by Admin on 9/20/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

import UIKit
import SciChart

class CustomModifier : SCIGestureModifier {
    // marker to be displayed
    var _marker : SCIEllipsePointMarker! = nil
    
    // position of tap gesture
    var _location : CGPoint = CGPoint.zero
    
    // if marker should be visible
    var _visible : Bool = false
    
    // x data value at point marker
    var _xValue : Double = 0
    
    // y data value at point marker
    var _yValue : Double = 0
    
    // index of data point at point marker position
    var _index : Int32 = 0
    
    // renderable series to whicj point marker is bound
    var _rSeries : SCIRenderableSeriesProtocol?
    
    // control panel for additional actions with modifier
    weak var _controlPanel : CustomModifierControlPanel?
    
    
    init(controlPanel : CustomModifierControlPanel) {
        super.init()
        
        initializeControlPanel(controlPanel)
        initializePointMarker()
    }
    
    func initializeControlPanel(_ controlPanel : CustomModifierControlPanel){
        _controlPanel = controlPanel
        
        weak var wSelf = self
        _controlPanel?.onClearClicked = { () -> Void in wSelf!.hideMarker() }
        _controlPanel?.onNextClicked = { () -> Void in  wSelf!.moveMarker(+1) }
        _controlPanel?.onPrevClicked = { () -> Void in wSelf!.moveMarker(-1) }
        
    }
    
    func initializePointMarker(){
        _marker = SCIEllipsePointMarker()
        _marker.fillStyle = SCISolidBrushStyle(color: UIColor.red )
        _marker.strokeStyle = nil;
    }
    
    func moveMarker (_ index: Int) {
        if (!_visible) {
            return
        }
        
        let context = parentSurface.renderSurface?.modifierContext();
        let dataSeries : SCIDataSeriesProtocol = _rSeries!.currentRenderPassData.dataSeries()
        
        // check if index is out of data series range
        _index = _index + Int32(index);
        let indexOutOfRange = _index < 0 || Int32(_index) >= dataSeries.count()
        
        if (indexOutOfRange) {
            _visible = false
            context?.invalidate()
            return
        }
        
        // get data values from data series for new index
        _xValue = SCIGenericDouble(dataSeries.xValues().value(at: _index))
        _yValue = SCIGenericDouble(dataSeries.yValues().value(at: _index))
        
        if (_xValue.isNaN || _yValue.isNaN) {
            _visible = false
            context?.invalidate()
            return;
        }
        // trigger modifier context to redraw
        context?.invalidate()
    }
    
    func hideMarker () {
        _visible = false;
        // modifier context should be invalidated to trigger modifier redraw
        let parent : SCIChartSurfaceProtocol = self.parentSurface
        let context : SCIRenderContext2DProtocol = parent.renderSurface!.modifierContext()
        context.invalidate()
    }
    
    func preapareDataForDrawing () {
        _visible = false
        
        let series = parentSurface.renderableSeries
        
        // gesture coordinates is connected to whole surface, but calculators get coordinates related to chart surface only
        // we need to get location on chart surface
        let actualLocation : CGPoint = parentSurface.renderSurface!.point(inChartFrame: _location)
        
        // check every renderable series for hit
        for  i in 0 ..< series.count() {
            let rSeries : SCIRenderableSeriesProtocol! = series.item(at: UInt32(i))
            let data = rSeries.currentRenderPassData
            
            // get hit test tools
            if let hitTest = rSeries.hitTestProvider() {
                // hit test verticaly: check if vertical projection through touch location crosses chart
                let hitTestResult = hitTest.hitTestVerticalAt(x: Double(actualLocation.x),
                                                              y: Double(actualLocation.y),
                                                              radius: 5,
                                                              onData: data)
                
                if (hitTestResult.match).boolValue {
                    // if hit is registered on series
                    // get values at closest point to hit test position
                    _xValue = SCIGenericDouble(hitTestResult.xValue)
                    _yValue = SCIGenericDouble(hitTestResult.yValue)
                    _index = hitTestResult.index
                    
                    if (_xValue.isNaN || _yValue.isNaN) {
                        continue
                    }
                    
                    _visible = true
                    _rSeries = rSeries // will be used during drawing
                    break
                }
            }
        }
        
    }
    
    override func onTapGesture (_ gesture: UITapGestureRecognizer!, at view: UIView!) -> Bool {
        
        let location = gesture.location(in: view)
        let rs = self.parentSurface.renderSurface
        
        if (!(rs?.isPoint(withinBounds: location))!) {
            return false
        }
        
        if (gesture.state == .ended) {
            // save location of touch
            _location = location;
            preapareDataForDrawing()
            
            // invalidate modifier context to trigger redrawing of modifier
            let context = parentSurface.renderSurface?.modifierContext()
            context?.invalidate()
        }
        return true
    }
    
    override func draw () {
        if (!_visible) { return }
        let parent : SCIChartSurfaceProtocol = self.parentSurface
        let surface : SCIRenderSurfaceProtocol = parent.renderSurface!
        let context : SCIRenderContext2DProtocol = surface.modifierContext()
        
        let area : CGRect = surface.chartFrame()
        context.setDrawingArea(area) // context needs proper area for drawing (in that case it is chart area)
        
        // get coordinate calculators and calculate coordinates on screen for data point
        let data : SCIRenderPassDataProtocol = _rSeries!.currentRenderPassData
        let xCalc : SCICoordinateCalculatorProtocol = data.xCoordinateCalculator()
        let yCalc : SCICoordinateCalculatorProtocol = data.yCoordinateCalculator()
        let xCoord : Double = xCalc.getCoordinateFrom(_xValue)
        let yCoord : Double = yCalc.getCoordinateFrom(_yValue)
        
        // draw point marker
        _marker.draw(toContext: context, atX: Float(xCoord), y: Float(yCoord))
        context.drawLine(withBrush: SCIPenSolid(colorCode: 0xFF995499, width: 0.9), fromX: Float(xCoord), y: Float(yCoord), toX: Float(xCoord), y: Float(area.height))
        // update control panel text
        let panelText = String(format: "Index: %d X:%g Y:%g", _index, _xValue, _yValue)
        _controlPanel?.setText(panelText)

    }
}

class CustomAnnotation : SCIAnnotationBase {
    var _label: UILabel!
    var _xValue : Double = 10   // x data value
    var _yValue : Double = 5   // y data value
    
    override init() {
        super.init()
        _label = UILabel()
        _label.text = "Text"
        _label.font = UIFont(name: "Helvetica", size: 20)
        _label.textColor = UIColor.cyan
        _label.backgroundColor = UIColor.lightGray
        _label.sizeToFit()
    }
    
    override func draw () {
        let parent : SCIChartSurfaceProtocol = self.parentSurface
        if let viewParent = parent as? UIView {
            viewParent.addSubview(_label)
        }
        
        // get tools that converts data value to coordinates on chart surface
        // for NSDate value is time interval since 1970
        let xCoordTool = self.xAxis().getCurrentCoordinateCalculator()
        let yCoordTool = self.yAxis().getCurrentCoordinateCalculator()
        // get coordinate from values
        let xCoord : CGFloat = CGFloat( xCoordTool!.getCoordinateFrom(_xValue) )
        let yCoord : CGFloat = CGFloat( yCoordTool!.getCoordinateFrom(_yValue) )
        
        // Chart surface is not a view, it is an area on OpenGL layer
        // UIView should be added to top level view (SCIChartSurfaceView) so coordinates in chart surface should be transformed to coordinates in SCIChartSurfaceView
        let chartFrame = parent.renderSurface?.chartFrame()
        let pointInSurface = CGPoint(x: xCoord + (chartFrame?.origin.x)!, y: yCoord + (chartFrame?.origin.y)!)
        _label.frame.origin = pointInSurface
    }
}

class SCSCustomModifierView: UIView {
    var _label: UILabel!
    let sciChartView = SCIChartSurface()
    var _controlPanel : CustomModifierControlPanel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        completeConfiguration()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        completeConfiguration()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        completeConfiguration()
    }
    
    // MARK: Private Functions
    func completeConfiguration() {

        configureChartSuraface()
        addAxis()
        addDefaultModifiers()
        addSeries()
    }
    
    
    fileprivate func addPanel() {
        let panel = Bundle.main.loadNibNamed("CustomModifierControlPanel",
                                             owner: self,
                                             options: nil)!.first
        
        if let panelValid = panel as? CustomModifierControlPanel {
            
            _controlPanel = panelValid
            
            _controlPanel?.translatesAutoresizingMaskIntoConstraints = false
            
            addSubview(_controlPanel!)
        }
    }
    
    fileprivate func addAxis() {
        sciChartView.xAxes.add(SCINumericAxis())
        sciChartView.yAxes.add(SCINumericAxis())
    }
    
    fileprivate func configureChartSuraface() {
        
        sciChartView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(sciChartView)
        
        addPanel()
        let layoutDictionary = ["SciChart" : sciChartView, "Panel" : _controlPanel!] as [String : Any]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[Panel(43)]-(0)-[SciChart]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[SciChart]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(0)-[Panel]-(0)-|",
                                                           options: NSLayoutFormatOptions(),
                                                           metrics: nil,
                                                           views: layoutDictionary))
    }
    
    fileprivate func addSeries() {
        let dataSeries = SCIXyDataSeries(xType: .float, yType: .float)
        
        let dataCount = 200
        for i in 0..<dataCount {
            let time = 10 * Double(i) / Double(dataCount)
            let x = time
            let y = arc4random_uniform(20);
            dataSeries.appendX(SCIGeneric(x), y: SCIGeneric(y))
        }
        dataSeries.dataDistributionCalculator = SCIUserDefinedDistributionCalculator()
        
        let renderSeries = SCIFastLineRenderableSeries()
        renderSeries.dataSeries = dataSeries
        renderSeries.strokeStyle = SCISolidPenStyle(colorCode: 0xFF99EE99, withThickness: 0.7)
        sciChartView.renderableSeries.add(renderSeries)

    }
    
    func addDefaultModifiers() {
        
        let xAxisDragmodifier = SCIXAxisDragModifier()
        xAxisDragmodifier.dragMode = .scale
        xAxisDragmodifier.clipModeX = .none
        
        let yAxisDragmodifier = SCIYAxisDragModifier()
        yAxisDragmodifier.dragMode = .pan
        
        let extendZoomModifier = SCIZoomExtentsModifier()
        
        let pinchZoomModifier = SCIPinchZoomModifier()
        
        let customModifier = CustomModifier(controlPanel: _controlPanel!)
        
        let groupModifier = SCIChartModifierCollection(childModifiers: [xAxisDragmodifier, yAxisDragmodifier, pinchZoomModifier, extendZoomModifier, customModifier])
        
        sciChartView.chartModifiers = groupModifier

    }
    
}
