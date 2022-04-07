//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDTypeAliases.swift is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#if os(OSX)
typealias SCIView = NSView
typealias SCISlider = NSSlider
typealias SCIColor = NSColor
typealias SCIImage = NSImage
typealias SCIImageView = NSImageView
typealias SCIFontDescriptor = NSFontDescriptor
typealias SCIEdgeInsets = NSEdgeInsets
typealias SCICollectionView = NSCollectionView
typealias SCICollectionViewCell = NSCollectionViewItem
typealias SCICollectionViewDataSource = NSCollectionViewDataSource
typealias SCICollectionViewLayout = NSCollectionViewLayout
typealias SCICollectionViewFlowLayout = NSCollectionViewFlowLayout
typealias SCICollectionViewDelegateFlowLayout = NSCollectionViewDelegateFlowLayout
typealias SCILabel = NSLabel
typealias SCIStackView = NSStackView
typealias SCIGestureRecognizer = NSGestureRecognizer
typealias SCIPanGestureRecognizer = NSPanGestureRecognizer
typealias SCITapGestureRecognizer = NSClickGestureRecognizer
#elseif os(iOS)
typealias SCIView = UIView
typealias SCISlider = UISlider
typealias SCIColor = UIColor
typealias SCIImage = UIImage
typealias SCIImageView = UIImageView
typealias SCIFontDescriptor = UIFontDescriptor
typealias SCIEdgeInsets = UIEdgeInsets
typealias SCICollectionView = UICollectionView
typealias SCICollectionViewCell = UICollectionViewCell
typealias SCICollectionViewDataSource = UICollectionViewDataSource
typealias SCICollectionViewLayout = UICollectionViewLayout
typealias SCICollectionViewFlowLayout = UICollectionViewFlowLayout
typealias SCICollectionViewDelegateFlowLayout = UICollectionViewDelegateFlowLayout
typealias SCILabel = UILabel
typealias SCIStackView = UIStackView
typealias SCIGestureRecognizer = UIGestureRecognizer
typealias SCIPanGestureRecognizer = UIPanGestureRecognizer
typealias SCITapGestureRecognizer = UITapGestureRecognizer
#endif
