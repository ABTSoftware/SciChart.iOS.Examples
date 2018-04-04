//
//  SCDSegmentSearch.m
//  SciChartDemo
//
//  Created by Gkol on 11/28/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import "SCDSegmentSearchView.h"

@interface SCDSegmentSearchView ()

@property (nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end

@implementation SCDSegmentSearchView

+ (SCDSegmentSearchView *)createFromNib {
    SCDSegmentSearchView *view = [[[NSBundle mainBundle] loadNibNamed:@"SCDSegmentSearchView" owner:nil options:nil] firstObject];
    return view;
}

- (IBAction)didSelect:(id)sender {
    if (_delegate) {
        [_delegate didSelectIndex:_segmentControl.selectedSegmentIndex];
    }
}

- (void)setSelectedIndex:(NSInteger)index {
    _segmentControl.selectedSegmentIndex = index;
}

@end
