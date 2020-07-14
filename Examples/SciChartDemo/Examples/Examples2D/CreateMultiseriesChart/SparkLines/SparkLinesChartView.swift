//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SparkLinesChartView.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

import Foundation

class SparkLinesChartView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private let SparkLinesItemReuseIdentifier = "SparkLinesItemReuseIdentifier"
    private let itemsCount = 100
    private var dataSet = [SparkLineItemModel]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initExample()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    private func initExample() {
        for i in 0..<itemsCount {
            dataSet.append(getRandomItem(index: i, pointCount: 50))
        }
        
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func getRandomItem(index: Int, pointCount: Int) -> SparkLineItemModel {
        let dataSeries = SCIXyDataSeries(xType: .double, yType: .double)
        // Generate a slightly positive biased random walk
        // y[i] = y[i-1] + random,
        // where random is in the range -0.5, +0.5
        let arc4randomMax = 0x100000000
        var last: Double = 0
        for i in 0..<pointCount {
            let nextDouble = ((Double)(arc4random()) / Double(arc4randomMax))
            let next = last + (nextDouble - 0.5 + 0.01)
            last = next
            dataSeries.append(x: Double(i), y: next)
        }
        
        return SparkLineItemModel(dataSeries: dataSeries, itemName: "Item #\(index)")
    }
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = SparkLinesCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SparkLinesCollectionViewItem.self, forCellWithReuseIdentifier: SparkLinesItemReuseIdentifier)
        
        return collectionView
    }()
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SparkLinesItemReuseIdentifier, for: indexPath) as? SparkLinesCollectionViewItem else { fatalError() }
        item.configure(with: dataSet[indexPath.item])
        
        return item
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSet.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
