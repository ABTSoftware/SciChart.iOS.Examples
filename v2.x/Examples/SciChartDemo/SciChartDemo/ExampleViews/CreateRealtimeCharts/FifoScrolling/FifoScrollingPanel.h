//
//  FifoScrollingPanel.h
//  SciChartDemo
//
//  Created by Yaroslav Pelyukh on 5/1/17.
//  Copyright © 2017 ABT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FifoPanelCallback)();

@interface FifoScrollingPanel : UIView

@property (nonatomic, copy) FifoPanelCallback playCallback;
@property (nonatomic, copy) FifoPanelCallback pauseCallback;
@property (nonatomic, copy) FifoPanelCallback stopCallback;

- (IBAction)playPressed:(UIButton *)sender;
- (IBAction)pausePressed:(UIButton *)sender;
- (IBAction)stopPressed:(UIButton *)sender;

@end
