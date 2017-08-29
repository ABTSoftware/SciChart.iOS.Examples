//
//  TraderAnnotationFactory.swift
//  SciChartShowcaseDemo
//
//  Created by Gkol on 8/21/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

extension SCIAnnotationCreationType {
    public static let upArrowAnnotationType: SCIAnnotationCreationType = SCIAnnotationCreationType("upArrowAnnotationType")
    public static let downArrowAnnotationType: SCIAnnotationCreationType = SCIAnnotationCreationType("downArrowAnnotationType")
    public static let customTextAnnotationType: SCIAnnotationCreationType = SCIAnnotationCreationType("customTextAnnotationType")
}

class TraderAnnotationFactory : SCICreationAnnotationFactory {
    
    override public func createAnnotation(forType annotationType: SCIAnnotationCreationType) -> SCIAnnotationProtocol? {
        
        let annotation = super.createAnnotation(forType: annotationType)
        
        if annotationType == .upArrowAnnotationType {
            let upAnnotation = SCICustomAnnotation()
            upAnnotation.customView = UIImageView(image: UIImage.imageNamedUpArrow())
            return upAnnotation
        }
        
        if annotationType == .downArrowAnnotationType {
            let downAnnotation = SCICustomAnnotation()
            downAnnotation.customView = UIImageView(image: UIImage.imageNamedDownArrow())
            return downAnnotation
        }
        
        if annotationType == .customTextAnnotationType {
            let textAnnotation = TextAnnotation()
            return textAnnotation
        }
        
        return annotation
        
    }
    
}
