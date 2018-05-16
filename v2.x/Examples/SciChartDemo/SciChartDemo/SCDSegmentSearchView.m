//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSegmentSearchView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

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
