//
//  ExampleTableViewCell.m
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 2/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import "ExampleTableViewCell.h"

@implementation ExampleTableViewCell

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

- (void)setupWithItem:(SCDExampleItem *)item {
    self.ExampleDescription.text = item.exampleDescription;
    self.ExampleName.text = item.exampleName;
    self.ExampleIcon.image = [UIImage imageNamed:item.exampleIcon];
    self.ExampleFile = item.exampleFile;
}

@end
