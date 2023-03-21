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

class SparkLinesChartView: SCDExampleBaseViewController, SCICollectionViewDataSource, SCICollectionViewDelegateFlowLayout {
    
    private let SparkLinesItemReuseIdentifier = "SparkLinesItemReuseIdentifier"
    private let itemsCount = 100
    private var dataSet = [SparkLineItemModel]()
    
    private lazy var collectionView: SCICollectionView = {
        let collectionView = SparkLinesCollectionView()
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SparkLinesCollectionViewItem.self, forCellWithReuseIdentifier: SparkLinesItemReuseIdentifier)
        collectionView.backgroundColor = SCIColor(red: 16/255.0, green: 25/255.0, blue: 42/255.0, alpha: 1)
        return collectionView
    }()
    
    override var showDefaultModifiersInToolbar: Bool { return false }
    
    override func loadView() {
        view = SCILayoutableView()
        
        guard let collectionViewContainer = self.collectionView.container else { return }
        view.addSubview(collectionViewContainer)
        collectionViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionViewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            collectionViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    override func initExample() {
        for i in 0..<itemsCount {
            dataSet.append(getRandomItem(index: i, pointCount: 50))
        }
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
    
    #if os(OSX)
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        view.window?.delegate = self
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        guard let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: SparkLinesItemReuseIdentifier), for: indexPath) as? SparkLinesCollectionViewItem else { fatalError() }
        item.configure(with: dataSet[indexPath.item])
        
        return item
    }
    
    #elseif os(iOS)
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let item = collectionView.dequeueReusableCell(withReuseIdentifier: SparkLinesItemReuseIdentifier, for: indexPath) as? SparkLinesCollectionViewItem else { fatalError() }
        item.configure(with: dataSet[indexPath.item])
        
        return item
    }
    #endif
    
    func collectionView(_ collectionView: SCICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSet.count
    }
    
    func collectionView(_ collectionView: SCICollectionView, layout collectionViewLayout: SCICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let collectionViewWidth = collectionView.container?.bounds.size.width else {
            return CGSize.zero
        }
        let itemHeight: CGFloat = 50
        #if os(OSX)
        return CGSize(width: max(collectionViewWidth, 650), height: itemHeight)
        #elseif os(iOS)
        return CGSize(width: collectionViewWidth, height: itemHeight)
        #endif
    }
}


#if os(OSX)
extension SparkLinesChartView: NSWindowDelegate {
    func windowDidResize(_ notification: Notification) {
        collectionView.collectionViewLayout?.invalidateLayout()
    }
}
#endif
