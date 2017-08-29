//
//  TextAnnotation.swift
//  SciChartShowcaseDemo
//
//  Created by Gkol on 8/21/17.
//  Copyright © 2017 SciChart Ltd. All rights reserved.
//

import Foundation
import SciChart

class TextAnnotation: SCITextAnnotation {
    
    var keyboardEventHandler : ((NSNotification, UITextView) -> ())?
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardNotification(_ sender: NSNotification) {
        if let handler = keyboardEventHandler {
            if textView.isFirstResponder {
                handler(sender, textView)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func p_SCI_clipTextView() {
        
    }
    
}
