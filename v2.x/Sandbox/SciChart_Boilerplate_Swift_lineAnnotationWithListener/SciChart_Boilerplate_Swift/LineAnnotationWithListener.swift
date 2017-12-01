//
//  LineAnnotationWithListener.swift
//  SciChart_Boilerplate_Swift
//
//  Created by Admin on 04/07/2017.
//  Copyright © 2017 SciChart. All rights reserved.
//

import Foundation
import UIKit
import SciChart

class LineAnnotationWithListener : SCILineAnnotation {
    var lastX1 : SCIGenericType
    var lastX2 : SCIGenericType
    var lastY1 : SCIGenericType
    var lastY2 : SCIGenericType
    
    override init() {
        lastX1 = SCIGeneric(0)
        lastX2 = SCIGeneric(0)
        lastY1 = SCIGeneric(0)
        lastY2 = SCIGeneric(0)
    }
    
    override func onPanGesture(_ gesture: UIPanGestureRecognizer!, at view: UIView!) -> Bool {
        let state = super.onPanGesture(gesture, at: view)
        
        if (gesture.state == .began) {
            lastX1 = self.x1
            lastX2 = self.x2
            lastY1 = self.y1
            lastY2 = self.y2
        }
        if (gesture.state == .ended) {
            if ((SCIGenericDouble(lastX1) != SCIGenericDouble(self.x1)) ||
                (SCIGenericDouble(lastX2) != SCIGenericDouble(self.x2)) ||
                (SCIGenericDouble(lastY1) != SCIGenericDouble(self.y1)) ||
                (SCIGenericDouble(lastY2) != SCIGenericDouble(self.y2)))
            {
                NSLog("Event");
            }
        }
        
        return state
    }
}
