//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMainMenuViewController.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMainMenuViewController.h"
#import "SCDMainMenuView.h"
#import "SCDMenuItemCell.h"


@implementation SCDMainMenuViewController {
    SCDMainMenuView *_mainMenuView;
    NSArray<id<ISCDMenuItem>> *_items;
}

- (instancetype)initWitItems:(NSArray<id<ISCDMenuItem>> *)items {
    self = [super init];
    if (self) {
        _items = items;
    }
    return self;
}

- (void)loadView {
    _mainMenuView = [SCDMainMenuView new];
    _mainMenuView.collectionView.dataSource = self;
    _mainMenuView.collectionView.delegate = self;
    [_mainMenuView.collectionView registerClass:SCDMenuItemCell.class forCellWithReuseIdentifier:SCDMenuItemCell.reuseId];
    
    self.view = _mainMenuView;
}
- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [_mainMenuView.collectionView reloadData];
}

// MARK: - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SCDMenuItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SCDMenuItemCell.reuseId forIndexPath:indexPath];
    [cell updateCell];
    SCDMenuItem *menuItem = _items[indexPath.row];
    [cell updateWithMenuItem:menuItem];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _items[indexPath.item].action();
}

@end
