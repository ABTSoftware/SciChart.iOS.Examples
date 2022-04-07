//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2020. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDMainMenuView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDMainMenuView.h"
#import "SCDMainMenuLayout.h"
#import "SCDMenuSeparatorView.h"

@implementation SCDMainMenuView {
    SCDMainMenuLayout *_flowLayout;
}

@synthesize collectionView = _collectionView;

- (UICollectionView *)collectionView {
    if (_collectionView == nil) {
        _flowLayout = [SCDMainMenuLayout new];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_flowLayout];
        _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _collectionView.contentInset = UIEdgeInsetsZero;
        _collectionView.backgroundColor = UIColor.clearColor;
    }
    return _collectionView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self p_SCD_setupView];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self p_SCD_setupView];
    }
    return self;
}

- (void)p_SCD_setupView {
    [self addSubview:self.collectionView];
    [self.collectionView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [self.collectionView.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.collectionView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize collectionSize = self.collectionView.frame.size;
    if (UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation)) {
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.itemSize = CGSizeMake(collectionSize.width, collectionSize.height / 3.0);
        _flowLayout.separatorSize = CGSizeMake(collectionSize.width * 0.8, 0.5);
    } else {
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(collectionSize.width / 3.0, collectionSize.height);
        _flowLayout.separatorSize = CGSizeMake(0.5, collectionSize.height * 0.8);
    }
    
    [_flowLayout prepareLayout];
    [_flowLayout invalidateLayout];
}

@end
