//
//  SCDSourceCodeCell.m
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 6/22/16.
//  Copyright © 2016 ABT. All rights reserved.
//

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
