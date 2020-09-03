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

/*
import SciChart.Protected.SCIGestureModifierBase

class CustomGestureModifier: SCIGestureModifierBase {
    private var initialLocation = CGPoint.zero
    private let scaleFactor: CGFloat = -50
    private var canPan = false
    
    private lazy var longPressGesture: DoubleTouchDownGestureRecognizer = {
        let gesture = DoubleTouchDownGestureRecognizer(target: self, action: #selector(handleDoubleTapGesture))
        gesture.numberOfTapsRequired = 2
        
        return gesture
    }()
    
    override func attach(to services: ISCIServiceContainer!) {
        super.attach(to: services)
        
        if let parentSurface = self.parentSurface as? UIView {
            parentSurface.addGestureRecognizer(longPressGesture)
        }
    }
        
    override func createGestureRecognizer() -> UIGestureRecognizer {
        return UIPanGestureRecognizer()
    }
    
    override func internalHandleGesture(_ gestureRecognizer: UIGestureRecognizer) {
        guard canPan else { return }
        
        guard let gesture = gestureRecognizer as? UIPanGestureRecognizer else { return }
        let parentView = self.parentSurface.modifierSurface.view
        
        switch gesture.state {
        case .began:
            initialLocation = gestureRecognizer.location(in: parentView)
        case .changed:
            let translationY = gesture.translation(in: parentView).y
            performZoom(point: initialLocation, yScaleFactor: translationY)
            
            gesture.setTranslation(.zero, in: parentView)
        default:
            canPan = false
        }
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
        
        axis.zoom(byFractionMin: Double(minFraction), max: Double(maxFraction))
    }
    
    @objc private func handleDoubleTapGesture(_ gesture: UILongPressGestureRecognizer) {
        canPan = true
    }
}

*/
