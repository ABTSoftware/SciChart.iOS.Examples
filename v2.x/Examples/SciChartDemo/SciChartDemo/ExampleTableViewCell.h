//
//  ExampleTableViewCell.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 2/3/16.
//  Copyright © 2016 SciChart Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCDExampleItem.h"

@interface ExampleTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ExampleIcon;
@property (strong, nonatomic) IBOutlet UILabel *ExampleName;
@property (strong, nonatomic) IBOutlet UILabel *ExampleDescription;
@property (strong) NSString *ExampleFile;

- (void)setupWithItem:(SCDExampleItem*)item;

@end
