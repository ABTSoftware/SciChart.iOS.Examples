//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// ExampleTableViewCell.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <UIKit/UIKit.h>
#import "SCDExampleItem.h"

@interface ExampleTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *ExampleIcon;
@property (strong, nonatomic) IBOutlet UILabel *ExampleName;
@property (strong, nonatomic) IBOutlet UILabel *ExampleDescription;
@property (strong) NSString *ExampleFile;

- (void)setupWithItem:(SCDExampleItem*)item;

@end
