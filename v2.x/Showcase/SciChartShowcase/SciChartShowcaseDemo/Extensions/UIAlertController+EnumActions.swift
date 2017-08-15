//
//  UIAlertController+EnumActions.swift
//  SciChartShowcaseDemo
//
//  Created by Hrybeniuk Mykola on 7/28/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation

extension UIAlertController {
    
    func fillActions<T: CustomStringConvertible>(actions: [T], didSelectedHanlder:@escaping (_ action: T?) -> ()) -> UIAlertController {
        
        for actionType in actions {
            addAction(UIAlertAction(title: actionType.description, style: .default, handler: { (alertAction) in
                didSelectedHanlder(actionType)
            }))
        }
        addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return self
    }
    
}
