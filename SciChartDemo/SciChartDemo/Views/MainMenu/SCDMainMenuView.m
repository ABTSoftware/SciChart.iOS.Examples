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
#import "SCDMainMenuViewController.h"

@implementation SCDMainMenuView {
    SCDMainMenuLayout *_flowLayout;
}

@synthesize collectionView = _collectionView;
@synthesize backgroundImage = _backgroundImage;
@synthesize topLogo = _topLogo;

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

- (UIImageView *)backgroundImage {
    if (_backgroundImage == nil) {
        _backgroundImage = [UIImageView new];
        _backgroundImage.tintColor = UIColor.whiteColor;
        _backgroundImage.translatesAutoresizingMaskIntoConstraints = NO;
        _backgroundImage.image = [UIImage imageNamed:@"chart.background"];
    }
    return _backgroundImage;
}

- (UIImageView *)topLogo {
    if (_topLogo == nil) {
        _topLogo = [UIImageView new];
        _topLogo.tintColor = UIColor.whiteColor;
        _topLogo.translatesAutoresizingMaskIntoConstraints = NO;
        _topLogo.image = [UIImage imageNamed:@"navibarLogo"];
    }
    return _topLogo;
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
    [self addSubview:self.backgroundImage];
    [self addSubview:self.topLogo];
    [self sendSubviewToBack: self.backgroundImage];
    [self.topLogo.topAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.topAnchor constant:15].active = YES;
    [self.topLogo.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active = YES;
    [self.collectionView.leadingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.leadingAnchor].active = YES;
    [self.collectionView.topAnchor constraintEqualToAnchor:self.topLogo.bottomAnchor constant:10].active = YES;
    [self.collectionView.trailingAnchor constraintEqualToAnchor:self.safeAreaLayoutGuide.trailingAnchor].active = YES;
    [self.collectionView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
    [self.backgroundImage.leadingAnchor constraintEqualToAnchor:self.leadingAnchor].active = YES;
    [self.backgroundImage.topAnchor constraintEqualToAnchor:self.topAnchor].active = YES;
    [self.backgroundImage.trailingAnchor constraintEqualToAnchor:self.trailingAnchor].active = YES;
    [self.backgroundImage.bottomAnchor constraintEqualToAnchor:self.bottomAnchor].active = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize collectionSize = self.collectionView.frame.size;
    if (UIInterfaceOrientationIsPortrait(UIApplication.sharedApplication.statusBarOrientation)) {
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.itemSize = CGSizeMake(collectionSize.width, 180);
    } else {
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(collectionSize.width / 3, collectionSize.height);
    }
    [_flowLayout prepareLayout];
    [_flowLayout invalidateLayout];
    
}

@end
