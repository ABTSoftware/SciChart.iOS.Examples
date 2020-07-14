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

final class SparkLinesCollectionView: UICollectionView {
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
