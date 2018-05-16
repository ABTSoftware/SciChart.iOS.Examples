//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCDSourceCodeCell.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "SCDSourceCodeCell.h"
#import "SCDSourceCodeItem.h"

@implementation SCDSourceCodeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    UIView* separatorLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 3, 2)];
    
    [separatorLineView setBackgroundColor:[UIColor colorWithRed:0.110
                                                          green:0.110
                                                           blue:0.110
                                                          alpha:1]];
    [self setBackgroundColor:[UIColor colorWithRed:0.196
                                             green:0.208
                                              blue:0.227
                                             alpha:1]];
    
    [self.contentView addSubview:separatorLineView];
}

- (void)setupWithItem:(SCDSourceCodeItem *)item {
    self.fileNameLabel.text = item.fileName;
    self.descriptionLabel.text = item.descr;
}

@end
