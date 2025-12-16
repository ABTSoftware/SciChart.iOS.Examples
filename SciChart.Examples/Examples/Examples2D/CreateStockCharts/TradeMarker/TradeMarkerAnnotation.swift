//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2025. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// TradeMarkerAnnotation.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

protocol TradeAnnotationDelegate: AnyObject {
    func didTradeAnnotationTapped(_ annotation: TradeMarkerAnnotation, atPoint: CGPoint)
}

class TradeMarkerAnnotation: SCICustomAnnotation {
    
    weak var delegate: TradeAnnotationDelegate?
    var userInfo: [Any]?
    var hasLabel: Bool = false
    
    init(index: Date, isBuy: Bool, yPoint: Double, price: Double) {
        super.init()
        self.set(x1: index)
        self.set(y1: yPoint)
        self.verticalAnchorPoint = isBuy ? .top : .bottom
        self.horizontalAnchorPoint = .center
        let imgArrow = SCIImageView(frame: CGRect(x: 0, y: 0, width: 15, height: 15))
        imgArrow.image = isBuy ? SCIImage(named: "image.arrow.green") : SCIImage(named: "image.arrow.red")
#if os(macOS)
        imgArrow.wantsLayer = true
        imgArrow.imageScaling = .scaleProportionallyUpOrDown
#else
        imgArrow.contentMode = .scaleAspectFit
        
#endif
        self.userInfo = [["isBuy": isBuy, "price": price]]
        self.isEditable = true
        
        self.customView = imgArrow
    }
    
    override func onEvent(_ args: SCIGestureModifierEventArgs) {
        
        let hitPoint = ToPointRelativeToBounds(args.location, self.annotationCoordinates.annotationsSurfaceBounds)
        if self.isPoint(withinBounds: hitPoint) {
            delegate?.didTradeAnnotationTapped(self, atPoint: hitPoint)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
