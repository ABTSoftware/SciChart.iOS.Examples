//
//  CustomLineAnnotation.swift
//  SciChart_Boilerplate_Swift
//
//  Created by Admin on 25/08/2017.
//  Copyright © 2017 SciChart. All rights reserved.
//

import Foundation
import SciChart

typealias LineMovedCallback = (_ moved : Bool, _ x1 : SCIGenericType, _ y1: SCIGenericType, _ x2 : SCIGenericType, _ y2 : SCIGenericType ) -> Void;

class CustomLineAnnotation : SCILineAnnotation {
    var lastX1 : SCIGenericType = SCIGeneric(Double.nan);
    var lastX2 : SCIGenericType = SCIGeneric(Double.nan);
    var lastY1 : SCIGenericType = SCIGeneric(Double.nan);
    var lastY2 : SCIGenericType = SCIGeneric(Double.nan);
    
    var lineMoved : LineMovedCallback?;
    
    override func draw() {
        super.draw();
        let moved : Bool = (SCIGenericCompare(lastX1, self.x1) != .equal)
            || (SCIGenericCompare(lastX2, self.x2) != .equal)
            || (SCIGenericCompare(lastY1, self.x1) != .equal)
            || (SCIGenericCompare(lastY2, self.y2) != .equal);
        if (lineMoved != nil) {
            lineMoved!(moved, self.x1, self.y1, self.x2, self.y2);
        }
        lastX1 = self.x1;
        lastX2 = self.x2;
        lastY1 = self.y1;
        lastY2 = self.y2;
    }
}
