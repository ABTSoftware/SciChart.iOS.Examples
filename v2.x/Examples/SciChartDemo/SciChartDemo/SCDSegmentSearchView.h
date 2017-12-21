//
//  SCDSegmentSearch.h
//  SciChartDemo
//
//  Created by Gkol on 11/28/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCDSegmentSearchViewDelegate <NSObject>

@required
- (void)didSelectIndex:(NSInteger)selectedIndex;

@end

@interface SCDSegmentSearchView : UIView

@property (nonatomic) id<SCDSegmentSearchViewDelegate> delegate;

+ (SCDSegmentSearchView*)createFromNib;

- (void)setSelectedIndex:(NSInteger)index;

@end
