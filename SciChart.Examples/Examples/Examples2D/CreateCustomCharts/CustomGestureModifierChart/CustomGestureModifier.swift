//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// CustomGestureModifier.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import SciChart.Protected.SCIGestureModifierBase

class CustomGestureModifier: SCIGestureModifierBase {
    private var initialLocation = CGPoint.zero
    private let scaleFactor: CGFloat = -50
    private var canPan = true
    
    #if os(iOS)
    private lazy var doubleTapGesture: DoubleTouchDownGestureRecognizer = {
        let gesture = DoubleTouchDownGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture))
        
        return gesture
    }()
    
    override func attach(to services: ISCIServiceContainer) {
        super.attach(to: services)
        
        if let parentSurface = self.parentSurface as? SCIView {
            parentSurface.addGestureRecognizer(doubleTapGesture)
        }
        
        canPan = false
    }
    
    @objc private func handleDoubleTapGesture(_ gesture: DoubleTouchDownGestureRecognizer) {
        canPan = true
    }
    
    override func onGestureEnded(with args: SCIGestureModifierEventArgs) {
        canPan = false
    }
    
    override func onGestureCancelled(with args: SCIGestureModifierEventArgs) {
        canPan = false
    }
    #endif
    
    override func onGestureBegan(with args: SCIGestureModifierEventArgs) {
        guard canPan else { return }
        guard let gesture = args.gestureRecognizer as? SCIPanGestureRecognizer else { return }
        let parentView = self.parentSurface?.modifierSurface.view
        
        initialLocation = gesture.location(in: parentView)
    }
    
    override func onGestureChanged(with args: SCIGestureModifierEventArgs) {
        guard canPan else { return }
        guard let gesture = args.gestureRecognizer as? SCIPanGestureRecognizer else { return }
        let parentView = self.parentSurface?.modifierSurface.view
        
        let translationY = gesture.translation(in: parentView).y
        performZoom(point: initialLocation, yScaleFactor: translationY)
        gesture.setTranslation(.zero, in: parentView)
    }
    
    override func createGestureRecognizer() -> SCIGestureRecognizer {
        return SCIPanGestureRecognizer()
    }
    
    private func performZoom(point: CGPoint, yScaleFactor:CGFloat) {
        let fraction = yScaleFactor / scaleFactor
        for i in 0 ..< self.xAxes.count {
            growAxis(self.xAxes[i], at: point, by: fraction)
        }
    }
    
    private func growAxis(_ axis: ISCIAxis, at point: CGPoint, by fraction: CGFloat) {
        let width = axis.layoutSize.width
        let coord = width - point.x
        
        let minFraction = (coord / width) * fraction
        let maxFraction = (1 - coord / width) * fraction
        
        axis.zoom(byFractionMin: minFraction, max: maxFraction)
    }
}
