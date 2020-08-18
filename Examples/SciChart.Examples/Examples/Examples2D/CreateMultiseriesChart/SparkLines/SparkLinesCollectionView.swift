//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SparkLinesCollectionView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

final class SparkLinesCollectionView: SCICollectionView {
    #if os(OSX)
    private lazy var scrollView: NSScrollView = {        
        return NSScrollView()
    }()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        scrollView.documentView = self
        self.collectionViewLayout = SCICollectionViewFlowLayout()
    }
    
    #elseif os(iOS)
    
    init() {
        super.init(frame: .zero, collectionViewLayout: SCICollectionViewFlowLayout())
    }
    
    #endif
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commonInit() {
        if let layout = self.collectionViewLayout as? SCICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
    }
}
