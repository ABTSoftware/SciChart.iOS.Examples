//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2019. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// RenderSurfaceSandboxView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import UIKit

class RenderSurfaceSandboxView: RenderSurfaceSandboxLayout {
    let bitmapSize = CGSize(width: 100, height: 200)
    var bitmap: SCIBitmap!
    
    weak var renderSurface: (UIView & ISCIRenderSurface)?
    var renderSurfaceRenderer: TestRenderSurfaceRenderer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = UIColor.black
    }
    
    override func layoutSubviews() {
        let frame = renderSurfacePlaceholder.frame
        
        self.xSlider.minimumValue = Float(-frame.width) / 2
        self.xSlider.maximumValue = Float(frame.width) / 2
        self.ySlider.minimumValue = Float(-frame.height) / 2
        self.ySlider.maximumValue = Float(frame.height) / 2
        
        renderSurfaceRenderer?.frameSize = frame.size
        
        invalidateRenderSurface()
    }
    
    override func initExample() {
        bitmap = SCIBitmap(size: bitmapSize)
        
        bitmap.context.setFillColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        bitmap.context.setStrokeColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        bitmap.context.fill(CGRect(x: 0.0, y: 0.0, width: bitmapSize.width, height: bitmapSize.height))
        
        bitmap.context.setFillColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        bitmap.context.setStrokeColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let offset = bitmapSize.width / 4
        bitmap.context.fill(CGRect(x: offset, y: offset, width: bitmapSize.width - offset * 2, height: bitmapSize.height - offset * 2))
        
        renderSurfaceRenderer = TestRenderSurfaceRenderer(bitmap: bitmap)
        createAndSetRenderSurface(index: 1)
        
        sliderValueChanged = { [weak self] _ in
            self?.invalidateRenderSurface()
        }
        
        renderSurfaceChanged = { [weak self] in
            let selectedIndex = ($0 as! UISegmentedControl).selectedSegmentIndex
            self?.createAndSetRenderSurface(index: selectedIndex)
        }
    }
    
    fileprivate func removeOldRenderSurfaceIfNeeded() {
        if (renderSurface != nil) {
            renderSurface?.renderer = nil
            renderSurface?.view.removeFromSuperview()
        }
    }
    
    fileprivate func configureNewRenderSurface() {
        renderSurface?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        if (renderSurface != nil) {
            renderSurface?.translatesAutoresizingMaskIntoConstraints = false
            renderSurface?.isUserInteractionEnabled = false
            renderSurface?.view.frame = CGRect(origin: .zero, size: renderSurfacePlaceholder.frame.size)
            renderSurfacePlaceholder.addSubview(renderSurface!.view)
            
            renderSurface!.renderer = renderSurfaceRenderer
        }
    }
    
    fileprivate func createRenderSurfaceOfType(_ index: Int) {
        renderSurface = index == 0 ? SCIOpenGLRenderSurface() : SCIMetalRenderSurface()
    }
    
    fileprivate func createAndSetRenderSurface(index: Int) {
        removeOldRenderSurfaceIfNeeded()
        //Workaround to avoid singltone - assert
        //Delay added to make sure the ENGINE will be destroyed before new render surface creation
        DispatchQueue.main.asyncAfter(deadline: .now()) { [weak self] in
            self?.createRenderSurfaceOfType(index)
            self?.configureNewRenderSurface()
            self?.invalidateRenderSurface()
        }
    }
    
    fileprivate func invalidateRenderSurface() {
        guard renderSurface != nil else {
            return;
        }
        renderSurfaceRenderer?.dx = xSlider.value
        renderSurfaceRenderer?.dy = ySlider.value
        renderSurfaceRenderer?.degrees = alphaSlider.value
        renderSurfaceRenderer?.opacity = opacitySlider.value
        renderSurfaceRenderer?.scale = scaleSlider.value
        renderSurface?.invalidateElement()
    }
}
