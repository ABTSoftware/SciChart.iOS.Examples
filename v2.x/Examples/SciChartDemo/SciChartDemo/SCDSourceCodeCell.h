//
//  SCDSourceCodeCell.h
//  SciChartDemo
//
//  Created by Mykola Hrybeniuk on 6/22/16.
//  Copyright © 2016 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCDSourceCodeItem;

@interface SCDSourceCodeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fileNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)setupWithItem:(SCDSourceCodeItem*)item;

@end
